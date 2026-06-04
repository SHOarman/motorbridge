
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiServices {

  ApiServices._();

  static String get baseurl => dotenv.env['BASE_URL'] ?? "";

  static String getFirstImageUrl(dynamic input) {
    if (input == null) return '';
    String path = '';
    if (input is List) {
      if (input.isNotEmpty) {
        var first = input[0];
        if (first is Map) {
          path = (first['url'] ?? first['path'] ?? first['secure_url'] ?? '').toString();
        } else {
          path = first.toString();
        }
      }
    } else if (input is String) {
      String trimmed = input.trim();
      if (trimmed.isEmpty) return '';
      if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
        try {
          final List<dynamic> decoded = jsonDecode(trimmed);
          if (decoded.isNotEmpty) {
            var first = decoded[0];
            if (first is Map) {
              path = (first['url'] ?? first['path'] ?? first['secure_url'] ?? '').toString();
            } else {
              path = first.toString();
            }
          }
        } catch (e) {
          // Fallback
        }
      }
      if (path.isEmpty) {
        if (trimmed.contains(',')) {
          path = trimmed.split(',').first;
        } else {
          path = trimmed;
        }
      }
    } else {
      path = input.toString();
    }
    
    // Normalize path (handle backslashes from Windows servers)
    path = path.trim().replaceAll('\\', '/');
    
    if (path.isEmpty) return '';
    
    if (path.startsWith("http://") || path.startsWith("https://")) {
      return path;
    } else if (path.startsWith("assets/")) {
      return path;
    } else {
      final String cleanPath = path.startsWith("/") ? path : "/$path";
      return "$baseurl$cleanPath";
    }
  }

  //=====================================Auth_APi============================
static String get login => "$baseurl/api/auth/login";
static String get register => "$baseurl/api/auth/register";
static String get forgotPassword => "$baseurl/api/auth/forget-password";
static String get resetPassword => "$baseurl/api/auth/reset-password";
static String get verif_email => "$baseurl/api/auth/verify-email";
static String get verify_code => "$baseurl/api/auth/code-verify";

//========================User_profile======================
static String get user_profile => "$baseurl/api/user/me";
static String get update_profile => "$baseurl/api/user";
static String get delete_account => "$baseurl/api/user";


//===========================crete_Repot========================================
static String get create_Repot => "$baseurl/api/report/create";
static String get update_report => "$baseurl/api/report";
static String get get_reports => "$baseurl/api/report";
static String get get_single_report => "$baseurl/api/report"; // usage: /api/report/:id/summary



//============================add vehicle=======================================
static String get find_vehicle => kIsWeb
    ? "https://corsproxy.io/?https://driver-vehicle-licensing.api.gov.uk/vehicle-enquiry/v1/vehicles"
    : "https://driver-vehicle-licensing.api.gov.uk/vehicle-enquiry/v1/vehicles";
static String get crete_vehicle => "$baseurl/api/vehicle/create";
static String get get_all_vehicles => "$baseurl/api/vehicle";
static String get get_vehicle_by_id => "$baseurl/api/vehicle";
static String get update_vehicle => "$baseurl/api/vehicle";
static String get delete_vehicle => "$baseurl/api/vehicle";

//=========================document===========================================
static String get create_documet => "$baseurl/api/documents/create";
static String get get_document => "$baseurl/api/documents";
static String get delete_document => "$baseurl/api/documents";
static String get update_document => "$baseurl/api/documents";

//=======================addcost================================================

static String get crete_cost => "$baseurl/api/cost/create";
static String get get_const => "$baseurl/api/cost";
static String get delete_cost => "$baseurl/api/cost";
static String get available_costs => "$baseurl/api/cost/summary/?period=yearly";
static String get get_vehicle_costs => "$baseurl/api/cost/vehicle/";


//===============================emergncyconted====================
 static String get add_number => "$baseurl/api/contact/create";
 static String get get_number => "$baseurl/api/contact";
 static String get update_number => "$baseurl/api/contact";
 static String get delet_number => "$baseurl/api/contact";






}