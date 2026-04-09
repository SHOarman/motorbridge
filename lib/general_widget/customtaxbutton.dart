import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final String? imagePath;
  final double imageSize;
  final Color backgroundColor;
  final Color textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.imagePath,
    this.imageSize = 20.0,
    this.backgroundColor = const Color(0xFF154da1),
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (imagePath != null) ...[
                const SizedBox(width: 8),
                Image.asset(
                  imagePath!,
                  height: imageSize,
                  width: imageSize,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}