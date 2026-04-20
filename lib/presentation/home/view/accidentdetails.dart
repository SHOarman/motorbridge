import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'accident_report_tab.dart';
import '../../../utils/app_text_styles.dart';

class AccidentDetailsView extends StatelessWidget {
  const AccidentDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final AccidentReportTabController controller =
    Get.find<AccidentReportTabController>();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "When and Where Did\nIt Happen?",
                  style: AppTextStyles.bigText.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 25),

                // Date & Time
                Row(
                  children: [
                    Expanded(child: _buildLabelWithIcon("Date", Icons.access_time)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildLabelWithIcon("Time", Icons.access_time)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => GestureDetector(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null) {
                            controller.setDate(DateFormat('yyyy-MM-dd').format(picked));
                          }
                        },
                        child: _buildInputBox(
                          controller.accidentDate.value.isEmpty ? "Select Date" : controller.accidentDate.value,
                          hasText: controller.accidentDate.value.isNotEmpty,
                        ),
                      )),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(() => GestureDetector(
                        onTap: () async {
                          TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            if (!context.mounted) return;
                            controller.setTime(picked.format(context));
                          }
                        },
                        child: _buildInputBox(
                          controller.accidentTime.value.isEmpty ? "Select Time" : controller.accidentTime.value,
                          hasText: controller.accidentTime.value.isNotEmpty,
                        ),
                      )),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                _buildLabelWithIcon("Location", Icons.location_on_outlined),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (val) => controller.location.value = val,
                  decoration: _inputDecoration("Enter your location"),
                  style: _inputTextStyle(),
                ),

                const SizedBox(height: 20),
                Text("What Happened?", style: _labelStyle()),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (val) => controller.whatHappened.value = val,
                  maxLines: 4,
                  decoration: _inputDecoration("Describe the accident in detail..."),
                  style: _inputTextStyle(),
                ),

                const SizedBox(height: 20),
                // --- FIXED ROW ALIGNMENT ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Top align columns
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Weather Conditions",
                            style: _labelStyle(),
                            maxLines: 2, // Ensure same space for both
                          ),
                          const SizedBox(height: 8),
                          _buildDropdown(controller.weatherCondition, [
                            "Clear", "Rainy", "Foggy", "Snowy", "Windy"
                          ]),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Road Conditions",
                            style: _labelStyle(),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 8),
                          _buildDropdown(controller.roadCondition, [
                            "Dry", "Wet", "Icy", "Loose Gravel", "Uneven"
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                Text("Damage Description", style: _labelStyle()),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (val) => controller.damageDescription.value = val,
                  maxLines: 3,
                  decoration: _inputDecoration("Describe the damage..."),
                  style: _inputTextStyle(),
                ),

                const SizedBox(height: 24),
                _buildCheckboxRow("Were there any injuries?", controller.hasInjuries, controller.toggleInjuries),
                const SizedBox(height: 16),
                _buildCheckboxRow("Did the police attend?", controller.policeAttended, controller.togglePolice),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text("Previous"),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: Obx(() {
                    bool isValid = controller.accidentDate.value.isNotEmpty && controller.location.value.isNotEmpty;
                    return ElevatedButton(
                      onPressed: isValid ? () => controller.nextTab() : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text("Next", style: TextStyle(color: Colors.white)),
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

  // Styles using AppTextStyles.internt
  TextStyle _labelStyle() => AppTextStyles.internt.copyWith(
    fontWeight: FontWeight.w600,
    color: const Color(0xff0A0A0A),
    fontSize: 14,
  );

  TextStyle _inputTextStyle() => AppTextStyles.internt.copyWith(
    color: const Color(0xFF1E293B),
    fontSize: 14,
  );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: AppTextStyles.internt.copyWith(color: const Color(0xff717182), fontSize: 13),
    fillColor: const Color(0xFFF1F5F9),
    filled: true,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );

  Widget _buildLabelWithIcon(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF64748B)),
        const SizedBox(width: 8),
        Text(label, style: _labelStyle()),
      ],
    );
  }

  Widget _buildInputBox(String text, {bool hasText = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: _inputTextStyle().copyWith(color: hasText ? null : Colors.grey)),
    );
  }

  Widget _buildDropdown(RxString selectedValue, List<String> items) {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue.value.isEmpty ? null : selectedValue.value,
          hint: Text("Select..", style: AppTextStyles.internt.copyWith(fontSize: 14)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((val) => DropdownMenuItem(value: val, child: Text(val, style: _inputTextStyle()))).toList(),
          onChanged: (val) => selectedValue.value = val ?? "",
        ),
      ),
    ));
  }

  Widget _buildCheckboxRow(String label, RxBool value, Function(bool?) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value.value),
      child: Row(
        children: [
          Obx(() => Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              color: value.value ? const Color(0xFF2563EB) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: value.value ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
          )),
          const SizedBox(width: 12),
          Text(label, style: _labelStyle()),
        ],
      ),
    );
  }
}