import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:motorbridge/general_widget/customappbar.dart';
import '../../../utils/app_text_styles.dart';
import '../widget/my_emergency_button.dart';
import 'accident_report_tab.dart';

class MotoringEmergencies extends StatelessWidget {
  const MotoringEmergencies({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Motoring Emergencies",
        backgroundImage: "assets/image/Image__3_-removebg-preview.png",
        onLeftTap: () => Get.back(),
        leftIcon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 20,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffFEF0B5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xff141414),
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/icon/Container (19).png",
                            width: 28,
                            height: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Important Legal Notice",
                            style: AppTextStyles.bigText.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          style: AppTextStyles.smallText.copyWith(
                            fontSize: 14,
                            color: Colors.black,
                            height: 1.5,
                          ),
                          children: [
                            const TextSpan(
                              text:
                              "This page provides quick access to emergency contact numbers and your stored vehicle information. ",
                            ),
                            TextSpan(
                              text:
                              "Always call 999 in a life-threatening emergency.",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          style: AppTextStyles.smallText.copyWith(
                            fontSize: 14,
                            color: Colors.black,
                            height: 1.5,
                          ),
                          children: [
                            const TextSpan(
                              text:
                              "Motor Bridge UK is a reminder and information storage tool only. ",
                            ),
                            const TextSpan(
                              text: "We take no liability",
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            const TextSpan(
                              text:
                              " for the accuracy of contact numbers, policy details, or any decisions made using information stored in this app.",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          style: AppTextStyles.smallText.copyWith(
                            fontSize: 14,
                            height: 1.4,
                              color: Colors.black
                          ),
                          children: [
                            const TextSpan(
                              text: "You are solely responsible",
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            const TextSpan(
                              text:
                              " for ensuring your stored information is accurate and up-to-date. Always verify insurance coverage and breakdown membership details directly with your providers.",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildEmergencyCard(
                title: "UK Emergency Services",
                subtitle: "Police, Fire, Ambulance",
                iconAsset: "assets/icon/Frame (8).png",
                backgroundColor: const Color(0xffFFC8C8),
                buttonColor: const Color(0xFFB71C1C),
                phoneNumber: "999",
              ),
              const SizedBox(height: 16),
              _buildEmergencyCard(
                title: "National Highways",
                subtitle: "Road incidents & breakdowns on Motorways",
                iconAsset: "assets/icon/Frame (9).png",
                backgroundColor: const Color(0xffD9E6FF),
                buttonColor: const Color(0xFF2196F3),
                phoneNumber: "0300 123 5000",
              ),
              const SizedBox(height: 16),
              _buildInsuranceButton(
                phoneNumber: "08000000000",
                iconAsset: "assets/icon/Frame (10).png",
              ),
              const SizedBox(height: 20),

              //====================================addenergebcybutton============================
              MyEmergencyButton(),

              


              const SizedBox(height: 40),
              Text(
                "Vehicle Breakdown",
                style: AppTextStyles.bigText.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icon/Container (20).png",
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Broken down? Need Cover?",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.smallText.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Vehicle Breakdown",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bigText.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xffFF6B35),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Road Traffic Accident",
                style: AppTextStyles.bigText.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Image.asset(
                      "assets/icon/Container (21).png",
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Create New Report",
                      style: AppTextStyles.smallText.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff0A0A0A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Document a new accident and ",
                      style: AppTextStyles.smallText.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff4A5565),
                      ),
                    ),
                    Text(
                      "collect important information",
                      style: AppTextStyles.smallText.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff4A5565),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Material(
                      color: const Color(0xffFF6900),
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => const AccidentReportTab());
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          height: 50,
                          width: 240,
                          alignment: Alignment.center,
                          child: Text(
                            "Start Accident Report",
                            style: AppTextStyles.smallText.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(' ', ''),
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      Get.snackbar(
        "Error",
        "Could not launch phone dialer",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Widget _buildEmergencyCard({
    required String title,
    required String subtitle,
    required String iconAsset,
    required Color backgroundColor,
    required Color buttonColor,
    required String phoneNumber,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
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
          Row(
            children: [
              Image.asset(iconAsset, width: 28, height: 28),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTextStyles.bigText.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D3436),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text(
              subtitle,
              style: AppTextStyles.smallText.copyWith(
                fontSize: 14,
                color: const Color(0xFF636E72),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 44,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _makePhoneCall(phoneNumber),
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icon/Frame (10).png",
                      width: 20,
                      height: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      phoneNumber,
                      style: AppTextStyles.bigText.copyWith(
                        fontSize: 16,
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
    );
  }

  Widget _buildInsuranceButton({
    required String phoneNumber,
    required String iconAsset,
  }) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF0F9D58),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _makePhoneCall(phoneNumber),
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    iconAsset,
                    width: 22,
                    height: 22,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Insurance",
                    style: AppTextStyles.bigText.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                phoneNumber,
                style: AppTextStyles.smallText.copyWith(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}