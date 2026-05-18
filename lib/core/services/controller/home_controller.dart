import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api_sevices/api_services.dart';

class HomeController extends GetxController {
  var vehiclesList = <dynamic>[].obs;
  var isLoading = false.obs;
  
  // Emergency Contacts
  var emergencyContacts = <dynamic>[].obs;
  var isLoadingContacts = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVehicles();
    fetchEmergencyContacts();
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

  Future<void> fetchEmergencyContacts() async {
    try {
      isLoadingContacts.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        isLoadingContacts.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse(ApiServices.get_number),
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("fetchEmergencyContacts status: ${response.statusCode}");
      debugPrint("fetchEmergencyContacts body: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          emergencyContacts.value = List<dynamic>.from(responseData['data']);
        }
      }
    } catch (e) {
      debugPrint("Error fetching emergency contacts: $e");
    } finally {
      isLoadingContacts.value = false;
    }
  }

  Future<bool> addEmergencyContact({required String contactName, required String contactNumber}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || token.isEmpty) return false;

      final response = await http.post(
        Uri.parse(ApiServices.add_number),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "contactName": contactName,
          "contactNumber": contactNumber,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchEmergencyContacts();
        return true;
      }
    } catch (e) {
      debugPrint("Error adding emergency contact: $e");
    }
    return false;
  }

  DateTime? parseDate(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return null;
    dateStr = dateStr.trim();
    try {
      // Try MM/dd/yyyy
      if (dateStr.contains('/')) {
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          int month = int.parse(parts[0]);
          int day = int.parse(parts[1]);
          int year = int.parse(parts[2]);
          return DateTime(year, month, day);
        }
      }
      // Try yyyy-MM-dd or full ISO
      return DateTime.parse(dateStr);
    } catch (e) {
      debugPrint("Error parsing date '$dateStr': $e");
      return null;
    }
  }

  Map<String, dynamic> computeExpiryInfo(String? dateStr) {
    final date = parseDate(dateStr);
    if (date == null) {
      return {
        'status': 'upcoming',
        'label': '',
      };
    }
    
    final now = DateTime.now();
    // Strip time parts to compare days precisely
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    final difference = targetDate.difference(today).inDays;
    
    if (difference < 0) {
      final absDiff = difference.abs();
      return {
        'status': 'expired',
        'label': 'Expired $absDiff ${absDiff == 1 ? "Day" : "Days"} Ago',
      };
    } else if (difference <= 30) {
      return {
        'status': 'due_soon',
        'label': difference == 0 
            ? 'Expires Today' 
            : 'Expires in $difference ${difference == 1 ? "Day" : "Days"}',
      };
    } else {
      return {
        'status': 'upcoming',
        'label': 'Expires in $difference days',
      };
    }
  }

  Map<String, dynamic> getExpiryInfo(Map<String, dynamic> vehicle, String field, String? dateStr) {
    if (vehicle['expiryStatus'] is Map) {
      final expiryData = vehicle['expiryStatus'] as Map;
      if (expiryData[field] is Map) {
        final info = expiryData[field];
        final status = info['status']?.toString();
        final label = info['label']?.toString();
        if (status != null && label != null) {
          return {
            'status': status,
            'label': label,
          };
        }
      }
    }
    return computeExpiryInfo(dateStr);
  }

  List<Map<String, dynamic>> getReminders() {
    final List<Map<String, dynamic>> list = [];
    
    for (int i = 0; i < vehiclesList.length; i++) {
      final vehicle = vehiclesList[i];
      if (vehicle == null || vehicle is! Map) continue;
      
      final vehicleTag = "Vehicle ${i + 1}";
      
      final fields = [
        {
          'title': 'MOT',
          'field': 'motExpiry',
          'dateKey': 'motExpiry',
          'buttonText': 'Book Now',
          'iconPath': 'assets/icon/Group (4).png',
          'buttonIconPath': 'assets/icon/fluent_share-20-filled.svg',
          'url': 'https://motor-bridge.co.uk/uk-motoring-solutions/garage-services-and-mot/',
        },
        {
          'title': 'Road Tax',
          'field': 'roadTaxExpiry',
          'dateKey': 'roadTaxExpiry',
          'buttonText': 'Pay Tax Online',
          'iconPath': 'assets/icon/image 2.png',
          'buttonIconPath': 'assets/icon/fluent_share-20-filled.svg',
          'url': 'https://www.gov.uk/vehicle-tax',
        },
        {
          'title': 'Insurance',
          'field': 'insuranceExpiry',
          'dateKey': 'insuranceExpiry',
          'buttonText': 'Find Insurance',
          'iconPath': 'assets/icon/image 3.png',
          'buttonIconPath': 'assets/icon/fluent_share-20-filled.svg',
          'url': 'https://motor-bridge.co.uk/uk-motoring-solutions/vehicle-insurance/#vehicleinsurancesolutions',
        },
        {
          'title': 'Service Due',
          'field': 'serviceDue',
          'dateKey': 'serviceDue',
          'buttonText': 'Book Now',
          'iconPath': 'assets/icon/mdi_tools.png',
          'buttonIconPath': 'assets/icon/fluent_share-20-filled.svg',
          'url': 'https://motor-bridge.co.uk/uk-motoring-solutions/garage-services-and-mot/',
        },
        {
          'title': 'Breakdown Cover',
          'field': 'breakdownCoverExpiry',
          'dateKey': 'breakdownCoverExpiry',
          'buttonText': 'Find Cover',
          'iconPath': 'assets/icon/image 4.png',
          'buttonIconPath': 'assets/icon/fluent_share-20-filled.svg',
          'url': 'https://motor-bridge.co.uk/uk-motoring-solutions/breakdown-and-recovery/',
        },
      ];
      
      for (final f in fields) {
        final dateStr = (vehicle[f['dateKey']] ?? '').toString().trim();
        if (dateStr.isEmpty) continue;
        
        final info = getExpiryInfo(vehicle.cast<String, dynamic>(), f['field']!, dateStr);
        final status = info['status']?.toString().toLowerCase() ?? 'upcoming';
        final label = info['label']?.toString() ?? '';
        
        Color cardBgColor = Colors.white;
        Color cardBorderColor = const Color(0xffCECECE);
        Color titleColor = Colors.black87;
        Color dateColor = const Color(0xff2A2A2A);
        Color expiryTextColor = Colors.grey.shade700;
        Color badgeBgColor = const Color(0xFFD0FFDF);
        Color badgeTextColor = const Color(0xFF109D59);
        
        if (status == 'expired') {
          cardBgColor = const Color(0xffFDEBEB);
          cardBorderColor = const Color(0xffFCAEAE);
          titleColor = Colors.black87;
          dateColor = const Color(0xff2A2A2A);
          expiryTextColor = const Color(0xffEA0E0E);
          badgeBgColor = const Color(0xFFFFD0D0);
          badgeTextColor = const Color(0xFFFD0909);
        } else if (status == 'due_soon' || status == 'due soon') {
          cardBgColor = Colors.white;
          cardBorderColor = const Color(0xffCECECE);
          titleColor = Colors.black87;
          dateColor = const Color(0xff2A2A2A);
          expiryTextColor = const Color(0xFFFDC209);
          badgeBgColor = const Color(0xFFFFF4D0);
          badgeTextColor = const Color(0xFFFDC209);
        } else {
          cardBgColor = Colors.white;
          cardBorderColor = const Color(0xffCECECE);
          titleColor = Colors.black87;
          dateColor = const Color(0xff2A2A2A);
          expiryTextColor = Colors.grey.shade700;
          badgeBgColor = const Color(0xFFD0FFDF);
          badgeTextColor = const Color(0xFF109D59);
        }
        
        list.add({
          'title': f['title'],
          'date': dateStr,
          'expiryStatus': label,
          'vehicleName': vehicleTag,
          'vehicleTag': '',
          'buttonText': f['buttonText'],
          'iconPath': f['iconPath'],
          'buttonIconPath': f['buttonIconPath'],
          'url': f['url'],
          'backgroundColor': cardBgColor,
          'borderColor': cardBorderColor,
          'titleColor': titleColor,
          'dateColor': dateColor,
          'expiryTextColor': expiryTextColor,
          'badgeBackgroundColor': badgeBgColor,
          'badgeTextColor': badgeTextColor,
          'status': status,
          'parsedDate': parseDate(dateStr) ?? DateTime(3000),
        });
      }
    }
    
    list.sort((a, b) {
      final DateTime da = a['parsedDate'] as DateTime;
      final DateTime db = b['parsedDate'] as DateTime;
      return da.compareTo(db);
    });
    
    return list;
  }
}
