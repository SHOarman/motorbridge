import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import '../api_sevices/api_services.dart';

class ProfileController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();

  var dob = "".obs;
  var profileImageUrl = "".obs;
  var userName = "".obs;
  var email = "".obs;
  var phone = "".obs;
  var isLoading = false.obs;
  var profileImageData = Rxn<Uint8List>();
  File? selectedImageFile;
  XFile? selectedXFile;
  String userId = "";

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> pickProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedXFile = image;
      if (!kIsWeb) {
        selectedImageFile = File(image.path);
      }
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

  Future<void> getProfile({bool showLoader = true}) async {
    if (showLoader) {
      isLoading.value = true;
    }
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(ApiServices.user_profile),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      debugPrint("getProfile status: ${response.statusCode}");
      debugPrint("getProfile body: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var data = responseData;
        if (responseData is Map && responseData.containsKey('data') && responseData['data'] != null) {
          data = responseData['data'];
        }

        if (data is Map) {
          userId = (data['id'] ?? data['_id'] ?? "").toString();
          if (userId.isNotEmpty) {
            await prefs.setString('userId', userId);
          }
          userName.value = (data['name'] ?? data['fullName'] ?? "").toString();
          fullNameController.text = userName.value;
          email.value = (data['email'] ?? "").toString();
          emailController.text = email.value;
          phone.value = (data['phone'] ?? data['phoneNumber'] ?? data['mobile'] ?? "").toString();
          phoneController.text = phone.value;
          addressController.text = (data['address'] ?? "").toString();
          cityController.text = (data['city'] ?? "").toString();

          var img = (data['profileImage'] ?? data['image'] ?? data['avatar'] ?? "").toString();
          if (img.isNotEmpty) {
            if (!img.startsWith("http")) {
              profileImageUrl.value = "${ApiServices.baseurl}$img";
            } else {
              profileImageUrl.value = img;
            }
          } else {
            profileImageUrl.value = "";
          }
        }
      }
    } catch (e) {
      debugPrint("Error in getProfile: $e");
    } finally {
      if (showLoader) {
        isLoading.value = false;
      }
    }
  }

  Future<void> saveProfile() async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (userId.isEmpty) {
        userId = prefs.getString('userId') ?? "";
      }

      var request = http.MultipartRequest(
        'PATCH',
          Uri.parse('${ApiServices.update_profile}/$userId')      );

      request.headers.addAll({
        "Authorization": "Bearer $token",
      });

      request.fields['name'] = fullNameController.text;
      request.fields['fullName'] = fullNameController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['phoneNumber'] = phoneController.text;
      request.fields['address'] = addressController.text;
      request.fields['city'] = cityController.text;

      if (profileImageData.value != null && selectedXFile != null) {
        String ext = selectedXFile!.name.split('.').last.toLowerCase();
        if (ext != 'jpg' && ext != 'jpeg' && ext != 'png' && ext != 'gif' && ext != 'webp') {
          ext = 'jpeg'; // Fallback to jpeg if extension is unrecognized
        }
        request.files.add(http.MultipartFile.fromBytes(
          'profileImage',
          profileImageData.value!,
          filename: selectedXFile!.name,
          contentType: MediaType('image', ext == 'jpg' ? 'jpeg' : ext),
        ));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint("saveProfile status: ${response.statusCode}");
      debugPrint("saveProfile body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Profile updated successfully");
        userName.value = fullNameController.text;
        email.value = emailController.text;
        phone.value = phoneController.text;
        selectedImageFile = null;
        profileImageData.value = null;
        getProfile();
        Get.offAllNamed('/home');
      } else {
        var errorMsg = "Update failed";
        try {
          var errorData = jsonDecode(response.body);
          errorMsg = errorData['message'] ?? errorMsg;
        } catch (_) {}
        Get.snackbar("Error", errorMsg);
      }
    } catch (e) {
      debugPrint("Error in saveProfile: $e");
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

      if (userId.isEmpty) {
        userId = prefs.getString('userId') ?? "";
      }

      final response = await http.delete(
        Uri.parse("${ApiServices.delete_account}/$userId"),

        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        await prefs.clear();
        Get.toNamed(AppRoutes.home);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

}