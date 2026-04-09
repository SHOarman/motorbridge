import 'package:flutter/material.dart';

class CustomActionCard extends StatelessWidget {
  final String title;
  final String iconPath; // আইকন ইমেজের পাথ
  final Color bgColor;
  final Color contentColor;
  final VoidCallback onTap;

  const CustomActionCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.bgColor,
    required this.contentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(7),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: contentColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset(
                  iconPath,
                  width: 20,
                  height: 20,
                  color: contentColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}