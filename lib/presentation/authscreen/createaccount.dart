import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/services/controller/authcontroller.dart';
import 'package:motorbridge/presentation/authscreen/widget/customtextfield.dart';
import 'package:motorbridge/presentation/authscreen/widget/socialloginbutton.dart';
import '../../general_widget/customtaxbutton.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';

class Createaccount extends StatelessWidget {
  const Createaccount({super.key});

  @override
  Widget build(BuildContext context) {
    final Authcontroller controller = Get.put(Authcontroller());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70),
              Center(
                child: Text(
                  "Create account",
                  style: AppTextStyles.bigText.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Start your smarter motoring journey today",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.smallText.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                title: "Name",
                hintText: "Type your name...",
                controller: TextEditingController(),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                title: "Email",
                hintText: "Enter your mail...",
                controller: TextEditingController(),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                title: "Password",
                hintText: "**********",
                controller: TextEditingController(),
                isPassword: true,
              ),

              const SizedBox(height: 10),

              //============================= Agree Terms & Conditions ===================================
              Row(
                children: [
                  Obx(
                    () => InkWell(
                      onTap: controller.toggleAgreement,
                      child: Container(
                        decoration: BoxDecoration(
                          color: controller.isAgreed.value
                              ? const Color(0xFFF99D66)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: controller.isAgreed.value
                                ? const Color(0xFFF99D66)
                                : Colors.grey,
                          ),
                        ),
                        child: Icon(
                          Icons.check,
                          size: 18,
                          color: controller.isAgreed.value
                              ? Colors.white
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Agree with ",
                    style: AppTextStyles.smallText.copyWith(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Navigate to Terms screen
                    },
                    child: Text(
                      "Terms & Conditions",
                      style: AppTextStyles.smallText.copyWith(
                        fontSize: 14,
                        color: const Color(0xFF154da1),
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              //========================================================================================
              const SizedBox(height: 30),
              CustomButton(
                text: "Sign Up",
                onTap: () {},
                backgroundColor: AppColors.primaryColor,
              ),

              const SizedBox(height: 40),

              Row(
                children: [
                  const Expanded(
                    child: Divider(color: Color(0xFFE2E8F0), thickness: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Or Sign in with",
                      style: AppTextStyles.smallText.copyWith(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(color: Color(0xFFE2E8F0), thickness: 1),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialLoginButton(
                    imagePath: "assets/icon/google 1.png",
                    onTap: () {},
                  ),
                  const SizedBox(width: 20),
                  SocialLoginButton(
                    imagePath: "assets/icon/google 1 (1).png",
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account",
                    style: AppTextStyles.smallText.copyWith(
                      fontSize: 14,
                      color: const Color(0xff374151),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      "? Sign in",
                      style: AppTextStyles.smallText.copyWith(
                        fontSize: 14,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
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
