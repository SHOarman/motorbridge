import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/controller/subscription_controller.dart';
import '../../../general_widget/customappbar.dart';
import '../../../utils/app_text_styles.dart';

class CurrentPlanView extends StatelessWidget {
  const CurrentPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    final subController = Get.isRegistered<SubscriptionController>()
        ? Get.find<SubscriptionController>()
        : Get.put(SubscriptionController());
        
    return Scaffold(
      appBar: CustomAppBar(
        title: "My Current Plan",
        leftIcon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onLeftTap: () => Get.back(),
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (subController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B4E9F), Color(0xFF2B65B3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current Subscription",
                      style: AppTextStyles.smallText.copyWith(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subController.title.value.isNotEmpty ? subController.title.value : "Free Plan",
                      style: AppTextStyles.bigText.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Status: ${subController.status.value.isNotEmpty ? subController.status.value.toUpperCase() : 'ACTIVE'}",
                      style: AppTextStyles.smallText.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Plan Entitlements",
                style: AppTextStyles.bigText.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff2A2A2A),
                ),
              ),
              const SizedBox(height: 15),
              _buildEntitlementRow("Maximum Vehicles", subController.maxVehicles.value == -1 ? "Unlimited" : subController.maxVehicles.value.toString()),
              _buildEntitlementRow("Gallery Images / Vehicle", subController.maxGalleryImagesPerVehicle.value == -1 ? "Unlimited" : subController.maxGalleryImagesPerVehicle.value.toString()),
              _buildEntitlementRow("Maximum Documents", subController.maxDocuments.value == -1 ? "Unlimited" : subController.maxDocuments.value.toString()),
              _buildEntitlementRow("Cost Calculator", subController.costCalculatorUnlocked.value ? "Unlocked" : "Locked"),
              const SizedBox(height: 40),
              if (subController.isActive.value && 
                  subController.planCode.value.toLowerCase() != 'free' && 
                  subController.planCode.value.isNotEmpty && 
                  subController.status.value.toUpperCase() != 'CANCELLED')
                Obx(() {
                  bool isCanceling = subController.isCanceling.value;
                  return Center(
                    child: TextButton(
                      onPressed: isCanceling ? null : () async {
                        bool confirm = await Get.dialog(
                          AlertDialog(
                            title: const Text("Cancel Subscription"),
                            content: const Text("Are you sure you want to cancel your auto-renewal? You will retain access until the end of your billing cycle."),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(result: false),
                                child: const Text("Keep Plan"),
                              ),
                              TextButton(
                                onPressed: () => Get.back(result: true),
                                child: const Text("Cancel Plan", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        ) ?? false;
                        
                        if (confirm) {
                          bool success = await subController.cancelSubscription();
                          if (success) {
                            Get.snackbar("Success", "Your subscription auto-renewal has been cancelled.", backgroundColor: Colors.green, colorText: Colors.white);
                          } else {
                            Get.snackbar("Failed", "Could not cancel subscription. Please try again later.", backgroundColor: Colors.red, colorText: Colors.white);
                          }
                        }
                      },
                      child: isCanceling
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red),
                            )
                          : Text(
                              "Cancel Subscription",
                              style: AppTextStyles.smallText.copyWith(
                                color: Colors.red.shade700,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                }),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEntitlementRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.smallText.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: const Color(0xff555555),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.smallText.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xff1B4E9F),
            ),
          ),
        ],
      ),
    );
  }
}
