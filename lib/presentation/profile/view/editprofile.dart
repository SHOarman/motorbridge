import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/services/controller/profile_controller.dart';
import 'package:motorbridge/general_widget/customappbar.dart';
import 'package:motorbridge/presentation/vehicles/widget/CustomVehicleField.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Edit Profile",
        backgroundImage: "assets/image/appbar.png",
        leftIcon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        onLeftTap: () {
          Get.back();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              
              // Profile Picture Stack
              Center(
                child: GestureDetector(
                  onTap: () => controller.pickProfileImage(),
                  child: Stack(
                    children: [
                      Obx(() => Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                          image: DecorationImage(
                            image: controller.profileImageData.value != null
                                ? MemoryImage(controller.profileImageData.value!)
                                : const AssetImage("assets/image/Rectangle 2.png") as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3876B3),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 30),

              CustomVehicleField(
                label: "Full Name", 
                hintText: "Tanvir Hasan",
                controller: controller.fullNameController,
              ),

              CustomVehicleField(
                label: "E-mail", 
                hintText: "tanvirhasan@gmail.com",
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              // Date of Birth Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Date of Birth",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff4A4A4A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => controller.chooseDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xffD0D0D0), width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => Text(
                            controller.dob.value.isEmpty ? "mm/dd/yyyy" : controller.dob.value,
                            style: TextStyle(
                              color: controller.dob.value.isEmpty ? const Color(0xffA0A0A0) : Colors.black,
                              fontSize: 14,
                            ),
                          )),
                           Image.asset("assets/icon/uis_calender.png", width: 20, height: 20, color: const Color(0xFF1B4E9F))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),

              CustomVehicleField(
                label: "UK Mobile Number", 
                hintText: "+44 xxx xxxxxx",
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 40),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xffD0D0D0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: const Color(0xffF7F7F7),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Color(0xff4A4A4A),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (){
                        controller.saveProfile();

                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF1B4E9F),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
