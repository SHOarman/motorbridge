import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api_sevices/api_services.dart';

class AuthController extends GetxController {
  var isAgreed = false.obs;
  var isLoading = false.obs;
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void toggleAgreement() {
    isAgreed.value = !isAgreed.value;
  }

  Future<bool> registerUser({required String name, required String email, required String password}) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse("${ApiServices.baseurl}${ApiServices.register}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Registration successful!");
        return true;
      } else {
        var error = jsonDecode(response.body);
        Get.snackbar("Error", error['message'] ?? "Registration failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> verifyEmail({required String email, required String code}) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse("${ApiServices.baseurl}${ApiServices.verif_email}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "verificationCode": code
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Email verified successfully!");
        return true;
      } else {
        var error = jsonDecode(response.body);
        Get.snackbar("Error", error['message'] ?? "Verification failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> loginUser({required String email, required String password}) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse("${ApiServices.baseurl}${ApiServices.login}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password
        }),
      );

      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        String token = '';
        if (responseData['data'] != null && responseData['data']['accessToken'] != null) {
          token = responseData['data']['accessToken'];
        }

        print("================ User Token ================");
        print(token.isEmpty ? "Token missing in response structure" : token);
        print("============================================");

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('email', email);
        await prefs.setBool('isLoggedIn', true);

        isLoggedIn.value = true;
        Get.snackbar("Success", "Login successful!");
        return true;
      } else {
        var error = jsonDecode(response.body);
        Get.snackbar("Error", error['message'] ?? "Login failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> forgotPassword({required String email}) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse("${ApiServices.baseurl}${ApiServices.forgotPassword}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Reset code sent to your email.");
        return true;
      } else {
        var error = jsonDecode(response.body);
        Get.snackbar("Error", error['message'] ?? "Failed to send code");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> verifyResetCode({required String email, required String code}) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse("${ApiServices.baseurl}${ApiServices.verify_code}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "code": code
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Code verified!");
        return true;
      } else {
        var error = jsonDecode(response.body);
        Get.snackbar("Error", error['message'] ?? "Invalid code");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> resetPassword({required String email, required String code, required String newPassword}) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse("${ApiServices.baseurl}${ApiServices.resetPassword}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "code": code,
          "newPassword": newPassword
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Password reset successfully!");
        return true;
      } else {
        var error = jsonDecode(response.body);
        Get.snackbar("Error", error['message'] ?? "Failed to reset password");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    isLoggedIn.value = false;
    Get.snackbar("Logout", "Logged out successfully");
  }
}