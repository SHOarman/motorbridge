import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import 'package:motorbridge/general_widget/customtaxbutton.dart';
import 'package:motorbridge/utils/app_text_styles.dart';
import '../../../general_widget/custom_bottom_nav_bar.dart';
import '../../../general_widget/customappbar.dart';
import '../widget/custom_menu_tile.dart';

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
      body: SingleChildScrollView(
        child: Padding(
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
                      color: const Color(0xFF000000).withValues(alpha: 0.05),
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
                      left: 20,
                      top: 20,
                      child: Image.asset("assets/image/Ellipse 7.png"),
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

              SizedBox(height: 20),

              CustomButton(
                text: "Edit Profile",
                onTap: () {
                  Get.toNamed(AppRoutes.editprofile);
                },
                imagePath: "assets/icon/mingcute_edit-line.png",
              ),
              SizedBox(height: 20),

              Text(
                "My Vehicles",
                style: AppTextStyles.bigText.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),

              Column(
                children: [
                  CustomMenuTile(
                    title: "Hilux 2026",
                    subtitle: "2GD-FTV",
                    leading: Image.asset('assets/icon/image 4.png'),
                    onTap: () {},
                  ),

                  // Notification card (Icon shoho)
                  CustomMenuTile(
                    title: "Notifications",
                    leading: Image.asset("assets/icon/image 4 (1).png"),
                    onTap: () {},
                  ),

                  // Privacy & Policy card
                  CustomMenuTile(
                    title: "Privacy & Policy",
                    leading: Image.asset("assets/icon/image 4 (2).png"),
                    onTap: () {},
                  ),

                  // Terms & Conditions card
                  CustomMenuTile(
                    title: "Terms & Conditions",
                    leading: Image.asset("assets/icon/image 4 (3).png"),
                    onTap: () {},
                  ),

                  SizedBox(height: 30),


                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
