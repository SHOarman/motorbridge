import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'accident_report_tab.dart';
import '../../../utils/app_text_styles.dart';

class SafetyFirstView extends StatelessWidget {
  const SafetyFirstView({super.key});

  @override
  Widget build(BuildContext context) {
    final AccidentReportTabController controller = Get.put(
      AccidentReportTabController(),
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffFEF0B5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xff141414), width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF97316),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Important Disclaimer",
                        style: AppTextStyles.bigText.copyWith(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff0A0A0A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 1. Informational purposes only section
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.smallText.copyWith(
                        fontSize: 16,
                        color: const Color(0xff0A0A0A),
                        height: 1.6,
                      ),
                      children: [
                        const TextSpan(
                          text:
                              "The information and guidelines provided in this Road Traffic Accident Report form are for ",
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text: "informational purposes only ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const TextSpan(
                          text:
                              "and are intended to help you in a difficult situation.",
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. No liability and Own risk section
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.smallText.copyWith(
                        fontSize: 16,
                        color: const Color(0xff0A0A0A),
                        height: 1.6,
                      ),
                      children: [
                        const TextSpan(
                          text:
                              "This form is provided as a convenience tool to assist you in documenting accident details. ",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(0xff0A0A0A),
                          ),
                        ),
                        TextSpan(
                          text: "Motor Bridge UK takes no liability ",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text:
                              "for the accuracy, completeness, or suitability of the information collected through this form. By using this form, you acknowledge that you do so ",
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text: "entirely at your own risk. ",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text:
                              "Motor Bridge UK shall not be held responsible for any decisions made or actions taken based on the information or guidance provided through this tool.",
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. Emergency Contact text (Size 15)
                  Text(
                    "In the event of a serious accident with injuries, always contact emergency services immediately (999) and follow the advice of qualified professionals.",
                    style: AppTextStyles.smallText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff0A0A0A),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Color(0xff141414), thickness: 2),
                  const SizedBox(height: 15),

                  // 4. Acceptance Checkbox with RichText Bold phrases
                  GestureDetector(
                    onTap: () => controller.toggleAcceptance(
                      !controller.isAccepted.value,
                    ),
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: controller.isAccepted.value,
                              onChanged: controller.toggleAcceptance,
                              activeColor: const Color(0xFFF97316),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.smallText.copyWith(
                                fontSize: 16,
                                height: 1.5,
                                color: const Color(0xff0A0A0A),
                              ),
                              children: [
                                const TextSpan(
                                  text:
                                      "I understand and accept these terms. I acknowledge that I use this form ",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                TextSpan(
                                  text: "entirely at my own risk ",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const TextSpan(text: "and that "),
                                TextSpan(
                                  text: "Motor Bridge UK accepts no liability.",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Safety Steps Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF3B30),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Safety is the Priority",
                              style: AppTextStyles.bigText.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                            Text(
                              "Follow these steps to stay safe at the accident scene",
                              style: AppTextStyles.smallText.copyWith(
                                fontSize: 13,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildSafetyStep(
                    "1",
                    "Check for Injuries",
                    "Call 999 immediately if anyone is injured.",
                  ),
                  _buildSafetyStep(
                    "2",
                    "Make the Scene Safe",
                    "Turn on hazard lights and move to a safe location.",
                  ),
                  _buildSafetyStep(
                    "3",
                    "Call the Police if Needed",
                    "Call if injuries occur or the road is blocked.",
                  ),
                  _buildSafetyStep(
                    "4",
                    "Exchange Information",
                    "Get names, insurance, and take photos.",
                  ),
                  _buildSafetyStep(
                    "5",
                    "Don't Admit Fault",
                    "Stick to the facts. Let insurance companies decide.",
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Remember Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.smallText.copyWith(
                  fontSize: 14,
                  color: const Color(0xFF1E3A8A),
                  height: 1.5,
                ),
                children: const [
                  TextSpan(
                    text: "Remember: ",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  TextSpan(
                    text:
                        "This tool helps you document the accident. It's not a substitute for emergency services.",
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Next Button
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: controller.isAccepted.value
                    ? () => controller.nextTab()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(
                    0xFF2563EB,
                  ).withOpacity(0.5),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSafetyStep(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFFF3B30),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bigText.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: AppTextStyles.smallText.copyWith(
                    fontSize: 14,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
