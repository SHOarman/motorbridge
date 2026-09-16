import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/controller/subscription_controller.dart';
import '../../../general_widget/customappbar.dart';
import '../../../utils/app_text_styles.dart';

class SubscriptionPlansView extends StatefulWidget {
  const SubscriptionPlansView({super.key});

  @override
  State<SubscriptionPlansView> createState() => _SubscriptionPlansViewState();
}

class _SubscriptionPlansViewState extends State<SubscriptionPlansView> {
  final subController = Get.isRegistered<SubscriptionController>()
      ? Get.find<SubscriptionController>()
      : Get.put(SubscriptionController());

  String? selectedPlanId;

  @override
  void initState() {
    super.initState();
    subController.fetchAvailablePlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Subscription Plans",
        leftIcon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onLeftTap: () => Get.back(),
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: Obx(() {
        if (subController.isLoadingPlans.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (subController.plansList.isEmpty) {
          return Center(
            child: Text(
              "No plans found.",
              style: AppTextStyles.smallText.copyWith(color: Colors.grey),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: subController.plansList.length,
                itemBuilder: (context, index) {
                  final plan = subController.plansList[index];
                  return _buildPlanCard(plan);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPlanCard(dynamic plan) {
    bool isPopular = plan['isPopular'] ?? false;
    String planId = plan['id'] ?? '';
    bool isFreePlan = plan['price'] == 0 || plan['price'] == 0.0;
    bool isSelected = !isFreePlan && selectedPlanId == planId;

    return GestureDetector(
      onTap: isFreePlan ? null : () {
        setState(() {
          selectedPlanId = planId;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F5FA) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF1B4E9F).withValues(alpha: 0.8)
                : (isPopular ? const Color(0xFF1B4E9F).withValues(alpha: 0.3) : const Color(0xFFE0E0E0)),
            width: isSelected ? 2.5 : (isPopular ? 2 : 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.1 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isPopular)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: const BoxDecoration(
                  color: Color(0xFF1B4E9F),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: Text(
                  "MOST POPULAR",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.smallText.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        plan['title'] ?? 'Plan',
                        style: AppTextStyles.bigText.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff2A2A2A),
                        ),
                      ),
                      if (!isFreePlan)
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF1B4E9F),
                            size: 24,
                          )
                        else
                          Icon(
                            Icons.circle_outlined,
                            color: Colors.grey.shade400,
                            size: 24,
                          ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    plan['subtext'] ?? '',
                    style: AppTextStyles.smallText.copyWith(
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "${plan['currency'] == 'USD' ? '\$' : '£'}${plan['price']}",
                        style: AppTextStyles.bigText.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1B4E9F),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "/${plan['billingCycle'] ?? 'month'}",
                        style: AppTextStyles.smallText.copyWith(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  if (plan['features'] != null && plan['features'] is List)
                    ...List.generate(
                      plan['features'].length,
                      (idx) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Color(0xFF109D59), size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                plan['features'][idx].toString(),
                                style: AppTextStyles.smallText.copyWith(
                                  color: const Color(0xff444444),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (isSelected) ...[
                    const SizedBox(height: 20),
                    Obx(() {
                      bool isVerifying = subController.isVerifyingPurchase.value;
                      bool isFreePlan = plan['price'] == 0 || plan['price'] == 0.0;
                      
                      return ElevatedButton(
                        onPressed: isVerifying ? null : () async {
                          if (isFreePlan) {
                            Get.snackbar(
                              "Free Plan Active",
                              "You are already on the Free plan automatically.",
                              backgroundColor: Colors.blue,
                              colorText: Colors.white,
                            );
                            Get.back();
                            return;
                          }
                          
                          // RevenueCat purchase flow
                          String rcProductId = plan['productIds']?.isNotEmpty == true 
                                ? plan['productIds'].first 
                                : "dummy_id";
                                
                          bool success = await subController.processPurchaseAndVerify(
                            rcProductId, 
                            plan['planCode'] ?? "PRO",
                          );
                          
                          if (success) {
                            Get.snackbar(
                              "Purchase Successful",
                              "Your subscription has been activated.",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                            Get.back(); // Go back to profile
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B4E9F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        child: Center(
                          child: isVerifying
                              ? const SizedBox(
                                  height: 20, 
                                  width: 20, 
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                )
                              : Text(
                                  isFreePlan ? "Current Plan" : "Choose Plan",
                                  style: AppTextStyles.smallText.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
