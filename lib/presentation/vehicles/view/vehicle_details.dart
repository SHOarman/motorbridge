import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import 'package:motorbridge/general_widget/customappbar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:motorbridge/presentation/vehicles/widget/running_costs_card.dart';
import 'package:motorbridge/presentation/vehicles/widget/vehicle_documents_card.dart';
import 'package:motorbridge/utils/app_text_styles.dart';
import 'package:motorbridge/utils/app_sizes.dart';
import '../../reminders/widget/custom_text.dart';
import '../widget/custom_vehicle_field.dart';
import 'viewallexpensesaddnew.dart';
import '../../../core/services/api_sevices/api_services.dart';
import '../../../core/services/controller/home_controller.dart';

class VehicleDetails extends StatefulWidget {
  const VehicleDetails({super.key});

  @override
  State<VehicleDetails> createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails> {
  late Map<String, dynamic> vehicle;
  bool isEditing = false;
  bool isSaving = false;

  List<dynamic> documents = [];
  bool isLoadingDocs = false;

  List<dynamic> allExpenses = [];
  bool isLoadingCosts = false;

  late TextEditingController makeController;
  late TextEditingController modelController;
  late TextEditingController yearController;
  late TextEditingController regController;
  
  late TextEditingController engineSizeController;
  late TextEditingController vinController;
  late TextEditingController v5cController;
  late TextEditingController fuelTypeController;
  late TextEditingController bodyTypeController;
  late TextEditingController engineCodeController;

  @override
  void initState() {
    super.initState();
    vehicle = Get.arguments ?? {};
    
    makeController = TextEditingController(text: vehicle['make']?.toString() ?? '');
    modelController = TextEditingController(text: vehicle['model']?.toString() ?? '');
    yearController = TextEditingController(text: vehicle['year']?.toString() ?? '');
    regController = TextEditingController(text: vehicle['registration']?.toString() ?? '');
    
    engineSizeController = TextEditingController(text: vehicle['engineSize']?.toString() ?? '');
    vinController = TextEditingController(text: vehicle['vin']?.toString() ?? '');
    v5cController = TextEditingController(text: vehicle['v5cDocumentNumber']?.toString() ?? '');
    fuelTypeController = TextEditingController(text: vehicle['fuelType']?.toString() ?? '');
    bodyTypeController = TextEditingController(text: vehicle['bodyType']?.toString() ?? '');
    engineCodeController = TextEditingController(text: vehicle['engineCode']?.toString() ?? '');

    fetchDocuments();
    fetchCostsSummary();
  }

  Future<void> _updateVehicleDate(String field, String title) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');
        String vehicleId = (vehicle['id'] ?? vehicle['_id'] ?? '').toString().trim();

        if (vehicleId.isEmpty) return;

        var request = http.MultipartRequest(
          'PATCH', 
          Uri.parse("${ApiServices.update_vehicle}/$vehicleId")
        );
        
        request.headers['Authorization'] = 'Bearer $token';
        request.fields[field] = formattedDate;

        debugPrint("Sending PATCH to: ${ApiServices.update_vehicle}/$vehicleId");
        debugPrint("Updating field: $field with value: $formattedDate");

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        debugPrint("Update Vehicle Response Code: ${response.statusCode}");
        debugPrint("Update Vehicle Response Body: ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          bool updatedState = false;
          try {
            var parsed = jsonDecode(response.body);
            if (parsed['data'] != null && parsed['data'] is Map) {
              setState(() {
                vehicle = Map<String, dynamic>.from(parsed['data']);
              });
              updatedState = true;
            }
          } catch (e) {
            // parse error
          }
          
          if (!updatedState) {
            try {
              var getRes = await http.get(
                Uri.parse("${ApiServices.get_vehicle_by_id}/$vehicleId"),
                headers: {'Authorization': 'Bearer $token'},
              );
              if (getRes.statusCode == 200) {
                var getParsed = jsonDecode(getRes.body);
                if (getParsed['data'] != null) {
                  setState(() {
                    vehicle = Map<String, dynamic>.from(getParsed['data']);
                  });
                  updatedState = true;
                }
              }
            } catch (e) {}
          }
          
          if (!updatedState) {
            setState(() {
              vehicle[field] = formattedDate;
            });
          }

          Get.snackbar("Success", "$title updated successfully!", backgroundColor: Colors.green, colorText: Colors.white);
          
          if (Get.isRegistered<HomeController>()) {
            Get.find<HomeController>().fetchVehicles();
          }
        } else {
          Get.snackbar("Error", "Failed to update $title");
        }
      } catch (e) {
        debugPrint("Error updating vehicle: $e");
        Get.snackbar("Error", "Something went wrong: $e");
      }
    }
  }

  Future<void> fetchDocuments() async {
    if (!mounted) return;
    setState(() {
      isLoadingDocs = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String vehicleId = (vehicle['id'] ?? vehicle['_id'] ?? '').toString().trim();
      
      if (vehicleId.isEmpty) return;

      final response = await http.get(
        Uri.parse("${ApiServices.get_document}?vehicleId=$vehicleId&vehicle=$vehicleId"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      debugPrint("Fetch documents status: ${response.statusCode}");
      debugPrint("Fetch documents body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> allDocs = [];
        if (data is List) {
          allDocs = data;
        } else if (data is Map) {
          allDocs = data['data'] ?? data['documents'] ?? [];
        }
        
        setState(() {
          documents = allDocs.where((doc) {
            if (doc is! Map) return false;
            var v = doc['vehicle'] ?? doc['vehicleId'] ?? doc['vehicle_id'];
            if (v == null) {
              final String docId = (doc['_id'] ?? doc['id'] ?? '').toString();
              if (docId.isNotEmpty) {
                v = prefs.getString("doc_vehicle_$docId");
              }
            }
            v ??= vehicleId;
            
            String docVehicleId = '';
            if (v is Map) {
              docVehicleId = (v['id'] ?? v['_id'] ?? '').toString().trim();
            } else {
              docVehicleId = v.toString().trim();
            }
            
            return vehicleId.isNotEmpty && 
                   docVehicleId.toLowerCase() == vehicleId.toLowerCase();
          }).toList();
        });
      }
    } catch (e) {
      debugPrint("Error fetching documents: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoadingDocs = false;
        });
      }
    }
  }

  Future<void> fetchCostsSummary() async {
    if (!mounted) return;
    setState(() {
      isLoadingCosts = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String targetVehicleId = (vehicle['id'] ?? vehicle['_id'] ?? '').toString().trim();

      if (targetVehicleId.isEmpty) return;

      final response = await http.get(
        Uri.parse("${ApiServices.get_const}?vehicleId=$targetVehicleId&vehicle=$targetVehicleId"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      debugPrint("Fetch costs summary status: ${response.statusCode}");
      debugPrint("Fetch costs summary body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> fetchedList = [];
        if (decoded is List) {
          fetchedList = decoded;
        } else if (decoded is Map) {
          fetchedList = decoded['data'] ?? [];
        }

        final filteredList = fetchedList.where((item) {
          if (item is! Map) return false;
          var v = item['vehicle'] ?? item['vehicleId'] ?? item['vehicle_id'];
          if (v == null) {
            final String costId = (item['_id'] ?? item['id'] ?? '').toString();
            if (costId.isNotEmpty) {
              v = prefs.getString("cost_vehicle_$costId");
            }
          }
          v ??= targetVehicleId;
          
          String itemVehicleId = '';
          if (v is Map) {
            itemVehicleId = (v['id'] ?? v['_id'] ?? '').toString().trim();
          } else {
            itemVehicleId = v.toString().trim();
          }
          return targetVehicleId.isNotEmpty && 
                 itemVehicleId.toLowerCase() == targetVehicleId.toLowerCase();
        }).toList();

        setState(() {
          allExpenses = filteredList;
        });
      }
    } catch (e) {
      debugPrint("Error fetching costs summary: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoadingCosts = false;
        });
      }
    }
  }

  String get totalSpent {
    double total = 0.0;
    for (var cost in allExpenses) {
      total += (cost['amount'] ?? 0.0).toDouble();
    }
    return "£${total.toStringAsFixed(2)}";
  }

  String get entriesCount {
    return "${allExpenses.length} entries";
  }

  Map<String, String> getTopCategory() {
    if (allExpenses.isEmpty) {
      return {
        "category": "No Category",
        "amount": "£0.00",
        "percent": "0% of total spent",
      };
    }

    double total = 0.0;
    Map<String, double> categoriesMap = {};
    for (var cost in allExpenses) {
      String cat = (cost['purpose'] ?? 'General').toString().trim();
      if (cat.contains('\u200b')) {
        cat = cat.split('\u200b').first.trim();
      }
      if (cat.isEmpty) cat = 'General';
      cat = cat[0].toUpperCase() + cat.substring(1).toLowerCase();
      double amt = (cost['amount'] ?? 0.0).toDouble();
      total += amt;
      categoriesMap[cat] = (categoriesMap[cat] ?? 0.0) + amt;
    }

    String topCategory = "General";
    double topCategoryAmount = 0.0;
    categoriesMap.forEach((key, val) {
      if (val > topCategoryAmount) {
        topCategoryAmount = val;
        topCategory = key;
      }
    });

    double percent = total == 0.0 ? 0.0 : (topCategoryAmount / total) * 100.0;

    return {
      "category": topCategory,
      "amount": "£${topCategoryAmount.toStringAsFixed(2)}",
      "percent": "${percent.toStringAsFixed(0)}% of total spent",
    };
  }

  Future<void> viewDocument(Map<String, dynamic> doc) async {
    String? fileUrl;
    if (doc['files'] is List && (doc['files'] as List).isNotEmpty) {
      final last = (doc['files'] as List).last;
      if (last is String) fileUrl = last;
      if (last is Map) fileUrl = last['url']?.toString() ?? last['path']?.toString();
    } else if (doc['files'] is String) {
      fileUrl = doc['files'];
    } else if (doc['file'] is String) {
      fileUrl = doc['file'];
    } else if (doc['url'] is String) {
      fileUrl = doc['url'];
    }

    if (fileUrl == null || fileUrl.isEmpty) {
      Get.snackbar("Error", "No document link available",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    String fullFileUrl = fileUrl;
    if (fileUrl.startsWith('/uploads/')) {
      fullFileUrl = "${ApiServices.baseurl}$fileUrl";
    }

    try {
      final uri = Uri.parse(fullFileUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar("Error", "Could not open document link",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong opening the link: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> _launchExternalUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar("Error", "Could not launch URL",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("Error launching url: $e");
    }
  }

  @override
  void dispose() {
    makeController.dispose();
    modelController.dispose();
    yearController.dispose();
    regController.dispose();
    engineSizeController.dispose();
    vinController.dispose();
    v5cController.dispose();
    fuelTypeController.dispose();
    bodyTypeController.dispose();
    engineCodeController.dispose();
    super.dispose();
  }

  Future<void> deleteDocument(String docId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.delete(
        Uri.parse("${ApiServices.delete_document}/$docId"),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        Get.snackbar("Success", "Document deleted successfully", backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
        fetchDocuments();
      } else {
        Get.snackbar("Error", "Failed to delete document", backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _showDeleteVehicleConfirmation(HomeController homeController) {
    bool isDeleting = false;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: StatefulBuilder(
          builder: (context, setDialogState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  const Text("Remove Vehicle", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                    "Are you sure you want to remove this vehicle and all of its saved components?",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isDeleting ? null : () => Get.back(),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: isDeleting
                              ? null
                              : () async {
                                  String vehicleId = (vehicle['id'] ?? vehicle['_id'] ?? '').toString().trim();
                                  if (vehicleId.isNotEmpty) {
                                    setDialogState(() {
                                      isDeleting = true;
                                    });
                                    bool success = await homeController.deleteVehicle(vehicleId);
                                    if (success) {
                                      Get.back(); // close the dialog
                                      Get.back(); // navigate back to previous screen
                                      Get.snackbar("Success", "Vehicle removed successfully", backgroundColor: Colors.green, colorText: Colors.white);
                                    } else {
                                      setDialogState(() {
                                        isDeleting = false;
                                      });
                                      Get.snackbar("Error", "Failed to remove vehicle", backgroundColor: Colors.red, colorText: Colors.white);
                                    }
                                  }
                                },
                          child: isDeleting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text("Remove", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDeleteDocConfirmation(String docId) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              const Text("Delete Document", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Are you sure you want to delete this document?", textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: () => Get.back(), child: const Text("Cancel"))),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        Get.back();
                        deleteDocument(docId);
                      },
                      child: const Text("Delete", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDocDialog(Map<String, dynamic> doc) {
    final String docId = (doc['_id'] ?? doc['id'] ?? '').toString();
    final TextEditingController titleCtrl = TextEditingController(text: doc['title']?.toString() ?? '');
    PlatformFile? selectedFile;
    Uint8List? fileBytes;
    bool isUpdating = false;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Edit Document", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: "Document Title", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  Text("Selected File: ${selectedFile?.name ?? 'No new file selected (keeps existing)'}"),
                  const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.pickFiles(
                            type: FileType.custom, allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'], withData: kIsWeb,
                          );
                          if (result != null && result.files.isNotEmpty) {
                            final file = result.files.first;
                            Uint8List? bytes;
                            if (kIsWeb) {
                              bytes = file.bytes;
                            } else {
                              if (file.path != null) {
                                try {
                                  bytes = await File(file.path!).readAsBytes();
                                } catch (e) {
                                  debugPrint("Error reading file: $e");
                                }
                              } else {
                                bytes = file.bytes;
                              }
                            }
                            setModalState(() {
                              selectedFile = file;
                              fileBytes = bytes;
                            });
                          }
                        },
                        child: const Text("Pick New File (Optional)"),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff1B4E9F)),
                          onPressed: isUpdating ? null : () async {
                            if (titleCtrl.text.trim().isEmpty) {
                              Get.snackbar("Error", "Title cannot be empty");
                              return;
                            }
                            setModalState(() { isUpdating = true; });
                            try {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              String? token = prefs.getString('token');
                              String targetVehicleId = (vehicle['id'] ?? vehicle['_id'] ?? '').toString().trim();
                              var request = http.MultipartRequest('PATCH', Uri.parse("${ApiServices.update_document}/$docId"));
                              request.headers.addAll({"Authorization": "Bearer $token"});
                              request.fields['title'] = titleCtrl.text.trim();
                              request.fields['vehicle'] = targetVehicleId;
                              request.fields['vehicleId'] = targetVehicleId;
                              request.fields['vehicle_id'] = targetVehicleId;
                              request.fields['userId'] = (prefs.getString('userId') ?? "");
                              
                              debugPrint("Sending PATCH to: ${ApiServices.update_document}/$docId");
                              debugPrint("Title: ${titleCtrl.text.trim()}");
                              debugPrint("Vehicle ID: $targetVehicleId");

                              if (selectedFile != null && fileBytes != null) {
                                String ext = selectedFile!.name.split('.').last.toLowerCase();
                                request.files.add(http.MultipartFile.fromBytes(
                                  'files',
                                  fileBytes!,
                                  filename: selectedFile!.name,
                                  contentType: MediaType(ext == 'pdf' ? 'application' : 'image', ext == 'jpg' ? 'jpeg' : ext),
                                ));
                                debugPrint("Sending file: ${selectedFile!.name} of type $ext, bytes length: ${fileBytes!.length}");
                              } else {
                                debugPrint("No new file selected");
                              }

                          var streamedResponse = await request.send();
                          var response = await http.Response.fromStream(streamedResponse);
                          
                          debugPrint("Update Document Response Code: ${response.statusCode}");
                          debugPrint("Update Document Response Body: ${response.body}");

                          if (response.statusCode == 200 || response.statusCode == 201) {
                            try {
                              var parsed = jsonDecode(response.body);
                              if (parsed is Map && parsed['data'] != null) {
                                final docData = parsed['data'];
                                final String newDocId = (docData['_id'] ?? docData['id'] ?? '').toString();
                                if (newDocId.isNotEmpty && targetVehicleId.isNotEmpty) {
                                  await prefs.setString("doc_vehicle_$newDocId", targetVehicleId);
                                }
                              }
                            } catch (e) {
                              debugPrint("Error parsing update response: $e");
                            }
                            Get.back();
                            Get.snackbar("Success", "Document updated successfully", backgroundColor: Colors.green, colorText: Colors.white);
                            fetchDocuments();
                          } else {
                            Get.snackbar("Error", "Failed to update document: ${response.statusCode}");
                          }
                        } catch (e) {
                          debugPrint("Error updating document: $e");
                          Get.snackbar("Error", "Something went wrong: $e");
                        } finally {
                          setModalState(() { isUpdating = false; });
                        }
                      },
                      child: isUpdating ? const CircularProgressIndicator(color: Colors.white) : const Text("Update Document", style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  Future<void> saveVehicle() async {
    setState(() {
      isSaving = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String vehicleId = vehicle['id'] ?? vehicle['_id'] ?? '';
      
      final response = await http.patch(
        Uri.parse("${ApiServices.baseurl}/api/vehicle/$vehicleId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "vin": vinController.text.trim(),
          "v5cDocumentNumber": v5cController.text.trim(),
          "fuelType": fuelTypeController.text.trim(),
          "bodyType": bodyTypeController.text.trim(),
          "engineSize": engineSizeController.text.trim(),
          "engineCode": engineCodeController.text.trim(),
        }),
      );

      debugPrint("Update vehicle status: ${response.statusCode}");
      debugPrint("Update vehicle response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Vehicle updated successfully!",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        
        var responseData = jsonDecode(response.body);
        if (responseData['data'] != null) {
          setState(() {
            vehicle = responseData['data'];
            isEditing = false;
          });
        } else {
          setState(() {
            vehicle['vin'] = vinController.text.trim();
            vehicle['v5cDocumentNumber'] = v5cController.text.trim();
            vehicle['fuelType'] = fuelTypeController.text.trim();
            vehicle['bodyType'] = bodyTypeController.text.trim();
            vehicle['engineSize'] = engineSizeController.text.trim();
            vehicle['engineCode'] = engineCodeController.text.trim();
            isEditing = false;
          });
        }

        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fetchVehicles();
        }
      } else {
        Get.snackbar("Update Failed", "Server returned status: ${response.statusCode}",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Update Failed", "Something went wrong: $e",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  Map<String, dynamic> getBadgeStyles(String? status) {
    final s = status?.toLowerCase() ?? 'upcoming';
    if (s == 'expired') {
      return {
        'text': 'Expired',
        'bgColor': const Color(0xffDABBBB),
        'textColor': const Color(0xffA61B1B),
        'expiryColor': const Color(0xFFFF0000),
      };
    } else if (s == 'due_soon' || s == 'due soon') {
      return {
        'text': 'Due Soon',
        'bgColor': const Color(0xFFFFA500),
        'textColor': const Color(0xff3F2402),
        'expiryColor': const Color(0xFFFFA500),
      };
    } else {
      return {
        'text': 'Upcoming',
        'bgColor': const Color(0xffD1FADF),
        'textColor': const Color(0xff14B11C),
        'expiryColor': const Color(0xff14B11C),
      };
    }
  }

  Widget _buildVehicleImage(String imagePath) {
    if (imagePath.isEmpty) {
      return Image.asset("assets/image/Rectangle_2-removebg-preview.png", fit: BoxFit.contain);
    }
    
    if (imagePath.startsWith("http://") || imagePath.startsWith("https://")) {
      return Image.network(imagePath, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) {
        return Image.asset("assets/image/Rectangle_2-removebg-preview.png", fit: BoxFit.contain);
      });
    } else if (imagePath.startsWith("/uploads/")) {
      final String fullUrl = "${ApiServices.baseurl}$imagePath";
      return Image.network(fullUrl, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) {
        return Image.asset("assets/image/Rectangle_2-removebg-preview.png", fit: BoxFit.contain);
      });
    } else {
      return Image.asset(imagePath, fit: BoxFit.contain);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppSizes(context);
    const Color primaryColor = Color(0xFF1B4E9F);

    final String imgPath = ApiServices.getFirstImageUrl(vehicle['galleryImages']);

    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());

    final vehicleIndex = homeController.vehiclesList.indexWhere(
      (v) => (v['id'] ?? v['_id'] ?? '').toString() == (vehicle['id'] ?? vehicle['_id'] ?? '').toString()
    );
    final String vehicleTag = vehicleIndex != -1 ? "Vehicle ${vehicleIndex + 1}" : "Vehicle 1";

    // Badges & Expiry Statuses calculated on client side for correct UK date parsing
    final motInfo = homeController.getExpiryInfo(vehicle.cast<String, dynamic>(), 'motExpiry', vehicle['motExpiry']?.toString());
    final taxInfo = homeController.getExpiryInfo(vehicle.cast<String, dynamic>(), 'roadTaxExpiry', vehicle['roadTaxExpiry']?.toString());
    final insInfo = homeController.getExpiryInfo(vehicle.cast<String, dynamic>(), 'insuranceExpiry', vehicle['insuranceExpiry']?.toString());
    final srvInfo = homeController.getExpiryInfo(vehicle.cast<String, dynamic>(), 'serviceDue', vehicle['serviceDue']?.toString());
    final brkInfo = homeController.getExpiryInfo(vehicle.cast<String, dynamic>(), 'breakdownCoverExpiry', vehicle['breakdownCoverExpiry']?.toString());

    final motStyles = getBadgeStyles(motInfo['status']?.toString());
    final taxStyles = getBadgeStyles(taxInfo['status']?.toString());
    final insStyles = getBadgeStyles(insInfo['status']?.toString());
    final srvStyles = getBadgeStyles(srvInfo['status']?.toString());
    final brkStyles = getBadgeStyles(brkInfo['status']?.toString());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: CustomAppBar(
        title: "Vehicle Details",
        backgroundImage: "assets/image/Image__3_-removebg-preview.png",
        leftIcon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 20,
        ),
        onLeftTap: () => Get.back(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: s.vehicleDetailImageHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xff9DBDEE),
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: _buildVehicleImage(imgPath),
                    ),
                    Positioned(
                      top: 15,
                      right: 15,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xffFFF4D0),
                        ),
                        child: Text(
                          vehicleTag,
                          style: AppTextStyles.smallText.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xffFDC209),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${vehicle['make'] ?? ''} ${vehicle['model'] ?? ''}",
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bigText.copyWith(
                        fontSize: 24,
                        color: const Color(0xff2A2A2A),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                "${vehicle['engineCode'] ?? ''}. ${vehicle['year'] ?? ''}",
                style: AppTextStyles.smallText.copyWith(
                  fontSize: 16,
                  color: const Color(0xff888888),
                ),
              ),
              
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xff141414),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(7),
                  color: const Color(0xffFDC209),
                ),
                child: Center(
                  child: Text(
                    vehicle['registration'] ?? '',
                    style: AppTextStyles.bigText.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff2A2A2A),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              CustomReminderCard(
                title: "MOT",
                date: vehicle['motExpiry'] ?? '',
                expiryStatus: motInfo['label'] ?? '',
                vehicleName: motStyles['text'],
                buttonText: "Book Now",
                iconPath: 'assets/icon/Group (4).png',
                buttonIconPath: 'assets/icon/fluent_share-20-filled.svg',
                backgroundColor: Colors.white,
                titleColor: const Color(0xff2A2A2A),
                dateColor: const Color(0xff888888),
                expiryTextColor: motStyles['expiryColor'],
                buttonColor: primaryColor,
                customButtonTextColor: Colors.white,
                badgeBackgroundColor: motStyles['bgColor'],
                badgeTextColor: motStyles['textColor'],
                borderColor: const Color(0xffCECECE),
                onButtonPressed: () => _launchExternalUrl('https://motor-bridge.co.uk/uk-motoring-solutions/garage-services-and-mot/'),
              ),
              const SizedBox(height: 10),
              CustomReminderCard(
                title: "Road Tax",
                date: vehicle['roadTaxExpiry'] ?? '',
                expiryStatus: taxInfo['label'] ?? '',
                vehicleName: taxStyles['text'],
                buttonText: "Pay Tax Online",
                iconPath: 'assets/icon/image 2.png',
                buttonIconPath: 'assets/icon/fluent_share-20-filled.svg',
                backgroundColor: Colors.white,
                titleColor: const Color(0xff2A2A2A),
                dateColor: const Color(0xff888888),
                expiryTextColor: taxStyles['expiryColor'],
                buttonColor: primaryColor,
                customButtonTextColor: Colors.white,
                badgeBackgroundColor: taxStyles['bgColor'],
                badgeTextColor: taxStyles['textColor'],
                borderColor: const Color(0xffCECECE),
                onButtonPressed: () => _launchExternalUrl('https://www.gov.uk/vehicle-tax'),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _updateVehicleDate('insuranceExpiry', 'Insurance'),
                child: CustomReminderCard(
                  title: "Insurance",
                  date: vehicle['insuranceExpiry'] ?? '',
                  expiryStatus: insInfo['label'] ?? '',
                  vehicleName: insStyles['text'],
                  buttonText: "Find Insurance",
                  iconPath: 'assets/icon/image 3.png',
                  buttonIconPath: 'assets/icon/fluent_share-20-filled.svg',
                  backgroundColor: Colors.white,
                  titleColor: const Color(0xff2A2A2A),
                  dateColor: const Color(0xff2A2A2A),
                  expiryTextColor: insStyles['expiryColor'],
                  buttonColor: primaryColor,
                  customButtonTextColor: Colors.white,
                  badgeBackgroundColor: insStyles['bgColor'],
                  badgeTextColor: insStyles['textColor'],
                  borderColor: const Color(0xffCECECE),
                  onButtonPressed: () => _launchExternalUrl('https://motor-bridge.co.uk/uk-motoring-solutions/vehicle-insurance/#vehicleinsurancesolutions'),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _updateVehicleDate('serviceDue', 'Service Due'),
                child: CustomReminderCard(
                  title: "Service Due",
                  date: vehicle['serviceDue'] ?? '',
                  expiryStatus: srvInfo['label'] ?? '',
                  vehicleName: srvStyles['text'],
                  buttonText: "Book Now",
                  iconPath: 'assets/icon/mdi_tools.png',
                  buttonIconPath: 'assets/icon/fluent_share-20-filled.svg',
                  backgroundColor: Colors.white,
                  titleColor: const Color(0xff2A2A2A),
                  dateColor: const Color(0xff888888),
                  expiryTextColor: srvStyles['expiryColor'],
                  buttonColor: primaryColor,
                  customButtonTextColor: Colors.white,
                  badgeBackgroundColor: srvStyles['bgColor'],
                  badgeTextColor: srvStyles['textColor'],
                  borderColor: const Color(0xffCECECE),
                  onButtonPressed: () => _launchExternalUrl('https://motor-bridge.co.uk/uk-motoring-solutions/garage-services-and-mot/'),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _updateVehicleDate('breakdownCoverExpiry', 'Breakdown Cover'),
                child: CustomReminderCard(
                  title: "Breakdown Cover",
                  date: vehicle['breakdownCoverExpiry'] ?? '',
                  expiryStatus: brkInfo['label'] ?? '',
                  vehicleName: brkStyles['text'],
                  buttonText: "Find Cover",
                  iconPath: 'assets/icon/image 4.png',
                  buttonIconPath: 'assets/icon/fluent_share-20-filled.svg',
                  backgroundColor: Colors.white,
                  titleColor: const Color(0xff2A2A2A),
                  dateColor: const Color(0xff888888),
                  expiryTextColor: brkStyles['expiryColor'],
                  buttonColor: primaryColor,
                  customButtonTextColor: Colors.white,
                  badgeBackgroundColor: brkStyles['bgColor'],
                  badgeTextColor: brkStyles['textColor'],
                  borderColor: const Color(0xffCECECE),
                  onButtonPressed: () => _launchExternalUrl('https://motor-bridge.co.uk/uk-motoring-solutions/breakdown-and-recovery/'),
                ),
              ),
              const SizedBox(height: 20),
              
              CustomVehicleField(
                label: "Engine Size",
                hintText: "e.g., 1998cc",
                controller: engineSizeController,
                readOnly: true,
              ),
              CustomVehicleField(
                label: "Vin Number",
                hintText: "e.g., WBA...",
                controller: vinController,
                readOnly: !isEditing,
              ),
              CustomVehicleField(
                label: "V5C Document Number",
                hintText: "e.g., Egne1221",
                controller: v5cController,
                readOnly: !isEditing,
              ),
              CustomVehicleField(
                label: "Fuel Type",
                hintText: "e.g., Petrol",
                controller: fuelTypeController,
                readOnly: true,
              ),
              CustomVehicleField(
                label: "Body Type",
                hintText: "e.g., Hatchback",
                controller: bodyTypeController,
                readOnly: !isEditing,
              ),
              CustomVehicleField(
                label: "Engine Number",
                hintText: "e.g., 2611",
                controller: engineCodeController,
                readOnly: !isEditing,
              ),
              
              if (!isEditing)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Edit",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                )
              else ...[
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : () => saveVehicle(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isSaving ? "Saving..." : "Save Changes",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: isSaving ? null : () => _showDeleteVehicleConfirmation(homeController),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete_forever, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          "Remove Vehicle",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: isSaving ? null : () {
                      setState(() {
                        isEditing = false;
                        engineSizeController.text = vehicle['engineSize']?.toString() ?? '';
                        vinController.text = vehicle['vin']?.toString() ?? '';
                        v5cController.text = vehicle['v5cDocumentNumber']?.toString() ?? '';
                        fuelTypeController.text = vehicle['fuelType']?.toString() ?? '';
                        bodyTypeController.text = vehicle['bodyType']?.toString() ?? '';
                        engineCodeController.text = vehicle['engineCode']?.toString() ?? '';
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 20),
              RunningCostsCard(
                iconPath: "assets/icon/Icon (18).png",
                trendIconPath: "assets/icon/Icon (19).png",
                repairIconPath: "assets/icon/Icon (20).png",
                arrowIconPath: "assets/icon/Icon (21).png",
                totalSpent: totalSpent,
                entriesCount: entriesCount,
                topExpenseName: getTopCategory()['category']!,
                topExpenseAmount: getTopCategory()['amount']!,
                topExpensePercent: getTopCategory()['percent']!,
                onPressed: () async {
                  await Get.to(() => const ViewAllExpensesAddNew(), arguments: vehicle);
                  fetchCostsSummary();
                },
              ),
              const SizedBox(height: 20),
              VehicleDocumentsCard(
                documents: documents,
                isLoading: isLoadingDocs,
                onAddTap: () async {
                  String vehicleId = vehicle['id'] ?? vehicle['_id'] ?? '';
                  await Get.toNamed(AppRoutes.addDocuments, arguments: vehicleId);
                  fetchDocuments();
                },
                onViewTap: (doc) {
                  viewDocument(doc);
                },
                onEditTap: (doc) {
                  _showEditDocDialog(doc);
                },
                onDeleteTap: (doc) {
                  final String docId = (doc['_id'] ?? doc['id'] ?? '').toString();
                  if (docId.isNotEmpty) _showDeleteDocConfirmation(docId);
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
