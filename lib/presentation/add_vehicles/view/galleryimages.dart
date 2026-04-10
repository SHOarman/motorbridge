import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import 'package:motorbridge/core/services/controller/add_vehicle_controller.dart';


import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../general_widget/customtaxbutton.dart';

class GalleryImagesStep extends GetView<AddVehicleController> {
  const GalleryImagesStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Gallery Images",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => Text(
              "Add up to 6 additional images of your vehicle (current: ${controller.galleryImages.length}/6)",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            )),
            const SizedBox(height: 30),
            
            // Upload Area
            GestureDetector(
              onTap: () => controller.pickImages(),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                dashPattern: const [6, 4],
                color: Colors.grey.shade400,
                strokeWidth: 1.5,
                child: Container(
                  width: double.infinity,
                  height: 160,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upload_outlined,
                        size: 40,
                        color: Colors.black.withValues(alpha: 0.7),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Upload Photo",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Image Preview Grid
            Obx(() => controller.galleryImages.isEmpty
              ? const SizedBox.shrink()
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: controller.galleryImages.length,
                  itemBuilder: (context, index) {
                    final xFile = controller.galleryImages[index];
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color(0xFF1B4E9F),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1B4E9F).withValues(alpha: 0.2),
                                blurRadius: 8,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: kIsWeb
                                ? Image.network(
                                    xFile.path,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  )
                                : Image.file(
                                    File(xFile.path),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                          ),
                        ),
                        Positioned(
                          right: -2,
                          top: -2,
                          child: GestureDetector(
                            onTap: () => controller.removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ),
            
            const SizedBox(height: 40),
            
            // Save Button
            CustomButton(text: "Save & Continue", onTap: (){
              Get.snackbar("Success", "Vehicle saved successfully!");
              Get.toNamed(AppRoutes.home);
            },backgroundColor: Color(0xff3876B3),),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
