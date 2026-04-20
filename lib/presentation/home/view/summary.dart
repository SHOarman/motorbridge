import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                      _buildDetailRow("Date:", "09/04/2026 at 02:47"),
                      const SizedBox(height: 8),
                      _buildDetailRow("Location:", "Not specified"),
                      const SizedBox(height: 8),
                      _buildDetailRow("Description:", "Not specified"),
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
                  child: Text(
                    "Party 1",
                    style: AppTextStyles.internt.copyWith(
                      fontSize: 14,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
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
                  child: Text(
                    "Witness 1",
                    style: AppTextStyles.internt.copyWith(
                      fontSize: 14,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
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
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_back, size: 20),
                        const SizedBox(width: 10),
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
                  child: ElevatedButton(
                    onPressed: () {
                      Get.snackbar(
                        "Success",
                        "Accident report saved successfully!",
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
                        Get.toNamed(AppRoutes.home);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C950),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_outline, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          "Save Report",
                          style: AppTextStyles.internt.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
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
      children: [
        Text(
          label,
          style: AppTextStyles.internt.copyWith(
            fontSize: 14,
            color: const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.internt.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}
