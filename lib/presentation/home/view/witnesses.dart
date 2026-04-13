import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'accident_report_tab.dart';
import '../../../utils/app_text_styles.dart';

class WitnessesView extends StatelessWidget {
  const WitnessesView({super.key});

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
                // Header with "Add Witness"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Witness Information",
                      style: AppTextStyles.bigText.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        minimumSize: Size.zero,
                        elevation: 0,
                      ),
                      child: const Text("Add Witness",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Record details of anyone who saw the accident",
                  style: AppTextStyles.smallText.copyWith(
                    fontSize: 14,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 25),

                // Witness 1 Card (Nested)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Witness 1",
                        style: AppTextStyles.bigText.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Name & Phone
                      Row(
                        children: [
                          Expanded(
                              child: _buildLabelWithIcon(
                                  "Full Name", Icons.person_outline)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildLabel("Phone Number")),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                              child: _buildTextField("Jane Doe",
                                  (v) => controller.witnessFullName.value = v)),
                          const SizedBox(width: 16),
                          Expanded(
                              child: _buildTextField("07123 456789",
                                  (v) => controller.witnessPhone.value = v)),
                        ],
                      ),

                      const SizedBox(height: 16),
                      _buildLabel("Email Address"),
                      const SizedBox(height: 8),
                      _buildTextField("jane@example.com",
                          (v) => controller.witnessEmail.value = v),

                      const SizedBox(height: 16),
                      _buildLabel("Statement"),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (v) => controller.witnessStatement.value = v,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText:
                              "What did they witness? Record their account of events...",
                          hintStyle: const TextStyle(
                              color: Color(0xFF94A3B8), fontSize: 13),
                          fillColor: const Color(0xFFF1F5F9),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF1E293B)),
                      ),
                    ],
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
                        Text("Previous",
                            style: AppTextStyles.smallText
                                .copyWith(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: Obx(() {
                    bool isValid =
                        controller.witnessFullName.value.isNotEmpty &&
                            controller.witnessPhone.value.isNotEmpty;
                    return ElevatedButton(
                      onPressed: isValid ? () => controller.nextTab() : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            const Color(0xFF2563EB).withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Next",
                              style: AppTextStyles.smallText.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          const SizedBox(width: 10),
                          const Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.smallText.copyWith(
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1E293B),
        fontSize: 13,
      ),
    );
  }

  Widget _buildLabelWithIcon(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF64748B)),
        const SizedBox(width: 6),
        _buildLabel(label),
      ],
    );
  }

  Widget _buildTextField(String hint, Function(String) onChanged) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
        fillColor: const Color(0xFFF1F5F9),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
    );
  }
}
