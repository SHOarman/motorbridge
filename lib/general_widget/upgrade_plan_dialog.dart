import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/route/app_routes.dart';
import '../utils/app_text_styles.dart';

class UpgradePlanDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0F5FA),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.workspace_premium, color: Color(0xFF1B4E9F), size: 48),
                ),
                const SizedBox(height: 20),
                Text(
                  "Upgrade Your Plan",
                  style: AppTextStyles.bigText.copyWith(
                    fontSize: 22, 
                    fontWeight: FontWeight.w800, 
                    color: const Color(0xFF2A2A2A),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "You've reached the maximum limit for your current plan. Upgrade to add more vehicles and unlock exclusive features.",
                  style: AppTextStyles.smallText.copyWith(
                    color: Colors.grey.shade600, 
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); // close dialog
                    Get.toNamed(AppRoutes.subscriptionPlans);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF109D59), // Green color attracts attention
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size(double.infinity, 50),
                    elevation: 0,
                  ),
                  child: Text(
                    "View Plans",
                    style: AppTextStyles.smallText.copyWith(
                      color: Colors.white, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    "Cancel",
                    style: AppTextStyles.smallText.copyWith(
                      color: Colors.grey.shade500, 
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
