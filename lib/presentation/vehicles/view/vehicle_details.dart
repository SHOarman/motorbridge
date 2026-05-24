import 'dart:convert';
import 'package:flutter/material.dart';
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
      final first = doc['files'][0];
      if (first is String) fileUrl = first;
      if (first is Map) fileUrl = first['url']?.toString() ?? first['path']?.toString();
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

    // Badges
    final motStyles = getBadgeStyles(vehicle['expiryStatus']?['motExpiry']?['status']?.toString());
    final taxStyles = getBadgeStyles(vehicle['expiryStatus']?['roadTaxExpiry']?['status']?.toString());
    final insStyles = getBadgeStyles(vehicle['expiryStatus']?['insuranceExpiry']?['status']?.toString());
    final srvStyles = getBadgeStyles(vehicle['expiryStatus']?['serviceDue']?['status']?.toString());
    final brkStyles = getBadgeStyles(vehicle['expiryStatus']?['breakdownCoverExpiry']?['status']?.toString());

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
                expiryStatus: vehicle['expiryStatus']?['motExpiry']?['label'] ?? '',
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
                expiryStatus: vehicle['expiryStatus']?['roadTaxExpiry']?['label'] ?? '',
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
              CustomReminderCard(
                title: "Insurance",
                date: vehicle['insuranceExpiry'] ?? '',
                expiryStatus: vehicle['expiryStatus']?['insuranceExpiry']?['label'] ?? '',
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
              const SizedBox(height: 10),
              CustomReminderCard(
                title: "Service Due",
                date: vehicle['serviceDue'] ?? '',
                expiryStatus: vehicle['expiryStatus']?['serviceDue']?['label'] ?? '',
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
              const SizedBox(height: 10),
              CustomReminderCard(
                title: "Breakdown Cover",
                date: vehicle['breakdownCoverExpiry'] ?? '',
                expiryStatus: vehicle['expiryStatus']?['breakdownCoverExpiry']?['label'] ?? '',
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
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
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
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
