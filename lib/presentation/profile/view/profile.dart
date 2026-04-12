import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import 'package:motorbridge/general_widget/customtaxbutton.dart';
import 'package:motorbridge/utils/app_text_styles.dart';
import '../../../general_widget/custom_bottom_nav_bar.dart';
import '../../../general_widget/customappbar.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 3),
      appBar: CustomAppBar(
        title: "Profile",
        backgroundImage: "assets/image/appbar.png",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Color(0xffF6F6F6),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: Color(0xffB0CEFF), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff0000001F).withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                    spreadRadius: 2,
                    blurStyle: BlurStyle.normal,
                  ),
                ],
              ),

              child: Stack(
                children: [
                  Positioned(
                    child: Image.asset("assets/image/Ellipse 7.png"),
                    left: 20,
                    top: 20,
                  ),

                  Positioned(
                    top: 20,
                    left: 140,

                    child: Text(
                      "Tanvir Hasan",
                      style: AppTextStyles.bigText.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2A2A2A),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 140,

                    child: Text(
                      "tanvirhasan@gmail.com",
                      style: AppTextStyles.smallText.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff2A2A2A),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 70,
                    left: 140,

                    child: Text(
                      "+44 113 529 5112",
                      style: AppTextStyles.smallText.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff2A2A2A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20,),
            
            CustomButton(text: "Edit Profile", onTap: (){
              Get.toNamed(AppRoutes.editprofile);
            },imagePath: "assets/icon/mingcute_edit-line.png",),
            SizedBox(height: 20,),

            Text("My Vehicles", style: AppTextStyles.bigText.copyWith(fontSize: 20, fontWeight: FontWeight.w500),),
            SizedBox(height: 10,),

            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xffB6C0D1),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: Color(0xffB0CEFF), width: 1),
                boxShadow: [
                  BoxShadow(

                    offset: Offset(0, 4),color: Color(0xff0000000D),
                    spreadRadius: 0,
                    blurRadius: 8.9
                  )

                ]


              ),

            )
          ],
        ),
      ),
    );
  }
}
