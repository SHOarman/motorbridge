import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motorbridge/utils/app_text_styles.dart';

class CustomReminderCard extends StatelessWidget {
  final String title;
  final String date;
  final String? expiryStatus;
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
    this.expiryStatus,
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
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- BIG MAIN ICON ---
              Image.asset(
                iconPath,
                height: 55, // Big and prominent
                width: 55,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: AppTextStyles.bigText.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: titleColor,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: badgeBackgroundColor,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                offset: const Offset(0, 4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Text(
                            vehicleName,
                            style: AppTextStyles.smallText.copyWith(
                              color: badgeTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Due: $date",
                      style: AppTextStyles.smallText.copyWith(
                        fontSize: 16,
                        color: dateColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (expiryStatus != null && expiryStatus!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        expiryStatus!,
                        style: AppTextStyles.smallText.copyWith(
                          fontSize: 16,
                          color: expiryTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 56, // Increased height to accommodate larger button icon
            child: ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                elevation: 0,
                side: buttonBorder,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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
                      fontSize: 18, // Slightly larger text to match big icon
                    ),
                  ),
                  const SizedBox(width: 12),
                  // --- BIG BUTTON ICON ---
                SvgPicture.asset(
                    buttonIconPath,
                     height: 25, // Scaled up icon
                     width: 25,
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