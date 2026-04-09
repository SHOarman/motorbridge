import 'package:get/get.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import 'package:motorbridge/presentation/splashscreen/widget/swipe_next_button.dart';
import 'package:motorbridge/utils/app_colors.dart';
import 'package:motorbridge/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class Splashscreen1 extends StatelessWidget {
  const Splashscreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const Color bgColor = Color(0xFFF5F6F8);

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    "assets/image/carbackround.png",
                    height: 520,
                    width: screenWidth,
                    fit: BoxFit.cover,
                    alignment: Alignment.centerRight,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          bgColor.withValues(alpha: 0.0),
                          bgColor.withValues(alpha: 0.2),
                          bgColor,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Smarter Motoring",
                    style: AppTextStyles.bigText.copyWith(fontSize: 32),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Starts Here",
                    style: AppTextStyles.bigText.copyWith(
                      color: AppColors.primaryColor,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Manage all your vehicles in one secure virtual\ngarage.",
                    style: AppTextStyles.smallText.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 30),
                  SwipeNextButton(onTap: () {
                    Get.toNamed(AppRoutes.splashscreen2);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}