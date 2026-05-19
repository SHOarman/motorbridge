import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import 'package:motorbridge/core/services/controller/authcontroller.dart';
import 'package:motorbridge/general_widget/customtaxbutton.dart';
import 'package:motorbridge/utils/app_colors.dart';
import 'package:motorbridge/utils/app_text_styles.dart';
import 'package:pinput/pinput.dart';

class Verificationcode extends StatelessWidget {
  Verificationcode({super.key});

  final AuthController controller = Get.find<AuthController>();
  final String email = Get.arguments['email'] ?? '';
  final bool fromForgot = Get.arguments['fromForgot'] ?? false;
  final TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pinWidth = ((size.width - 40 - 30) / 6).clamp(35.0, 56.0);
    final defaultPinTheme = PinTheme(
      width: pinWidth,
      height: 60,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                "Enter the verification code we just sent\nyou to your e-mail address\n($email)",
                textAlign: TextAlign.center,
                style: AppTextStyles.smallText.copyWith(fontSize: 16, color: const Color(0xff6B7280)),
              ),
              const SizedBox(height: 50),
              Pinput(
                controller: pinController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: const Color(0xffFFC3A3), width: 1.5),
                  ),
                ),
                onCompleted: (pin) => debugPrint(pin),
              ),
              const SizedBox(height: 50),
              Obx(
                () => CustomButton(
                  text: "Verify Code",
                  isLoading: controller.isLoading.value,
                  onTap: () async {
                    if (pinController.text.length < 6) {
                      Get.snackbar("Error", "Please enter 6-digit code");
                      return;
                    }
                    if (fromForgot) {
                      bool success = await controller.verifyResetCode(
                        email: email,
                        code: pinController.text,
                      );
                      if (success) {
                        Get.toNamed(AppRoutes.resetpassword, arguments: {
                          'email': email,
                          'code': pinController.text,
                        });
                      }
                    } else {
                      bool success = await controller.verifyEmail(
                        email: email,
                        code: pinController.text,
                      );
                      if (success) {
                        Get.offAllNamed(AppRoutes.singin);
                      }
                    }
                  },
                  backgroundColor: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Haven’t got the email yet? ",
                    style: AppTextStyles.smallText.copyWith(color: const Color(0xff374151), fontSize: 14),
                  ),
                  InkWell(
                    onTap: () {
                      if (fromForgot) {
                        controller.forgotPassword(email: email);
                      } else {
                        // Resend registration OTP if applicable
                      }
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