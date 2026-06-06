import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import '../api_sevices/api_services.dart';

class AddVehicleController extends GetxController {
  final String baseUrl = "";

  var currentStep = 0.obs;

  var selectedVehicleType = 'Car'.obs;
  final registrationController = TextEditingController();
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  var selectedYear = RxnString();
  var isDvlaLoading = false.obs;
  var isGovDataLoaded = false.obs;

  var motExpiryDate = "".obs;
  var roadTaxExpiryDate = "".obs;
  var insuranceExpiryDate = "".obs;
  var serviceDueDate = "".obs;
  var breakdownExpiryDate = "".obs;

  // More Details Fields
  final vinController = TextEditingController();
  final v5cController = TextEditingController();
  final engineSizeController = TextEditingController();
  final engineCodeController = TextEditingController();
  var selectedFuelType = RxnString();
  var selectedBodyType = RxnString();

  var galleryImages = <XFile>[].obs;
  final ImagePicker _picker = ImagePicker();
  var isSubmitLoading = false.obs;

  void setStep(int step) {
    if (step > currentStep.value) {
      if (!validateCurrentStep()) return;
    }
    currentStep.value = step;
  }

  bool validateCurrentStep() {
    if (currentStep.value == 0) {
      if (registrationController.text.trim().isEmpty) {
        _showValidationError("Registration number is required");
        return false;
      }
      if (makeController.text.trim().isEmpty) {
        _showValidationError("Vehicle Make is required");
        return false;
      }
      if (modelController.text.trim().isEmpty) {
        _showValidationError("Vehicle Model is required");
        return false;
      }
      if (selectedYear.value == null) {
        _showValidationError("Please select the vehicle year");
        return false;
      }
    } else if (currentStep.value == 1) {
      // All date fields (MOT, Road Tax, Insurance, Service, Breakdown) are now optional.
    }
    return true;
  }

  void _showValidationError(String message) {
    Get.snackbar(
      "Required",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
    );
  }

  void setVehicleType(String type) {
    selectedVehicleType.value = type;
  }

  void setFuelType(String value) {
    selectedFuelType.value = value;
  }

  void setBodyType(String value) {
    selectedBodyType.value = value;
  }

  String _formatDvlaDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      DateTime parsed = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(parsed);
    } catch (e) {
      return dateStr;
    }
  }

  Future<void> fetchAndAutofillVehicle() async {
    String regNumber = registrationController.text.trim();
    if (regNumber.isEmpty) {
      _showValidationError("Please enter a registration number");
      return;
    }

    try {
      isDvlaLoading.value = true;

      String dvlaUrl = ApiServices.find_vehicle;

      var response = await http.post(
        Uri.parse(dvlaUrl),
        headers: {
          "x-api-key": dotenv.env['DVLA_API_KEY'] ?? "",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"registrationNumber": regNumber}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        makeController.text = data['make'] ?? '';
        selectedYear.value = data['yearOfManufacture']?.toString();
        selectedFuelType.value = data['fuelType']
            ?.toString()
            .toLowerCase()
            .capitalizeFirst;
        engineSizeController.text = data['engineCapacity'] != null
            ? "${data['engineCapacity']}cc"
            : '';

        motExpiryDate.value = _formatDvlaDate(data['motExpiryDate']);
        roadTaxExpiryDate.value = _formatDvlaDate(data['taxDueDate']);
        
        isGovDataLoaded.value = true;

        Get.snackbar(
          "Success",
          "Vehicle details loaded from DVLA!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Vehicle not found on server",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        isGovDataLoaded.value = false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "API request failed: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      isGovDataLoaded.value = false;
    } finally {
      isDvlaLoading.value = false;
    }
  }

  Future<void> pickImages() async {
    if (galleryImages.length >= 6) {
      Get.snackbar(
        "Limit Exceeded",
        "You can add up to 6 images only.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Get.back();
                  _pickImagesFromSource(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Get.back();
                  _pickImagesFromSource(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImagesFromSource(ImageSource source) async {
    if (source == ImageSource.camera) {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 60,
        maxWidth: 1200,
        maxHeight: 1200,
      );
      if (image != null) {
        galleryImages.add(image);
      }
    } else {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 60,
        maxWidth: 1200,
        maxHeight: 1200,
      );
      if (images.isNotEmpty) {
        if (galleryImages.length + images.length > 6) {
          int availableSlots = 6 - galleryImages.length;
          galleryImages.addAll(images.sublist(0, availableSlots));
          Get.snackbar(
            "Notice",
            "Only $availableSlots images added. Max limit is 6.",
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          galleryImages.addAll(images);
        }
      }
    }
  }

  void removeImage(int index) {
    galleryImages.removeAt(index);
  }

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
      dateVariable.value = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }

  Future<void> submitVehicle() async {
    if (galleryImages.isEmpty) {
      _showValidationError("Please upload at least one vehicle image");
      return;
    }

    try {
      isSubmitLoading.value = true;
      String createUrl = "$baseUrl/api/vehicle/create";

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var request = http.MultipartRequest('POST', Uri.parse(createUrl));

      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields['type'] = selectedVehicleType.value.toLowerCase();
      request.fields['registration'] = registrationController.text.trim();
      request.fields['make'] = makeController.text.trim();
      request.fields['model'] = modelController.text.trim();
      request.fields['year'] = (int.tryParse(selectedYear.value ?? '') ?? 0)
          .toString();

      if (motExpiryDate.value.isNotEmpty)
        request.fields['motExpiry'] = motExpiryDate.value;
      if (roadTaxExpiryDate.value.isNotEmpty)
        request.fields['roadTaxExpiry'] = roadTaxExpiryDate.value;
      if (insuranceExpiryDate.value.isNotEmpty)
        request.fields['insuranceExpiry'] = insuranceExpiryDate.value;
      if (serviceDueDate.value.isNotEmpty)
        request.fields['serviceDue'] = serviceDueDate.value;
      if (breakdownExpiryDate.value.isNotEmpty)
        request.fields['breakdownCoverExpiry'] = breakdownExpiryDate.value;

      request.fields['vin'] = vinController.text.trim();
      request.fields['v5cDocumentNumber'] = v5cController.text.trim();
      if (selectedFuelType.value != null)
        request.fields['fuelType'] = selectedFuelType.value!;
      if (selectedBodyType.value != null)
        request.fields['bodyType'] = selectedBodyType.value!;
      request.fields['engineSize'] = engineSizeController.text.trim();
      request.fields['engineCode'] = engineCodeController.text.trim();

      for (var file in galleryImages) {
        var fileBytes = await file.readAsBytes();
        var multipartFile = http.MultipartFile.fromBytes(
          'galleryImages',
          fileBytes,
          filename: file.name,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Success",
          "Vehicle created successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Future.delayed(const Duration(seconds: 1), () {
          Get.offAllNamed(AppRoutes.home);
        });
      } else {
        Get.snackbar(
          "Submission Failed",
          "Server returned status: ${response.statusCode}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Submission Failed",
        "Something went wrong: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitLoading.value = false;
    }
  }
}
