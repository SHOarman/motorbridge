import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api_sevices/api_services.dart';

class HomeController extends GetxController {
  var vehiclesList = <dynamic>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVehicles();
  }

  Future<void> fetchVehicles() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? userId = prefs.getString('userId');

      if (token == null || token.isEmpty) {
        isLoading.value = false;
        return;
      }

      // If userId is missing, fetch the profile to get it
      if (userId == null || userId.isEmpty) {
        final profileResponse = await http.get(
          Uri.parse(ApiServices.user_profile),
          headers: {"Authorization": "Bearer $token"},
        );
        if (profileResponse.statusCode == 200) {
          var profileData = jsonDecode(profileResponse.body);
          var data = profileData;
          if (profileData is Map && profileData.containsKey('data') && profileData['data'] != null) {
            data = profileData['data'];
          }
          userId = (data['id'] ?? data['_id'] ?? "").toString();
          if (userId.isNotEmpty) {
            await prefs.setString('userId', userId);
          }
        }
      }

      if (userId == null || userId.isEmpty) {
        isLoading.value = false;
        return;
      }

      // Fetch vehicles for this user
      final response = await http.get(
        Uri.parse("${ApiServices.baseurl}/api/vehicle/userId/$userId"),
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("fetchVehicles status: ${response.statusCode}");
      debugPrint("fetchVehicles body: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          vehiclesList.value = List<dynamic>.from(responseData['data']);
        }
      }
    } catch (e) {
      debugPrint("Error fetching vehicles: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
