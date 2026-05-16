import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api_sevices/api_services.dart';

class ProfileController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();

  var dob = "".obs;
  var isLoading = false.obs;
  var profileImageData = Rxn<Uint8List>();
  File? selectedImageFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> pickProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImageFile = File(image.path);
      profileImageData.value = await image.readAsBytes();
    }
  }

  Future<void> chooseDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      dob.value = DateFormat('MM/dd/yyyy').format(pickedDate);
    }
  }

  Future<void> getProfile() async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.get(
        Uri.parse("${ApiServices.baseurl}${ApiServices.user_profile}"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var data = responseData['data'];

        fullNameController.text = data['name'] ?? "";
        emailController.text = data['email'] ?? "";
        phoneController.text = data['phone'] ?? "";
        addressController.text = data['address'] ?? "";
        cityController.text = data['city'] ?? "";
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveProfile() async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse("${ApiServices.baseurl}${ApiServices.update_profile}"),
      );

      request.headers.addAll({
        "Authorization": "Bearer $token",
      });

      request.fields['phone'] = phoneController.text;
      request.fields['address'] = addressController.text;
      request.fields['city'] = cityController.text;

      if (selectedImageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profileImage',
          selectedImageFile!.path,
        ));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Profile updated successfully");
        getProfile();
      } else {
        Get.snackbar("Error", "Update failed");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.delete(
        Uri.parse("${ApiServices.baseurl}${ApiServices.delete_account}"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        await prefs.clear();
        Get.offAllNamed('/singin');
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    super.onClose();
  }
}