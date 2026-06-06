import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motorbridge/utils/app_text_styles.dart';
import 'package:intl/intl.dart';

class CustomReminderCard extends StatelessWidget {
  final String title;
  final String date;
  final String vehicleName;
  final String? vehicleTag;
  final String? expiryStatus;
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
    this.vehicleTag,
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

  String _formatDate(String rawDate) {
    if (rawDate.isEmpty) return '';
    try {
      DateTime? parsed;
      if (rawDate.contains('/')) {
        final parts = rawDate.split('/');
        if (parts.length == 3) {
          int p0 = int.parse(parts[0]);
          int p1 = int.parse(parts[1]);
          int p2 = int.parse(parts[2]);
          if (p1 > 12) {
            parsed = DateTime(p2, p0, p1);
          } else if (p0 > 12) {
            parsed = DateTime(p2, p1, p0);
          } else {
            parsed = DateTime(p2, p1, p0);
          }
        }
      } else if (rawDate.contains('-')) {
        final parts = rawDate.split('-');
        if (parts.length == 3) {
          if (parts[0].length == 4) {
            parsed = DateTime.parse(rawDate);
          } else {
            int p0 = int.parse(parts[0]);
            int p1 = int.parse(parts[1]);
            int p2 = int.parse(parts[2]);
            if (p1 > 12) {
              parsed = DateTime(p2, p0, p1);
            } else {
              parsed = DateTime(p2, p1, p0);
            }
          }
        }
      } else {
        parsed = DateTime.tryParse(rawDate);
      }

      if (parsed != null) {
        final day = parsed.day;
        String suffix = 'th';
        if (day >= 11 && day <= 13) {
          suffix = 'th';
        } else {
          switch (day % 10) {
            case 1: suffix = 'st'; break;
            case 2: suffix = 'nd'; break;
            case 3: suffix = 'rd'; break;
          }
        }
        final monthStr = DateFormat('MMM').format(parsed);
        return "$day$suffix $monthStr ${parsed.year}";
      }
    } catch (e) {
      // ignore
    }
    return rawDate;
  }

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
                        Flexible(
                          child: Container(
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
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.smallText.copyWith(
                                color: badgeTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Due: ${_formatDate(date)}",
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
                  Flexible(
                    child: Text(
                      buttonText,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.smallText.copyWith(
                        color: customButtonTextColor ?? Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18, // Slightly larger text to match big icon
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // --- BIG BUTTON ICON ---
                  SvgPicture.asset(
                    buttonIconPath,
                     height: 25, // Scaled up icon
                     width: 25,
                    colorFilter: ColorFilter.mode(customButtonTextColor ?? Colors.white, BlendMode.srcIn),
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