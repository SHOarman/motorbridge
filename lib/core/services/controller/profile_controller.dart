import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motorbridge/core/route/app_routes.dart';

class ProfileController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  var dob = "".obs;
  var profileImageData = Rxn<Uint8List>();

  final ImagePicker _picker = ImagePicker();

  Future<void> pickProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      profileImageData.value = bytes;
    }
  }

  Future<void> chooseDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF1B4E9F)),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      dob.value = DateFormat('MM/dd/yyyy').format(pickedDate);
    }
  }

  void saveProfile() {

    Get.toNamed(AppRoutes.profile);

    Get.snackbar(
      "Success", 
      "Profile updated successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withValues(alpha: 0.1),
      colorText: Colors.green[800],
    );
    
    // Return to Profile Page after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      Get.back(); 
    });
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
