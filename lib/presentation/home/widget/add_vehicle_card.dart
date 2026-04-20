import 'package:flutter/material.dart';
import 'package:motorbridge/utils/app_sizes.dart';
import 'package:motorbridge/utils/app_text_styles.dart';

class AddVehicleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onAddPressed;

  const AddVehicleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppSizes(context);

    return Container(
      height: s.addVehicleCardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(s.radiusXL),
        gradient: const LinearGradient(
          colors: [Color(0xFF4A89D3), Color(0xFF2B65B3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(s.radiusXL),
        child: Stack(
          children: [
            Positioned(
              right: -120,
              top: -70,
              child: Container(
                width: s.screenWidth * 0.85,
                height: s.screenWidth * 0.85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              right: -60,
              top: -20,
              child: Container(
                width: s.screenWidth * 0.5,
                height: s.screenWidth * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.07),
                ),
              ),
            ),
            Positioned(
              right: -40,
              bottom: 5,
              child: Image.asset(
                imagePath,
                height: s.addVehicleCardImageHeight,
                fit: BoxFit.contain,
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(s.pagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: s.screenWidth * 0.55,
                          child: Text(
                            title,
                            style: AppTextStyles.bigText.copyWith(
                              color: Colors.white,
                              fontSize: s.fontL,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                        ),
                        SizedBox(height: s.spaceM),
                        SizedBox(
                          width: s.screenWidth * 0.65,
                          child: Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.smallText.copyWith(
                              color: const Color(0xffEFEFEF),
                              fontSize: s.fontS,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: onAddPressed,
                      borderRadius: BorderRadius.circular(s.radiusM),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: s.screenWidth * 0.05,
                          vertical: s.spaceS,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D61A6),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Text(
                          "Add Vehicle +",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: s.fontM,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}