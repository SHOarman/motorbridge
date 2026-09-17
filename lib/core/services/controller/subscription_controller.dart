import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../api_sevices/api_services.dart';

class SubscriptionController extends GetxController {
  var isLoading = false.obs;
  var status = ''.obs;
  var plan = ''.obs;
  var isActive = false.obs;
  var currentPeriodEnd = RxnString();
  var planCode = ''.obs;
  var title = ''.obs;
  var maxVehicles = 1.obs;
  var maxGalleryImagesPerVehicle = 1.obs;
  var maxDocuments = 1.obs;
  var costCalculatorUnlocked = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSubscriptionStatus();
  }

  Future<void> fetchSubscriptionStatus() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        isLoading.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse(ApiServices.get_payment_status),
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("Subscription status response: ${response.statusCode}");
      debugPrint("Subscription status body: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          var data = responseData['data'];
          
          status.value = data['status'] ?? '';
          plan.value = data['plan'] ?? '';
          isActive.value = data['isActive'] ?? false;
          currentPeriodEnd.value = data['currentPeriodEnd'];
          
          if (data['entitlements'] != null) {
            var entitlements = data['entitlements'];
            planCode.value = entitlements['planCode'] ?? '';
            title.value = entitlements['title'] ?? '';
            
            // For max values, if the API returns null, it means 'Unlimited' (-1).
            maxVehicles.value = entitlements['maxVehicles'] ?? -1;
            maxGalleryImagesPerVehicle.value = entitlements['maxGalleryImagesPerVehicle'] ?? -1;
            maxDocuments.value = entitlements['maxDocuments'] ?? -1;
            
            costCalculatorUnlocked.value = entitlements['costCalculatorUnlocked'] ?? false;
            
            // Console Logging for limits (as requested by user)
            debugPrint("==================================================");
            debugPrint("🔐 SUBSCRIPTION & LIMITS LOADED 🔐");
            debugPrint("Plan: ${planCode.value} (${title.value})");
            debugPrint("Max Vehicles: ${maxVehicles.value == -1 ? 'Unlimited' : maxVehicles.value}");
            debugPrint("Max Gallery Images: ${maxGalleryImagesPerVehicle.value == -1 ? 'Unlimited' : maxGalleryImagesPerVehicle.value}");
            debugPrint("Max Documents: ${maxDocuments.value == -1 ? 'Unlimited' : maxDocuments.value}");
            debugPrint("Cost Calculator Unlocked: ${costCalculatorUnlocked.value}");
            debugPrint("==================================================");
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching subscription status: $e");
    } finally {
      isLoading.value = false;
    }
  }

  var plansList = [].obs;
  var isLoadingPlans = false.obs;

  Future<void> fetchAvailablePlans() async {
    try {
      isLoadingPlans.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(ApiServices.get_payment_plans),
        headers: token != null && token.isNotEmpty ? {"Authorization": "Bearer $token"} : {},
      );

      debugPrint("Subscription plans response: ${response.statusCode}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          if (responseData['data']['plans'] != null) {
            plansList.value = responseData['data']['plans'];
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching subscription plans: $e");
    } finally {
      isLoadingPlans.value = false;
    }
  }

  var isVerifyingPurchase = false.obs;

  Future<void> _initRevenueCatIfNeeded() async {
    bool isConfigured = await Purchases.isConfigured;
    if (!isConfigured) {
      await Purchases.setLogLevel(LogLevel.debug);
      await Purchases.configure(PurchasesConfiguration("goog_qiCDySzDKcJcpDQpVrLuvbWvFHY"));
    }
  }

  // Uses RevenueCat to purchase, then sends receipt to backend verify-purchase
  Future<bool> processPurchaseAndVerify(String rcProductId, String selectedPlanCode) async {
    try {
      isVerifyingPurchase.value = true;
      
      await _initRevenueCatIfNeeded();
      
      List<StoreProduct> products = await Purchases.getProducts([rcProductId]);
      if (products.isEmpty) {
        Get.snackbar("Error", "Product not found on Store", backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
      
      final result = await Purchases.purchaseStoreProduct(products.first);
      CustomerInfo customerInfo = result.customerInfo;
      
      // ২. Entitlement চেক:
      // If 'pro' is your entitlement identifier in RevenueCat Dashboard.
      bool isEntitled = customerInfo.entitlements.all['pro']?.isActive == true;
      
      if (isEntitled) {
        // পারচেজ সফল! ইউজারের ফিচার আনলক করুন
        debugPrint("RevenueCat Entitlement 'pro' is ACTIVE.");
      } else {
        debugPrint("RevenueCat Entitlement 'pro' is NOT active.");
      }

      String purchaseToken = customerInfo.originalAppUserId; 
      String transactionId = "rc_purchase_${DateTime.now().millisecondsSinceEpoch}";
      
      String provider = Platform.isIOS ? "APPLE_APP_STORE" : "GOOGLE_PLAY";
      
      return await _verifyPurchaseOnBackend(
        provider: provider,
        productId: rcProductId,
        purchaseToken: purchaseToken,
        transactionId: transactionId,
        planCode: selectedPlanCode,
      );
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        debugPrint("RevenueCat Purchase Error: $e");
      }
      return false;
    } catch (e) {
      debugPrint("General Purchase Error: $e");
      return false;
    } finally {
      isVerifyingPurchase.value = false;
    }
  }

  Future<bool> _verifyPurchaseOnBackend({
    required String provider,
    required String productId,
    required String purchaseToken,
    required String transactionId,
    required String planCode,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final body = {
        "provider": provider,
        "productId": productId,
        "purchaseToken": purchaseToken,
        "transactionId": transactionId,
        "plan": planCode,
      };

      final response = await http.post(
        Uri.parse(ApiServices.verify_purchase),
        headers: {
          "Content-Type": "application/json",
          if (token != null && token.isNotEmpty) "Authorization": "Bearer $token"
        },
        body: jsonEncode(body),
      );

      debugPrint("Verify purchase response: ${response.statusCode}");
      debugPrint("Verify purchase body: ${response.body}");

      if (response.statusCode == 200) {
        await fetchSubscriptionStatus();
        return true;
      } else {
        // Show exact error from backend
        String errorMessage = "Unknown error";
        try {
          var jsonData = jsonDecode(response.body);
          errorMessage = jsonData['message'] ?? response.body;
        } catch (e) {
          errorMessage = response.body;
        }
        
        Get.snackbar(
          "Backend Validation Error",
          "Code: ${response.statusCode}\nDetails: $errorMessage",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        return false;
      }
    } catch (e) {
      debugPrint("Error verifying backend purchase: $e");
      Get.snackbar(
        "Network Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  var isRestoring = false.obs;

  Future<bool> restorePurchasesProcess() async {
    try {
      isRestoring.value = true;
      
      // 0. Ensure RevenueCat is configured
      await _initRevenueCatIfNeeded();
      
      // 1. Restore through RevenueCat
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      
      // 2. Tell backend to verify restored purchases (using RevenueCat token)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final body = {
        "provider": "REVENUECAT",
        "receiptData": customerInfo.originalAppUserId, 
      };

      final response = await http.post(
        Uri.parse(ApiServices.restore_purchases),
        headers: {
          "Content-Type": "application/json",
          if (token != null && token.isNotEmpty) "Authorization": "Bearer $token"
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        await fetchSubscriptionStatus();
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      debugPrint("RevenueCat Restore Error: $e");
      return false;
    } catch (e) {
      debugPrint("Error restoring purchases: $e");
      return false;
    } finally {
      isRestoring.value = false;
    }
  }

  var isCanceling = false.obs;

  Future<bool> cancelSubscription() async {
    try {
      isCanceling.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.post(
        Uri.parse(ApiServices.cancel_subscription),
        headers: {
          "Content-Type": "application/json",
          if (token != null && token.isNotEmpty) "Authorization": "Bearer $token"
        },
      );

      debugPrint("Cancel subscription response: ${response.statusCode}");
      debugPrint("Cancel subscription body: ${response.body}");

      if (response.statusCode == 200) {
        // Refresh status after cancellation
        await fetchSubscriptionStatus();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error cancelling subscription: $e");
      return false;
    } finally {
      isCanceling.value = false;
    }
  }
}
