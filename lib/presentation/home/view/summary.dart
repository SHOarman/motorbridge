import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:motorbridge/core/route/app_routes.dart';
import 'accident_report_tab.dart';
import '../../../utils/app_text_styles.dart';

class SummaryView extends StatelessWidget {
  const SummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    final AccidentReportTabController controller =
        Get.find<AccidentReportTabController>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Accident Report Summary",
                  style: AppTextStyles.internt.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 30),

                 // Accident Details Section
                _buildSectionHeader(
                  "Accident Details",
                  Icons.description_outlined,
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Obx(() => _buildDetailRow(
                            "Date:",
                            "${controller.accidentDate.value} at ${controller.accidentTime.value}",
                          )),
                      const SizedBox(height: 8),
                      Obx(() => _buildDetailRow(
                            "Location:",
                            controller.location.value.isEmpty
                                ? "Not specified"
                                : controller.location.value,
                          )),
                      const SizedBox(height: 8),
                      Obx(() => _buildDetailRow(
                            "Description:",
                            controller.whatHappened.value.isEmpty
                                ? "Not specified"
                                : controller.whatHappened.value,
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // Third Parties Section
                _buildSectionHeader("Third Parties (1)", Icons.people_outline),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.partyFullName.value.isEmpty
                                ? "No Third Party"
                                : "Name: ${controller.partyFullName.value}",
                            style: AppTextStyles.internt.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          if (controller.partyPhone.value.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              "Phone: ${controller.partyPhone.value}",
                              style: AppTextStyles.internt.copyWith(
                                fontSize: 13,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                          if (controller.partyRegistration.value.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              "Registration: ${controller.partyRegistration.value}",
                              style: AppTextStyles.internt.copyWith(
                                fontSize: 13,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ],
                      )),
                ),
                const SizedBox(height: 25),

                // Witnesses Section
                _buildSectionHeader("Witnesses (1)", Icons.visibility_outlined),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.witnessFullName.value.isEmpty
                                ? "No Witness"
                                : "Name: ${controller.witnessFullName.value}",
                            style: AppTextStyles.internt.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          if (controller.witnessPhone.value.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              "Phone: ${controller.witnessPhone.value}",
                              style: AppTextStyles.internt.copyWith(
                                fontSize: 13,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                          if (controller.witnessStatement.value.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              "Statement: ${controller.witnessStatement.value}",
                              style: AppTextStyles.internt.copyWith(
                                fontSize: 13,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ],
                      )),
                ),
                const SizedBox(height: 30),

                // Next Steps Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFDCFCE7)),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.internt.copyWith(
                        fontSize: 13,
                        color: const Color(0xFF166534),
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(
                          text: "Next Steps: ",
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const TextSpan(
                          text:
                              "Contact your insurance company and provide them with this information. Keep this report for your records.",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // View Report Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => Get.to(() => const ReportPreviewPage()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.visibility_outlined, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    "View Report Preview",
                    style: AppTextStyles.internt.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Navigation Buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () => controller.previousTab(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      foregroundColor: const Color(0xFF1E293B),
                      padding: EdgeInsets.zero,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_back, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Previous",
                          style: AppTextStyles.internt.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : () async {
                      // Show loading dialog
                      Get.dialog(
                        const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                          ),
                        ),
                        barrierDismissible: false,
                      );

                      bool success = await controller.submitReport();

                      // Dismiss loading dialog
                      Get.back();

                      if (success) {
                        Get.snackbar(
                          "Success",
                          controller.reportId.value.isNotEmpty ? "Accident report updated successfully!" : "Accident report saved successfully!",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: const Color(0xFF00C950),
                          colorText: Colors.white,
                          icon: const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                          margin: const EdgeInsets.all(15),
                          borderRadius: 12,
                          duration: const Duration(seconds: 2),
                        );

                        // Navigate back to Home page after a short delay
                        Future.delayed(const Duration(seconds: 2), () {
                          Get.offAllNamed(AppRoutes.home);
                        });
                      } else {
                        Get.snackbar(
                          "Error",
                          controller.lastErrorMessage.value.isEmpty
                              ? "Failed to save accident report. Please try again."
                              : controller.lastErrorMessage.value,
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                          icon: const Icon(
                            Icons.error,
                            color: Colors.white,
                          ),
                          margin: const EdgeInsets.all(15),
                          borderRadius: 12,
                          duration: const Duration(seconds: 4),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C950),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.zero,
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        controller.isLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.check_circle_outline, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          controller.isLoading.value
                              ? "Saving..."
                              : (controller.reportId.value.isNotEmpty ? "Update Report" : "Save Report"),
                          style: AppTextStyles.internt.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF1E293B)),
        const SizedBox(width: 10),
        Text(
          title,
          style: AppTextStyles.internt.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.internt.copyWith(
            fontSize: 14,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.internt.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }
}

class ReportPreviewPage extends StatelessWidget {
  const ReportPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AccidentReportTabController controller =
        Get.find<AccidentReportTabController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Report Preview",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photos Grid/Carousel
            if (controller.accidentPhotos.isNotEmpty) ...[
              Text(
                "Accident Scene Photos",
                style: AppTextStyles.internt.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.accidentPhotos.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: kIsWeb
                            ? Image.network(
                                controller.accidentPhotos[index].path,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(controller.accidentPhotos[index].path),
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 25),
            ],

            // Accident Details Card
            _buildCard(
              title: "Accident Details",
              icon: Icons.description_outlined,
              children: [
                _buildPreviewRow("Date & Time", "${controller.accidentDate.value} at ${controller.accidentTime.value}"),
                _buildPreviewRow("Location", controller.location.value),
                _buildPreviewRow("Description", controller.whatHappened.value),
                _buildPreviewRow("Weather Conditions", controller.weatherCondition.value),
                _buildPreviewRow("Road Conditions", controller.roadCondition.value),
                _buildPreviewRow("Damage Description", controller.damageDescription.value),
                _buildPreviewRow("Injuries", controller.hasInjuries.value ? "Yes" : "No"),
                _buildPreviewRow("Police Attended", controller.policeAttended.value ? "Yes" : "No"),
              ],
            ),
            const SizedBox(height: 20),

            // Third Party Details Card
            if (controller.partyFullName.value.isNotEmpty) ...[
              _buildCard(
                title: "Third Party Information",
                icon: Icons.people_outline,
                children: [
                  _buildPreviewRow("Full Name", controller.partyFullName.value),
                  _buildPreviewRow("Phone Number", controller.partyPhone.value),
                  _buildPreviewRow("Email Address", controller.partyEmail.value),
                  _buildPreviewRow("Registration", controller.partyRegistration.value),
                  _buildPreviewRow("Make", controller.partyMake.value),
                  _buildPreviewRow("Model", controller.partyModel.value),
                  _buildPreviewRow("Insurance Company", controller.partyInsurance.value),
                  _buildPreviewRow("Policy Number", controller.partyPolicyNumber.value),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // Witness Details Card
            if (controller.witnessFullName.value.isNotEmpty) ...[
              _buildCard(
                title: "Witness Information",
                icon: Icons.visibility_outlined,
                children: [
                  _buildPreviewRow("Full Name", controller.witnessFullName.value),
                  _buildPreviewRow("Phone Number", controller.witnessPhone.value),
                  _buildPreviewRow("Email Address", controller.witnessEmail.value),
                  _buildPreviewRow("Statement", controller.witnessStatement.value),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF2563EB), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.internt.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    if (value.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: AppTextStyles.internt.copyWith(
                fontSize: 14,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.internt.copyWith(
                fontSize: 14,
                color: const Color(0xFF1E293B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
