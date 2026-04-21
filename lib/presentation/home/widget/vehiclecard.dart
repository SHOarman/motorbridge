import 'package:flutter/material.dart';
import 'package:motorbridge/utils/app_sizes.dart';
import 'package:motorbridge/utils/app_text_styles.dart';

class VehicleCard extends StatelessWidget {
  final String vehicleName;
  final String year;
  final String engineCode;
  final String vehicleTag;
  final String registrationNumber;
  final String vehicleImage;
  final VoidCallback onViewDetails;
  final VoidCallback onTagTap;
  final Color registrationColor;
  final Color registrationTextColor;
  final bool hasBorder;
  final Color borderColor;
  final bool showDots;
  final int activeDotIndex;

  const VehicleCard({
    super.key,
    required this.vehicleName,
    required this.year,
    required this.engineCode,
    required this.vehicleTag,
    required this.registrationNumber,
    required this.vehicleImage,
    required this.onViewDetails,
    required this.onTagTap,
    this.registrationColor = const Color(0xFFFFD54F),
    this.registrationTextColor = Colors.black,
    this.hasBorder = false,
    this.borderColor = const Color(0xFF000000),
    this.showDots = false,
    this.activeDotIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppSizes(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.11),
            blurRadius: 6.6,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section (Name, Year, Tag)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            vehicleName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: s.fontXXL,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF333333),
                            ),
                          ),
                        ),
                        SizedBox(width: s.spaceS),
                        Text(
                          year,
                          style: TextStyle(
                            fontSize: s.fontM,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      engineCode,
                      style: TextStyle(
                        fontSize: s.fontM,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onTagTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Text(
                    vehicleTag,
                    style: TextStyle(
                      color: const Color(0xFFFFB300),
                      fontWeight: FontWeight.bold,
                      fontSize: s.fontM,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: s.spaceM),

          // Registration Number Plate
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: registrationColor,
              borderRadius: BorderRadius.circular(4),
              border: hasBorder ? Border.all(color: borderColor, width: 1.5) : null,
            ),
            child: Center(
              child: Text(
                registrationNumber,
                style: AppTextStyles.bigText.copyWith(
                  color: registrationTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          SizedBox(height: s.spaceM),

          // Image Section with Border
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                color: const Color(0xFF9DBDEE),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: s.vehicleCardImageHeight,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(vehicleImage, fit: BoxFit.contain),
                  ),
                ),

                if (showDots) ...[
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: activeDotIndex == index
                              ? const Color(0xFF1B4E9F) // একটিভ কালার
                              : const Color(0xFFB0C4DE), // ইনএকটিভ কালার
                        ),
                      );
                    }),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: s.spaceM),

          // View Details Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onViewDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B4E9F),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "View Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: s.fontL,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_right_alt, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}