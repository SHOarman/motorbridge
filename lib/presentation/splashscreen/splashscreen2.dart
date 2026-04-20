import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import 'package:motorbridge/presentation/splashscreen/widget/swipe_next_button.dart';
import 'package:motorbridge/utils/app_text_styles.dart';

class Splashscreen2 extends StatelessWidget {
  const Splashscreen2({super.key});

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF5F6F8);

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  "assets/image/carbackround2.png",
                  width: MediaQuery.of(context).size.width,
                  height: 550,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: -50,
                  left: 0,
                  right: 0,

                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          bgColor.withValues(alpha: 0.0),
                          bgColor.withValues(alpha: 0.2),
                          bgColor,
                        ],
                        stops:  [0.13, 0.15, 0.4],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Automatic MOT, Tax &",
                    style: AppTextStyles.bigText.copyWith(fontSize: 30,fontWeight: FontWeight.w800),
                  ),
                  Row(
                    children: [
                      Text("Insurance", style: AppTextStyles.bigText.copyWith(fontSize: 30,fontWeight: FontWeight.w800,color: const Color(0xFF154da1))),
                      Text(
                        " Reminders",
                        style: AppTextStyles.bigText.copyWith(color: const Color(0xFF154da1)),
                      ),
                    ],
                  ),
                   SizedBox(height: 8),
                  Text(
                    "We notify you before your important vehicle\ndates expire.",
                    style: AppTextStyles.smallText.copyWith(fontSize: 16),
                  ),

                  const SizedBox(height: 20),

                  SwipeNextButton(
                    onTap: () {
                      Get.toNamed(AppRoutes.singin);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}