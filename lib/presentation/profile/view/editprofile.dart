import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/services/controller/profile_controller.dart';
import 'package:motorbridge/general_widget/customappbar.dart';
import '../../vehicles/widget/custom_vehicle_field.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Edit Profile",
        backgroundImage: "assets/image/Image__3_-removebg-preview.png",
        leftIcon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        onLeftTap: () => Get.back(),
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1B4E9F)))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),

              Center(
                child: GestureDetector(
                  onTap: () => controller.pickProfileImage(),
                  child: Stack(
                    children: [
                      Obx(() {
                        final hasImage = controller.profileImageData.value != null ||
                            controller.profileImageUrl.value.isNotEmpty;
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFF1F5F9),
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                              ),
                            ],
                            image: hasImage
                                ? DecorationImage(
                                    image: controller.profileImageData.value != null
                                        ? MemoryImage(controller.profileImageData.value!)
                                        : NetworkImage(controller.profileImageUrl.value) as ImageProvider,
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: !hasImage
                              ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Color(0xFF94A3B8),
                                )
                              : null,
                        );
                      }),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 34,
                          width: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3876B3),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              CustomVehicleField(
                label: "Full Name",
                hintText: "Enter your full name",
                controller: controller.fullNameController,
              ),

              CustomVehicleField(
                label: "E-mail",
                hintText: "Email address",
                controller: controller.emailController,
                readOnly: true,
              ),

              CustomVehicleField(
                label: "UK Mobile Number",
                hintText: "+44 xxx xxxxxx",
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
              ),

              CustomVehicleField(
                label: "Address",
                hintText: "Your Address",
                controller: controller.addressController,
              ),

              CustomVehicleField(
                label: "City",
                hintText: "Your City",
                controller: controller.cityController,
              ),

              const SizedBox(height: 40),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xffD0D0D0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: const Color(0xffF7F7F7),
                      ),
                      child: const Text("Cancel", style: TextStyle(color: Color(0xff4A4A4A), fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.saveProfile(),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF1B4E9F),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Save Changes", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      )),
    );
  }
}