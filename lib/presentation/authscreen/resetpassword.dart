import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import 'package:motorbridge/core/services/controller/authcontroller.dart';
import 'package:motorbridge/presentation/authscreen/widget/customtextfield.dart';

import '../../general_widget/customtaxbutton.dart';
import '../../utils/app_text_styles.dart';

class Resetpassword extends StatelessWidget {
  Resetpassword({super.key});

  final AuthController controller = Get.find<AuthController>();
  final String email = Get.arguments['email'] ?? '';
  final String code = Get.arguments['code'] ?? '';
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_sharp)),
        backgroundColor: const Color(0xFFF5F6F8),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 70),
              Center(
                child: Text(
                  "Reset Password",
                  style: AppTextStyles.bigText.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                title: "New Password",
                hintText: "**********",
                controller: newPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                title: "Confirm Password",
                hintText: "**********",
                controller: confirmPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 50),
              Obx(
                () => CustomButton(
                  text: "Confirm",
                  isLoading: controller.isLoading.value,
                  onTap: () async {
                    if (newPasswordController.text.isEmpty) {
                      Get.snackbar("Error", "Please enter new password");
                      return;
                    }
                    if (newPasswordController.text != confirmPasswordController.text) {
                      Get.snackbar("Error", "Passwords do not match");
                      return;
                    }
                    bool success = await controller.resetPassword(
                      email: email,
                      code: code,
                      newPassword: newPasswordController.text,
                    );
                    if (success) {
                      Get.offAllNamed(AppRoutes.singin);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
