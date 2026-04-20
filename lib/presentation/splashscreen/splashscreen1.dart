import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:motorbridge/presentation/splashscreen/widget/swipe_next_button.dart';

import '../../core/route/app_routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';

class Splashscreen1 extends StatelessWidget {
  const Splashscreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // ব্যাকগ্রাউন্ড কালারটি গ্রেডিয়েন্টের নিচের কালারের সাথে ম্যাচ করানো হয়েছে
      backgroundColor: const Color(0xfff3f6f8),
      body: Stack(
        children: [
          // ১. ব্যাকগ্রাউন্ড ইমেজ
          Positioned(
            top: 0, // টপ ০ করে দিন যাতে ইমেজটি উপরে লেগে থাকে
            left: 0,
            right: 0,
            height: size.height * 0.60,
            child: Image.asset(
              'assets/image/grok-image-4d1dca47-6e47-4670-8d7e-4d32ae499b83 1.png',
              fit: BoxFit.cover,
            ),
          ),

          // ২. টেক্সট এবং গ্রেডিয়েন্ট এরিয়া
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * 0.55,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.0),
                    const Color(0xfff3f6f8).withOpacity(0.8),
                    const Color(0xfff3f6f8),
                  ],

                  stops: const [0.0, 0.20, 0.40],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      style: AppTextStyles.bigText.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1D2939),
                        height: 1.2,
                      ),
                      children: [
                        const TextSpan(text: "Smarter Motoring\n"),
                        TextSpan(
                          text: "Starts Here",
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ডেসক্রিপশন
                  Text(
                    "Manage all your vehicles in one secure virtual garage.",
                    style: AppTextStyles.smallText.copyWith(
                      fontSize: 15,
                      color: const Color(0xFF667085),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // সোয়াইপ বাটন
                  Center(
                    child: SwipeNextButton(
                      onTap: () {
                        Get.toNamed(AppRoutes.splashscreen2);
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}