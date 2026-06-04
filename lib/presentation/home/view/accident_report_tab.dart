import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../core/services/api_sevices/api_services.dart';
import '../../../utils/app_text_styles.dart';

import 'saftyfast.dart';
import 'accidentdetails.dart';
import 'otherparties.dart';
import 'witnesses.dart';
import 'photos.dart';
import 'summary.dart';

class AccidentReportTabController extends GetxController {
  var reportId = "".obs;
  var selectedIndex = 0.obs;
  var isAccepted = false.obs;
  var completedTabs = <int>{}.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      final report = (args['report'] != null && args['report'] is Map && args['report'].isNotEmpty) ? args['report'] : args;
      final summary = args['summary'] ?? {};
      final accidentDetails = summary['accidentDetails'] ?? report['accidentDetails'] ?? args['accidentDetails'] ?? {};
      
      reportId.value = (report['_id'] ?? report['id'] ?? '').toString();
      
      // Load Date and Time
      String fullDateTime = accidentDetails['dateTime'] ?? report['accidentDateTime'] ?? '';
      if (fullDateTime.isNotEmpty) {
        if (fullDateTime.contains('T')) {
          final parts = fullDateTime.split('T');
          accidentDate.value = parts[0];
          if (parts.length > 1) accidentTime.value = parts[1].substring(0, 5);
        } else if (fullDateTime.contains(',')) {
           final parts = fullDateTime.split(', ');
           if (parts.length == 2) {
             final dParts = parts[0].split('/');
             if (dParts.length == 3) accidentDate.value = "${dParts[2]}-${dParts[1]}-${dParts[0]}";
             accidentTime.value = parts[1].substring(0, 5);
           }
        }
      }
      
      location.value = (accidentDetails['location'] ?? report['location'] ?? '').toString();
      whatHappened.value = (accidentDetails['incidentDetails'] ?? report['incidentDetails'] ?? '').toString();
      weatherCondition.value = (accidentDetails['weatherConditions'] ?? report['weatherConditions'] ?? '').toString();
      roadCondition.value = (accidentDetails['roadConditions'] ?? report['roadConditions'] ?? '').toString();
      damageDescription.value = (accidentDetails['damageDescription'] ?? report['damageDescription'] ?? '').toString();
      hasInjuries.value = report['injuries'] == true || report['injuries'] == 'true';
      policeAttended.value = report['policeAttended'] == true || report['policeAttended'] == 'true';

      final thirdParties = report['thirdParties'] as List? ?? [];
      if (thirdParties.isNotEmpty) {
        final tp = thirdParties[0];
        partyFullName.value = (tp['fullName'] ?? '').toString();
        partyPhone.value = (tp['phoneNumber'] ?? '').toString();
        partyEmail.value = (tp['emailAddress'] ?? '').toString();
        partyRegistration.value = (tp['registration'] ?? '').toString();
        partyMake.value = (tp['make'] ?? '').toString();
        partyModel.value = (tp['model'] ?? '').toString();
        partyInsurance.value = (tp['insuranceCompany'] ?? '').toString();
        partyPolicyNumber.value = (tp['policyNumber'] ?? '').toString();
      }

      final witnessesList = report['witnesses'] as List? ?? [];
      if (witnessesList.isNotEmpty) {
        final wt = witnessesList[0];
        witnessFullName.value = (wt['fullName'] ?? '').toString();
        witnessPhone.value = (wt['phoneNumber'] ?? '').toString();
        witnessEmail.value = (wt['emailAddress'] ?? '').toString();
        witnessStatement.value = (wt['statement'] ?? '').toString();
      }
      
      final scenePhotosData = report['scenePhotos'];
      existingPhotos.clear();
      if (scenePhotosData is List) {
        for (var photo in scenePhotosData) {
          if (photo != null && photo.toString().isNotEmpty) {
            existingPhotos.add(photo.toString());
          }
        }
      } else if (scenePhotosData is String && scenePhotosData.isNotEmpty) {
        existingPhotos.add(scenePhotosData);
      }
      
      isAccepted.value = true;
    }
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void toggleAcceptance(bool? value) {
    isAccepted.value = value ?? false;
  }

  void nextTab() {
    if (selectedIndex.value < 5) {
      completedTabs.add(selectedIndex.value);
      selectedIndex.value++;
    }
  }

  void previousTab() {
    if (selectedIndex.value > 0) {
      selectedIndex.value--;
    }
  }

  var accidentDate = "".obs;
  var accidentTime = "".obs;
  var location = "".obs;
  var whatHappened = "".obs;
  var weatherCondition = "".obs;
  var roadCondition = "".obs;
  var damageDescription = "".obs;
  var hasInjuries = false.obs;
  var policeAttended = false.obs;

  void setDate(String date) => accidentDate.value = date;
  void setTime(String time) => accidentTime.value = time;
  void toggleInjuries(bool? val) => hasInjuries.value = val ?? false;
  void togglePolice(bool? val) => policeAttended.value = val ?? false;

  // Third Party Form Data
  var partyFullName = "".obs;
  var partyPhone = "".obs;
  var partyEmail = "".obs;
  var partyAddress = "".obs;
  var partyRegistration = "".obs;
  var partyMake = "".obs;
  var partyModel = "".obs;
  var partyInsurance = "".obs;
  var partyPolicyNumber = "".obs;

  // Witnesses Form Data
  var witnessFullName = "".obs;
  var witnessPhone = "".obs;
  var witnessEmail = "".obs;
  var witnessStatement = "".obs;

  // Photos Form Data
  var existingPhotos = <String>[].obs;
  var accidentPhotos = <XFile>[].obs;

  Future<void> pickImages() async {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Get.back();
                  _pickImagesFromSource(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Get.back();
                  _pickImagesFromSource(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImagesFromSource(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      if (source == ImageSource.camera) {
        final XFile? image = await picker.pickImage(
          source: source,
          imageQuality: 50,
          maxWidth: 1080,
        );
        if (image != null) {
          accidentPhotos.add(image);
        }
      } else {
        final List<XFile> images = await picker.pickMultiImage(
          imageQuality: 50,
          maxWidth: 1080,
        );
        if (images.isNotEmpty) {
          accidentPhotos.addAll(images);
        }
      }
    } catch (e) {
      debugPrint("Error picking images: $e");
    }
  }

  var lastErrorMessage = "".obs;

  Future<bool> submitReport() async {
    try {
      isLoading.value = true;
      lastErrorMessage.value = "";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final isUpdate = reportId.value.isNotEmpty;
      var request = http.MultipartRequest(
        isUpdate ? 'PATCH' : 'POST',
        Uri.parse(isUpdate ? "${ApiServices.update_report}/${reportId.value}" : ApiServices.create_Repot),
      );

      request.headers.addAll({"Authorization": "Bearer $token"});

      // Format DateTime correctly if both are provided, otherwise just send what we have
      if (accidentDate.value.isNotEmpty) {
        String timeStr = accidentTime.value.isNotEmpty ? accidentTime.value : "00:00";
        try {
          // Attempt to format as ISO string or similar if date is in a specific format
          // Assuming date is something like "2026-05-18", time "14:30"
          request.fields['accidentDateTime'] = "${accidentDate.value}T$timeStr:00.000Z";
        } catch (_) {
          request.fields['accidentDateTime'] = accidentDate.value;
        }
      }

      if (location.value.isNotEmpty) request.fields['location'] = location.value;
      if (whatHappened.value.isNotEmpty) request.fields['incidentDetails'] = whatHappened.value;
      if (weatherCondition.value.isNotEmpty) request.fields['weatherConditions'] = weatherCondition.value;
      if (roadCondition.value.isNotEmpty) request.fields['roadConditions'] = roadCondition.value;
      if (damageDescription.value.isNotEmpty) request.fields['damageDescription'] = damageDescription.value;
      request.fields['injuries'] = hasInjuries.value.toString();
      request.fields['policeAttended'] = policeAttended.value.toString();

      // Third Parties
      if (partyFullName.value.isNotEmpty) {
        request.fields['thirdParties[0][fullName]'] = partyFullName.value;
        if (partyPhone.value.isNotEmpty) request.fields['thirdParties[0][phoneNumber]'] = partyPhone.value;
        if (partyEmail.value.isNotEmpty) request.fields['thirdParties[0][emailAddress]'] = partyEmail.value;
        if (partyRegistration.value.isNotEmpty) request.fields['thirdParties[0][registration]'] = partyRegistration.value;
        if (partyMake.value.isNotEmpty) request.fields['thirdParties[0][make]'] = partyMake.value;
        if (partyModel.value.isNotEmpty) request.fields['thirdParties[0][model]'] = partyModel.value;
        if (partyInsurance.value.isNotEmpty) request.fields['thirdParties[0][insuranceCompany]'] = partyInsurance.value;
        if (partyPolicyNumber.value.isNotEmpty) request.fields['thirdParties[0][policyNumber]'] = partyPolicyNumber.value;
      }

      // Witnesses
      if (witnessFullName.value.isNotEmpty) {
        request.fields['witnesses[0][fullName]'] = witnessFullName.value;
        if (witnessPhone.value.isNotEmpty) request.fields['witnesses[0][phoneNumber]'] = witnessPhone.value;
        if (witnessEmail.value.isNotEmpty) request.fields['witnesses[0][emailAddress]'] = witnessEmail.value;
        if (witnessStatement.value.isNotEmpty) request.fields['witnesses[0][statement]'] = witnessStatement.value;
      }

      // Photos
      for (var file in accidentPhotos) {
        String ext = file.name.split('.').last.toLowerCase();
        if (ext != 'jpg' &&
            ext != 'jpeg' &&
            ext != 'png' &&
            ext != 'gif' &&
            ext != 'webp') {
          ext = 'jpeg'; // Fallback
        }
        var fileBytes = await file.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'scenePhotos',
            fileBytes,
            filename: file.name,
            contentType: MediaType('image', ext == 'jpg' ? 'jpeg' : ext),
          ),
        );
      }

      // Preserve existing photos by re-uploading them
      for (String url in existingPhotos) {
        try {
          var response = await http.get(Uri.parse(ApiServices.getFirstImageUrl(url)));
          if (response.statusCode == 200) {
            request.files.add(
              http.MultipartFile.fromBytes(
                'scenePhotos',
                response.bodyBytes,
                filename: 'existing_photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
                contentType: MediaType('image', 'jpeg'),
              ),
            );
          }
        } catch (e) {
          debugPrint("Failed to download existing photo: $e");
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint("======== REPORT DATA SENT TO SERVER ========");
      debugPrint("Fields: ${request.fields}");
      debugPrint("Files: ${request.files.map((f) => '${f.field}: ${f.filename}').toList()}");
      debugPrint("============================================");


      debugPrint("submitReport status: ${response.statusCode}");
      debugPrint("submitReport body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        try {
          var resData = jsonDecode(response.body);
          lastErrorMessage.value =
              resData['message'] ??
              resData['error'] ??
              "Server error: ${response.statusCode}";
        } catch (_) {
          lastErrorMessage.value = "Server error: ${response.statusCode}";
        }
        return false;
      }
    } catch (e) {
      debugPrint("Error in submitReport: $e");
      lastErrorMessage.value = "Connection error: $e";
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  bool isCompleted(int index) => completedTabs.contains(index);
}

class AccidentReportTab extends StatelessWidget {
  const AccidentReportTab({super.key});

  @override
  Widget build(BuildContext context) {
    final AccidentReportTabController controller = Get.put(
      AccidentReportTabController(),
    );

    final List<Map<String, dynamic>> tabs = [
      {
        'name': 'Safety First',
        'icon': Icons.warning_amber_rounded,
        'view': const SafetyFirstView(),
      },
      {
        'name': 'Accident Details',
        'icon': Icons.description_outlined,
        'view': const AccidentDetailsView(),
      },
      {
        'name': 'Other Parties',
        'icon': Icons.people_outline,
        'view': const OtherPartiesView(),
      },
      {
        'name': 'Witnesses',
        'icon': Icons.visibility_outlined,
        'view': const WitnessesView(),
      },
      {
        'name': 'Photos',
        'icon': Icons.photo_library_outlined,
        'view': const PhotosVideosView(),
      },
      {
        'name': 'Summary',
        'icon': Icons.summarize_outlined,
        'view': const SummaryView(),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button Section
                  GestureDetector(
                    onTap: () {
                      Get.delete<AccidentReportTabController>();
                      Get.back();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF475569),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Back to Emergencies",
                          style: AppTextStyles.smallText.copyWith(
                            fontSize: 16,
                            color: const Color(0xFF475569),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Title
                  Text(
                    "Road Traffic Accident Report",
                    style: AppTextStyles.bigText.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Subtitle
                  Text(
                    "Document the accident scene and collect important information.",
                    style: AppTextStyles.smallText.copyWith(
                      fontSize: 15,
                      color: const Color(0xFF64748B),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 15),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Obx(
                        () => Row(
                          children: List.generate(tabs.length, (index) {
                            bool isSelected =
                                controller.selectedIndex.value == index;
                            return Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(
                                              0xFF2563EB,
                                            ) // Blue for selected
                                          : controller.isCompleted(index)
                                          ? const Color(
                                              0xFF00C950,
                                            ) // Green for completed
                                          : const Color(
                                              0xFFF1F5F9,
                                            ), // Grey for others
                                      shape: BoxShape.circle,
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFF2563EB,
                                                ).withValues(alpha: 0.3),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : controller.isCompleted(index)
                                          ? [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFF00C950,
                                                ).withValues(alpha: 0.2),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Icon(
                                      tabs[index]['icon'],
                                      color:
                                          (isSelected ||
                                              controller.isCompleted(index))
                                          ? Colors.white
                                          : const Color(0xFF64748B),
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width:
                                        80, // Increased width for better text flow
                                    child: Text(
                                      tabs[index]['name'],
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow
                                          .visible, // Ensure text is visible
                                      style: AppTextStyles.smallText.copyWith(
                                        fontSize:
                                            11, // Slightly smaller font for better fit
                                        height: 1.2,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? const Color(0xFF0F172A)
                                            : controller.isCompleted(index)
                                            ? const Color(0xFF00C950)
                                            : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(
                  () => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: KeyedSubtree(
                      key: ValueKey(controller.selectedIndex.value),
                      child: tabs[controller.selectedIndex.value]['view'],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
