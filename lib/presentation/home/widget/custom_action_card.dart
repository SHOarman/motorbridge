import 'package:flutter/material.dart';

class CustomActionCard extends StatelessWidget {
  final String title;
  final String iconPath;
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
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    final double cardHeight = sh * 0.052;   // ~40px on 760px screen
    final double iconSize   = sw * 0.052;   // ~19px on 360px screen
    final double fontSize   = sw * 0.038;   // ~14px on 360px screen

    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(7),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: sw * 0.028),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: contentColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: sw * 0.022),
                Image.asset(
                  iconPath,
                  width:  iconSize,
                  height: iconSize,
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