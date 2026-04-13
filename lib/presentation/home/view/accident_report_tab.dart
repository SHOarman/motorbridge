import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/app_text_styles.dart';

import 'saftyfast.dart';
import 'accidentdetails.dart';
import 'otherparties.dart';
import 'witnesses.dart';
import 'photos.dart';
import 'summary.dart';

class AccidentReportTabController extends GetxController {
  var selectedIndex = 0.obs;
  var isAccepted = false.obs;
  var completedTabs = <int>{}.obs;

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

  // Accident Details Form Data
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
  var accidentPhotos = <XFile>[].obs;

  Future<void> pickImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        accidentPhotos.addAll(images);
      }
    } catch (e) {
      debugPrint("Error picking images: $e");
    }
  }

  bool isCompleted(int index) => completedTabs.contains(index);
}

class AccidentReportTab extends StatelessWidget {
  const AccidentReportTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if controller is already registered, if not, put it
    final AccidentReportTabController controller = Get.put(AccidentReportTabController());

    final List<Map<String, dynamic>> tabs = [
      {
        'name': 'Safety First',
        'icon': Icons.warning_amber_rounded,
        'view': const SafetyFirstView()
      },
      {
        'name': 'Accident Details',
        'icon': Icons.description_outlined,
        'view': const AccidentDetailsView()
      },
      {
        'name': 'Other Parties',
        'icon': Icons.people_outline,
        'view': const OtherPartiesView()
      },
      {
        'name': 'Witnesses',
        'icon': Icons.visibility_outlined,
        'view': const WitnessesView()
      },
      {
        'name': 'Photos',
        'icon': Icons.photo_library_outlined,
        'view': const PhotosVideosView()
      },
      {
        'name': 'Summary',
        'icon': Icons.summarize_outlined,
        'view': const SummaryView()
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button Section
                  GestureDetector(
                    onTap: () => Get.back(),
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
                  
                  // ONLY the Icon Tab area is now a Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                      child: Obx(() => Row(
                        children: List.generate(tabs.length, (index) {
                          bool isSelected = controller.selectedIndex.value == index;
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
                                        ? const Color(0xFF2563EB) // Blue for selected
                                        : controller.isCompleted(index)
                                          ? const Color(0xFF00C950) // Green for completed
                                          : const Color(0xFFF1F5F9), // Grey for others
                                      shape: BoxShape.circle,
                                      boxShadow: isSelected ? [
                                        BoxShadow(
                                          color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        )
                                      ] : controller.isCompleted(index) ? [
                                        BoxShadow(
                                          color: const Color(0xFF00C950).withValues(alpha: 0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        )
                                      ] : null,
                                    ),
                                    child: Icon(
                                      tabs[index]['icon'],
                                      color: (isSelected || controller.isCompleted(index)) ? Colors.white : const Color(0xFF64748B),
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: 80, // Increased width for better text flow
                                    child: Text(
                                      tabs[index]['name'],
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.visible, // Ensure text is visible
                                      style: AppTextStyles.smallText.copyWith(
                                        fontSize: 11, // Slightly smaller font for better fit
                                        height: 1.2,
                                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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
                      )),
                    ),
                  ),


                ],
              ),
            ),
            
            // Content Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: KeyedSubtree(
                    key: ValueKey(controller.selectedIndex.value),
                    child: tabs[controller.selectedIndex.value]['view'],
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
