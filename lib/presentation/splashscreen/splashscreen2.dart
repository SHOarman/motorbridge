import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/presentation/splashscreen/widget/swipe_next_button.dart';
import '../../core/route/app_routes.dart';
import '../../utils/app_text_styles.dart';

class Splashscreen2 extends StatelessWidget {
  const Splashscreen2({super.key});

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF5F6F8);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.60,
            child: Image.asset(
              "assets/image/carbackround2.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: size.height * 0.15,
                left: 24.0,
                right: 24.0,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    bgColor.withValues(alpha: 0.0),
                    bgColor,
                  ],
                  stops: const [0.0, 0.3],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Automatic MOT, Tax &",
                    style: AppTextStyles.bigText.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1D2939),
                    ),
                  ),
                  Text(
                    "Insurance Reminders",
                    style: AppTextStyles.bigText.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF154da1),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "We notify you before your important vehicle dates expire.",
                    style: AppTextStyles.smallText.copyWith(
                      fontSize: 15,
                      color: const Color(0xFF667085),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: SwipeNextButton(
                      onTap: () {
                        Get.toNamed(AppRoutes.singin);
                      },
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}