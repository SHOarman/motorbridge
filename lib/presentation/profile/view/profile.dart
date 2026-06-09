import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import 'package:motorbridge/general_widget/customtaxbutton.dart';
import 'package:motorbridge/utils/app_text_styles.dart';
import '../../../core/services/controller/home_controller.dart';
import '../../../core/services/controller/profile_controller.dart';
import '../../../general_widget/custom_bottom_nav_bar.dart';
import '../../../general_widget/customappbar.dart';
import '../widget/custom_menu_tile.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  final ProfileController controller = Get.isRegistered<ProfileController>()
      ? Get.find<ProfileController>()
      : Get.put(ProfileController());

  final HomeController homeController = Get.isRegistered<HomeController>()
      ? Get.find<HomeController>()
      : Get.put(HomeController());

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
                    controller.deleteAccount();
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

  void _showDeleteVehicleDialog(BuildContext context, String vehicleId) {
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
                Icons.delete_outline,
                color: Color(0xFFFF4343),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                "Delete Vehicle",
                style: AppTextStyles.bigText.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to delete this vehicle? This action cannot be undone.",
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
                    homeController.deleteVehicle(vehicleId);
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
    controller.getProfile(showLoader: false);
    homeController.fetchVehicles();

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 3),
      appBar: CustomAppBar(
        title: "Profile",
        backgroundImage: "assets/image/Image__3_-removebg-preview.png",
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xffF6F6F6),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: const Color(0xffB0CEFF),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(13),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: const Color(0xFFF1F5F9),
                        backgroundImage: controller.profileImageData.value != null
                            ? MemoryImage(controller.profileImageData.value!)
                            : (controller.profileImageUrl.value.isNotEmpty
                                ? NetworkImage(controller.profileImageUrl.value)
                                : null),
                        child: (controller.profileImageData.value == null &&
                                controller.profileImageUrl.value.isEmpty)
                            ? const Icon(
                                Icons.person,
                                size: 40,
                                color: Color(0xFF94A3B8),
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              controller.userName.value.isEmpty
                                  ? "User Name"
                                  : controller.userName.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bigText.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff2A2A2A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              controller.email.value.isEmpty
                                  ? "Email Address"
                                  : controller.email.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.smallText.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff2A2A2A),
                              ),
                            ),
                            if (controller.phone.value.trim().isNotEmpty &&
                                controller.phone.value.trim().toLowerCase() != 'n/a' &&
                                controller.phone.value.trim().toLowerCase() != 'null') ...[
                              const SizedBox(height: 4),
                              Text(
                                controller.phone.value.trim(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.smallText.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff2A2A2A),
                                ),
                              ),
                            ],
                          ],
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
                Obx(() {
                  if (homeController.isLoading.value &&
                      homeController.vehiclesList.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (homeController.vehiclesList.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "No vehicles added yet.",
                        style: AppTextStyles.smallText,
                      ),
                    );
                  }
                  return Column(
                    children: homeController.vehiclesList.map((vehicle) {
                      final String yr = (vehicle['year'] ?? '').toString().trim();
                      final String displayYear = yr.isNotEmpty ? " ($yr)" : "";
                      final String reg = vehicle['registration'] ?? vehicle['registrationNumber'] ?? '';

                      return CustomMenuTile(
                        title:
                            "${vehicle['make'] ?? ''} ${vehicle['model'] ?? ''}$displayYear",
                        subtitle: reg,
                        leading: Image.asset('assets/icon/image 4.png'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'view') {
                              Get.toNamed(AppRoutes.vehicledetails, arguments: vehicle);
                            } else if (value == 'delete') {
                              final String vId = (vehicle['_id'] ?? vehicle['id'] ?? '').toString();
                              if (vId.isNotEmpty) {
                                _showDeleteVehicleDialog(context, vId);
                              }
                            }
                          },
                          icon: const Icon(Icons.more_vert, color: Color(0xFF94A3B8)),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'view',
                              child: Text('View Details'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete Vehicle', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                        onTap: () {
                          Get.toNamed(AppRoutes.vehicledetails, arguments: vehicle);
                        },
                      );
                    }).toList(),
                  );
                }),
                const SizedBox(height: 20),
                Text(
                  "Reports & Documents",
                  style: AppTextStyles.bigText.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                CustomMenuTile(
                  borderColor: const Color.fromRGBO(182, 192, 209, 0.43),
                  title: "View all reports",
                  leading: const Icon(
                    Icons.description,
                    color: Color(0xff2664A3),
                  ),
                  onTap: () => Get.toNamed(AppRoutes.allReports),
                ),
                const SizedBox(height: 20),
                Text(
                  "Settings",
                  style: AppTextStyles.bigText.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
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
                CustomMenuTile(
                  borderColor: const Color.fromRGBO(255, 67, 67, 0.2),
                  title: "Log Out",
                  leading: Image.asset(
                    "assets/icon/material-symbols_logout.png",
                  ),
                  onTap: () => _showLogoutDialog(context),
                  backgroundColor: const Color.fromRGBO(255, 67, 67, 0.2),
                ),
                const SizedBox(height: 5),
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
                const SizedBox(height: 120),
              ],
            ),
          ),
        );
      }),
    );
  }
}
