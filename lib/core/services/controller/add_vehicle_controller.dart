import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class AddVehicleController extends GetxController {

  var currentStep = 0.obs;
  var selectedVehicleType = 'Car'.obs;
  var galleryImages = <XFile>[].obs;

  // Important Dates
  var motExpiryDate = "".obs;
  var roadTaxExpiryDate = "".obs;
  var insuranceExpiryDate = "".obs;
  var serviceDueDate = "".obs;
  var breakdownExpiryDate = "".obs;

  // Form Fields
  final registrationController = TextEditingController();
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  var selectedYear = RxnString();

  // More Details Fields
  final vinController = TextEditingController();
  final v5cController = TextEditingController();
  final engineSizeController = TextEditingController();
  final engineCodeController = TextEditingController();
  var selectedFuelType = RxnString();
  var selectedBodyType = RxnString();

  final ImagePicker _picker = ImagePicker();

  void setStep(int step) {
    currentStep.value = step;
  }

  void setVehicleType(String type) {
    selectedVehicleType.value = type;
  }

  void setFuelType(String type) {
    selectedFuelType.value = type;
  }

  void setBodyType(String type) {
    selectedBodyType.value = type;
  }

  Future<void> pickImages() async {
    if (galleryImages.length >= 6) {
      Get.snackbar("Limit Reached", "You can only add up to 6 images.");
      return;
    }
    
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      if (galleryImages.length + images.length > 6) {
        galleryImages.addAll(images.take(6 - galleryImages.length));
        Get.snackbar("Partial Upload", "Only the first 6 images were added.");
      } else {
        galleryImages.addAll(images);
      }
    }
  }

  void removeImage(int index) {
    galleryImages.removeAt(index);
  }

  //========================date piker=================================================

  Future<void> chooseDate(BuildContext context, RxString dateVariable) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF2D6A8F)),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      dateVariable.value = DateFormat('MM/dd/yyyy').format(pickedDate);
    }
  }

  @override
  void onClose() {
    registrationController.dispose();
    makeController.dispose();
    modelController.dispose();
    vinController.dispose();
    v5cController.dispose();
    engineSizeController.dispose();
    engineCodeController.dispose();
    super.onClose();
  }
}
