import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/services/controller/add_document_controller.dart';
import 'package:motorbridge/general_widget/customappbar.dart';
import 'package:motorbridge/presentation/vehicles/widget/custom_vehicle_field.dart';

class AddDocument extends GetView<AddDocumentController> {
  const AddDocument({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensuring controller is initialized
    Get.put(AddDocumentController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Add Document",
        backgroundImage: "assets/image/Image__3_-removebg-preview.png",
        onLeftTap: () {
          Get.back();
        },
        leftIcon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const CustomVehicleField(
                label: "Document Label",
                hintText: "e.g., MOT Certificate , Insurance",
              ),
              const SizedBox(height: 10),
              const Text(
                "Select File",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff4A4A4A),
                ),
              ),
              const SizedBox(height: 12),
              Obx(() => GestureDetector(
                    onTap: () => controller.pickFile(),
                    child: DottedBorder(
                      color: const Color(0xffD0D0D0),
                      strokeWidth: 1,
                      dashPattern: const [6, 3],
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Icon(
                              controller.selectedFile.value == null
                                  ? Icons.file_upload_outlined
                                  : Icons.insert_drive_file_outlined,
                              size: 32,
                              color: controller.selectedFile.value == null
                                  ? const Color(0xff4A4A4A)
                                  : const Color(0xFF1B4E9F),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              controller.selectedFile.value == null
                                  ? "Upload File"
                                  : controller.selectedFile.value!.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: controller.selectedFile.value == null
                                    ? const Color(0xff4A4A4A).withValues(alpha: 0.8)
                                    : const Color(0xFF1B4E9F),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
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
                      onPressed: () => controller.uploadDocument(),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF1B4E9F),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Upload",
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
