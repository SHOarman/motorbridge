import 'package:flutter/material.dart';
import 'package:motorbridge/utils/app_text_styles.dart';

class CustomReminderCard extends StatelessWidget {
  final String title;
  final String date;
  final String? expiryStatus; // Nullable করা হয়েছে
  final String vehicleName;
  final String buttonText;
  final String iconPath;
  final String? badgeIconPath;
  final String buttonIconPath;

  final Color backgroundColor;
  final Color titleColor;
  final Color dateColor;
  final Color expiryTextColor;
  final Color buttonColor;
  final Color badgeBackgroundColor;
  final Color badgeTextColor;
  final VoidCallback onButtonPressed;

  final Color? borderColor;
  final Color? customButtonTextColor;
  final BorderSide? buttonBorder;

  const CustomReminderCard({
    super.key,
    required this.title,
    required this.date,
    this.expiryStatus, // Optional parameter
    required this.vehicleName,
    required this.buttonText,
    required this.iconPath,
    this.badgeIconPath,
    required this.buttonIconPath,
    required this.backgroundColor,
    required this.titleColor,
    required this.dateColor,
    required this.expiryTextColor,
    required this.buttonColor,
    required this.badgeBackgroundColor,
    required this.badgeTextColor,
    required this.onButtonPressed,
    this.borderColor,
    this.customButtonTextColor,
    this.buttonBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: borderColor ?? Colors.blue.shade100,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(iconPath, height: 45, width: 45),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.smallText.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Due: $date",
                      style: AppTextStyles.smallText.copyWith(
                        fontSize: 14,
                        color: dateColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    decoration: BoxDecoration(
                      color: badgeBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: Text(
                      vehicleName,
                      style: AppTextStyles.smallText.copyWith(
                        color: badgeTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (badgeIconPath != null)
                    Positioned(
                      top: -10,
                      right: -10,
                      child: Image.asset(badgeIconPath!, height: 25, width: 25),
                    ),
                ],
              ),
            ],
          ),

          if (expiryStatus != null && expiryStatus!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              expiryStatus!,
              style: AppTextStyles.smallText.copyWith(
                fontSize: 14,
                color: expiryTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],

          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                elevation: 0,
                side: buttonBorder,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    buttonText,
                    style: AppTextStyles.smallText.copyWith(
                      color: customButtonTextColor ?? Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    buttonIconPath,
                    height: 18,
                    width: 18,
                    color: customButtonTextColor ?? Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}