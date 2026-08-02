import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_sevices/api_services.dart';

class TermsController extends GetxController {
  var terms = <dynamic>[].obs;
  var isLoading = true.obs;
  var errorMessage = RxnString();
  var lastUpdatedFormatted = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchTerms();
  }

  Future<void> fetchTerms() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      Map<String, String> headers = {};
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }

      final response = await http.get(
        Uri.parse(ApiServices.get_terms),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] is List) {
          final List listData = responseData['data'];

          DateTime? latestDate;
          for (var item in listData) {
            if (item is Map && item['updatedAt'] != null) {
              try {
                DateTime parsed = DateTime.parse(item['updatedAt'].toString());
                if (latestDate == null || parsed.isAfter(latestDate)) {
                  latestDate = parsed;
                }
              } catch (_) {}
            }
          }

          terms.value = listData;
          if (latestDate != null) {
            lastUpdatedFormatted.value = DateFormat('dd MMMM yyyy').format(latestDate.toLocal());
          }
        } else {
          errorMessage.value = responseData['message'] ?? "Failed to load Terms & Conditions.";
        }
      } else {
        errorMessage.value = "Server error (${response.statusCode}). Please try again later.";
      }
    } catch (e) {
      errorMessage.value = "Network error. Please check your internet connection.";
    } finally {
      isLoading.value = false;
    }
  }
}
