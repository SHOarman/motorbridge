import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import 'package:motorbridge/general_widget/customtaxbutton.dart';
import 'package:motorbridge/utils/app_colors.dart';
import 'package:motorbridge/utils/app_text_styles.dart';
import 'package:pinput/pinput.dart';

class Verificationcode extends StatelessWidget {
  const Verificationcode({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                "Verification Code",
                style: AppTextStyles.bigText.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 10),
              Text(
                "Enter the verification code we just sent\nyou to your e-mail address",
                textAlign: TextAlign.center,
                style: AppTextStyles.smallText.copyWith(fontSize: 16, color: Color(0xff6B7280)),
              ),
              const SizedBox(height: 50),

              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Color(0xffFFC3A3), width: 1.5),
                  ),
                ),
                onCompleted: (pin) => debugPrint(pin),
              ),

              const SizedBox(height: 50),

              CustomButton(
                text: "Verify Code",
                onTap: () {
                  Get.toNamed(AppRoutes.resetpassword);
                  
                },
                backgroundColor: AppColors.primaryColor,
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Haven’t got the email yet? ",
                    style: AppTextStyles.smallText.copyWith(color: Color(0xff374151),fontSize: 14),
                  ),
                  InkWell(
                    onTap: () {
                      // Resend Logic
                    },
                    child: Text(
                      "Resend Code",
                      style: AppTextStyles.smallText.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}