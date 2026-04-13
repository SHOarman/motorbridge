import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'accident_report_tab.dart';
import '../../../utils/app_text_styles.dart';

class SafetyFirstView extends StatelessWidget {
  const SafetyFirstView({super.key});

  @override
  Widget build(BuildContext context) {
    final AccidentReportTabController controller = Get.put(AccidentReportTabController());

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffFFF7ED), // Light orange background as in image
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFF97316), // Orange border
                width: 1.5,
              ),
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
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "The information and guidelines provided in this Road Traffic Accident Report form are for informational purposes only and are intended to help you in a difficult situation.",
                    style: AppTextStyles.smallText.copyWith(
                      fontSize: 14,
                      color: const Color(0xFF334155),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "This form is provided as a convenience tool to assist you in documenting accident details. Motor Bridge UK takes no liability for the accuracy, completeness, or suitability of the information collected through this form. By using this form, you acknowledge that you do so entirely at your own risk. Motor Bridge UK shall not be held responsible for any decisions made or actions taken based on the information or guidance provided through this tool.",
                    style: AppTextStyles.smallText.copyWith(
                      fontSize: 14,
                      color: const Color(0xFF334155),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "In the event of a serious accident with injuries, always contact emergency services immediately (999) and follow the advice of qualified professionals.",
                    style: AppTextStyles.smallText.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFFFED7AA)),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () => controller.toggleAcceptance(!controller.isAccepted.value),
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => SizedBox(
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
                        )),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "I understand and accept these terms. I acknowledge that I use this form entirely at my own risk and that Motor Bridge UK accepts no liability.",
                            style: AppTextStyles.smallText.copyWith(
                              fontSize: 13,
                              height: 1.5,
                              color: const Color(0xFF475569),
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

          // Your Safety is the Priority Card
          Container(
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
                          color: const Color(0xFFFF3B30), // Vibrant red icon background
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
                    "Call 999 immediately if anyone is injured. Do not move injured people unless they're in immediate danger."
                  ),
                  _buildSafetyStep(
                    "2", 
                    "Make the Scene Safe", 
                    "Turn on hazard lights, use warning triangles if safe to do so, and move to a safe location away from traffic."
                  ),
                  _buildSafetyStep(
                    "3", 
                    "Call the Police if Needed", 
                    "You must call the police if there are injuries, the road is blocked, or the other driver doesn't stop."
                  ),
                  _buildSafetyStep(
                    "4", 
                    "Exchange Information", 
                    "Get names, addresses, phone numbers, insurance details, and vehicle registration from all parties involved. Take photos of the scene and damage."
                  ),
                  _buildSafetyStep(
                    "5", 
                    "Don't Admit Fault", 
                    "Never admit fault at the scene. Stick to facts when describing what happened. Let the insurance companies determine liability."
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 10,),
          // Remember Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF), // Light blue background
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
                children: [
                  const TextSpan(
                    text: "Remember: ",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const TextSpan(
                    text: "This tool helps you document the accident for your insurance claim. It's not a substitute for calling emergency services if needed.",
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Next Button
          Obx(() => SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: controller.isAccepted.value 
                ? () => controller.nextTab() 
                : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFF2563EB).withValues(alpha: 0.5),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    "Next",
                    style: AppTextStyles.bigText.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          )),
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
              color: Color(0xFFFF3B30), // Match the header red
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
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
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: AppTextStyles.smallText.copyWith(
                    fontSize: 14,
                    color: const Color(0xFF64748B),
                    height: 1.5,
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
