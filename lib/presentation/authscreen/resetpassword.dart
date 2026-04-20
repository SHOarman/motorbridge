import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import 'package:motorbridge/presentation/authscreen/widget/customtextfield.dart';

import '../../general_widget/customtaxbutton.dart';
import '../../utils/app_text_styles.dart';

class Resetpassword extends StatelessWidget {
  const Resetpassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back_sharp)),
        backgroundColor: Color(0xFFF5F6F8),
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

            SizedBox(height: 40,),

            CustomTextField(
              title: "New Password",
              hintText: "**********",
              controller: TextEditingController(),
              isPassword: true,

            ),
            CustomTextField(
              title: "Confirm Password",
              hintText: "**********",
              controller: TextEditingController(),
              isPassword: true,

            ),


            SizedBox(height: 50,),

            CustomButton(text: "Confirm", onTap: (){
              Get.toNamed(AppRoutes.singin);
            })






          ],
        ),
      ),

      ),
    );
  }
}
