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
              CustomVehicleField(
                label: "Document Label",
                hintText: "e.g., MOT Certificate , Insurance",
                controller: controller.titleController,
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
              Obx(() {
                final file = controller.selectedFile.value;
                final bytes = controller.fileBytes.value;
                final isPdf = file != null && file.name.toLowerCase().endsWith('.pdf');

                return GestureDetector(
                  onTap: () => controller.pickFile(),
                  child: DottedBorder(
                    color: const Color(0xffD0D0D0),
                    strokeWidth: 1,
                    dashPattern: const [6, 3],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                      child: Column(
                        children: [
                          if (file == null) ...[
                            const Icon(
                              Icons.file_upload_outlined,
                              size: 32,
                              color: Color(0xff4A4A4A),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Upload File (PDF, PNG, JPG)",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff4A4A4A).withValues(alpha: 0.8),
                              ),
                            ),
                          ] else ...[
                            if (isPdf) ...[
                              const Icon(
                                Icons.picture_as_pdf,
                                size: 48,
                                color: Color(0xffE53935),
                              ),
                            ] else if (bytes != null) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  bytes,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ] else ...[
                              const Icon(
                                Icons.insert_drive_file_outlined,
                                size: 48,
                                color: Color(0xFF1B4E9F),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Text(
                              file.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1B4E9F),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${(file.size / 1024).toStringAsFixed(1)} KB",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }),
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
                    child: Obx(() => ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.uploadDocument(),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF1B4E9F),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  "Upload",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        )),
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
