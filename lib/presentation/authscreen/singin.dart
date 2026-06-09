import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import 'package:motorbridge/general_widget/customtaxbutton.dart';
import 'package:motorbridge/core/services/controller/authcontroller.dart';
import 'package:motorbridge/presentation/authscreen/widget/customtextfield.dart';
import 'package:motorbridge/presentation/authscreen/widget/socialloginbutton.dart';
import 'package:motorbridge/utils/app_colors.dart';
import 'package:motorbridge/utils/app_text_styles.dart';

class Singin extends StatelessWidget {
  Singin({super.key});

  final AuthController controller = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                  "Sign in",
                  style: AppTextStyles.bigText.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Hi welcome back , You’ve been missed!",
                  style: AppTextStyles.smallText.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                title: "Email",
                hintText: "Enter your E-mail",
                controller: emailController,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                title: "Password",
                hintText: "**********",
                controller: passwordController,
                isPassword: true,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.forgotpassword);
                  },
                  child: Text(
                    "Forgot password?",
                    style: AppTextStyles.smallText.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Obx(
                () => CustomButton(
                  text: "Sign In",
                  isLoading: controller.isLoading.value,
                  onTap: () async {
                    bool success = await controller.loginUser(
                      email: emailController.text.trim(),
                      password: passwordController.text,
                    );
                    if (success) {
                      Get.offAllNamed(AppRoutes.home);
                    }
                  },
                  backgroundColor: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Divider(color: Color(0xFFCECECE), thickness: 1),
                    ),
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
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Divider(color: Color(0xFFCECECE), thickness: 1),
                    ),
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
                    "Don't have an account",
                    style: AppTextStyles.smallText.copyWith(
                      fontSize: 14,
                      color: const Color(0xff374151),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.createaccount);
                    },
                    child: Text(
                      "? Sign Up",
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
