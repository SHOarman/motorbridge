import 'package:flutter/material.dart';

class CustomReminderCard extends StatelessWidget {
  final String title;
  final String date;
  final String expiryStatus;
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

  const CustomReminderCard({
    super.key,
    required this.title,
    required this.date,
    required this.expiryStatus,
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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade100, width: 1),
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Due: $date",
                      style: TextStyle(
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
                      style: TextStyle(
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 54),
            child: Text(
              expiryStatus,
              style: TextStyle(
                fontSize: 14,
                color: expiryTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    buttonIconPath,
                    height: 18,
                    width: 18,
                    color: Colors.white,
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