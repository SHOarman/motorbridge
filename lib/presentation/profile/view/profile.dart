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

  // ── Log Out confirmation ───────────────────────────────────────────────────
  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0x33FF4343),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFFF4343),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "Log Out",
              style: AppTextStyles.bigText.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to logout from the app?",
          style: AppTextStyles.smallText.copyWith(
            fontSize: 14,
            color: const Color(0xFF666666),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFDDDDDD)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "Cancel",
                    style: AppTextStyles.smallText.copyWith(
                      fontSize: 14,
                      color: const Color(0xFF555555),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.offAllNamed(AppRoutes.singin);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4343),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: Text(
                    "Log Out",
                    style: AppTextStyles.smallText.copyWith(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Delete Account confirmation ────────────────────────────────────────────
  void _showDeleteDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0x33FF4343),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.delete_forever_rounded,
                color: Color(0xFFFF4343),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                "Delete Account",
                style: AppTextStyles.bigText.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to permanently delete your account? This action cannot be undone.",
          style: AppTextStyles.smallText.copyWith(
            fontSize: 14,
            color: const Color(0xFF666666),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFDDDDDD)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "Cancel",
                    style: AppTextStyles.smallText.copyWith(
                      fontSize: 14,
                      color: const Color(0xFF555555),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.offAllNamed(AppRoutes.singin);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4343),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: Text(
                    "Delete",
                    style: AppTextStyles.smallText.copyWith(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 3),
      appBar: CustomAppBar(
        title: "Profile",
        backgroundImage: "assets/image/Image__3_-removebg-preview.png",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xffF6F6F6),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: const Color(0xffB0CEFF), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                      spreadRadius: 2,
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
                          color: const Color(0xff2A2A2A),
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
                          color: const Color(0xff2A2A2A),
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
                          color: const Color(0xff2A2A2A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Edit Profile",
                onTap: () => Get.toNamed(AppRoutes.editprofile),
                imagePath: "assets/icon/Group.svg",
              ),
              const SizedBox(height: 20),
              Text(
                "My Vehicles",
                style: AppTextStyles.bigText.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              CustomMenuTile(
                title: "Hilux 2026",
                subtitle: "2GD-FTV",
                leading: Image.asset('assets/icon/image 4.png'),
                onTap: () {},
              ),
              CustomMenuTile(
                borderColor: const Color.fromRGBO(182, 192, 209, 0.43),
                title: "Notifications",
                leading: Image.asset("assets/icon/image 4 (1).png"),
                onTap: () {},
              ),
              CustomMenuTile(
                borderColor: const Color.fromRGBO(182, 192, 209, 0.43),
                title: "Privacy & Policy",
                leading: Image.asset("assets/icon/image 4 (2).png"),
                onTap: () {},
              ),
              CustomMenuTile(
                borderColor: const Color.fromRGBO(182, 192, 209, 0.43),
                title: "Terms & Conditions",
                leading: Image.asset("assets/icon/image 4 (3).png"),
                onTap: () {},
              ),
              const SizedBox(height: 10),
              // ── Log Out ──────────────────────────────────────────────────
              CustomMenuTile(
                borderColor: const Color.fromRGBO(255, 67, 67, 0.2),
                title: "Log Out",
                leading: Image.asset("assets/icon/material-symbols_logout.png"),
                onTap: () => _showLogoutDialog(context),
                backgroundColor: const Color.fromRGBO(255, 67, 67, 0.2),
              ),
              const SizedBox(height: 5),
              // ── Delete Account ───────────────────────────────────────────
              CustomMenuTile(
                borderColor: const Color.fromRGBO(255, 67, 67, 0.2),
                title: "Delete Account",
                leading: const Icon(
                  Icons.delete_forever_rounded,
                  color: Color(0xFFFF4343),
                  size: 22,
                ),
                onTap: () => _showDeleteDialog(context),
                backgroundColor: const Color.fromRGBO(255, 67, 67, 0.2),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
