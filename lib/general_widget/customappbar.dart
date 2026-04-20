import 'package:flutter/material.dart';
import '../utils/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final VoidCallback? onLeftTap;
  final VoidCallback? onRightTap;
  final String? backgroundImage;
  final Color backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leftIcon,
    this.rightIcon,
    this.onLeftTap,
    this.onRightTap,
    this.backgroundImage,
    this.backgroundColor = const Color(0xFF004AAD),
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: Stack(
          children: [
            if (backgroundImage != null)
              Positioned(
                right: -sw * 0.19,
                top: -sw * 0.07,
                child: Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    backgroundImage!,
                    width: sw * 0.40,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: sw * 0.028,
                  vertical: sw * 0.028,
                ),
                child: Row(
                  children: [
                    // Left icon
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: leftIcon != null
                            ? GestureDetector(
                                onTap: onLeftTap,
                                child: leftIcon,
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),

                    // Title
                    Expanded(
                      flex: 4,
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bigText.copyWith(
                          fontSize: sw * 0.050,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Right icon
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: rightIcon != null
                            ? GestureDetector(
                                onTap: onRightTap,
                                child: rightIcon,
                              )
                            : const SizedBox.shrink(),
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

  @override
  Size get preferredSize => const Size.fromHeight(90);
}