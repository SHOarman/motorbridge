import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import 'package:motorbridge/general_widget/customtaxbutton.dart';
import 'package:motorbridge/presentation/authscreen/widget/customtextfield.dart';

import '../../utils/app_text_styles.dart';

class Forgotpassword extends StatelessWidget {
  const Forgotpassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_sharp),
        ),
        backgroundColor: const Color(0xFFF5F6F8),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70),
              Center(
                child: Text(
                  "Forgot password?",
                  style: AppTextStyles.bigText.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff333333),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  " Enter your e-mail address so we can\n send you a verification code",
                  style: AppTextStyles.smallText.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                title: "Email",
                hintText: "Enter your mail...",
                controller: TextEditingController(),
              ),
              const SizedBox(height: 46),
              CustomButton(
                text: "Send Code",
                onTap: () {
                  Get.toNamed(AppRoutes.verificationcode);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
