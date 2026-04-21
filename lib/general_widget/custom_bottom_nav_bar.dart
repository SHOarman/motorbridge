import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/route/app_routes.dart';

class BottomNavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFFC3E1FF)
      ..style = PaintingStyle.fill;

    ui.Path path = ui.Path();

    double cornerRadius = 35.0;
    double notchStart = size.width * 0.35;
    double notchEnd = size.width * 0.65;

    // Start from bottom left
    path.moveTo(0, size.height);

    // Left side line and top-left corner
    path.lineTo(0, cornerRadius);
    path.quadraticBezierTo(0, 18, cornerRadius, 16);




    // Line to the start of the notch
    path.lineTo(notchStart, 0);

    // Smooth Notch (Design Match)
    path.cubicTo(
      size.width * 0.44, 0,
      size.width * 0.38, size.height * 0.50,
      size.width * 0.49, size.height * 0.60,
    );
    path.cubicTo(
      size.width * 0.64, size.height * 0.60,
      size.width * 0.55, 0,
      size.width * 0.64, 0,
    );

    // Line to the top-right corner
    path.lineTo(size.width - cornerRadius, 16);
    path.quadraticBezierTo(size.width, 18, size.width, cornerRadius);

    // Right side and bottom lines
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Soft Shadow
    canvas.drawShadow(path, Colors.black.withOpacity(0.12), 8.0, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  const CustomBottomNavBar({super.key, required this.selectedIndex});

  static const _navItems = [
    _NavItem(
        activeIcon: 'assets/icon/home.png',
        inactiveIcon: 'assets/icon/homeinactive.png',
        label: 'Home',
        route: AppRoutes.home),
    _NavItem(
        activeIcon: 'assets/icon/activevechile.png',
        inactiveIcon: 'assets/icon/racing (2) 1.png',
        label: 'Vehicles',
        route: AppRoutes.vehicles),
    _NavItem(
        activeIcon: 'assets/icon/activereminder.png',
        inactiveIcon: 'assets/icon/ion_notifications-outline.png',
        label: 'Reminders',
        route: AppRoutes.reminders),
    _NavItem(
        activeIcon: 'assets/icon/activeprofile.png',
        inactiveIcon: 'assets/icon/user.png',
        label: 'Profile',
        route: AppRoutes.profile),
  ];

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    // Dimensions based on design image
    final double barHeight = 90.0;
    final double fabSize = 55.0;
    final double iconSize = 24.0;

    return SizedBox(
      height: barHeight + 10,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Background Painter
          CustomPaint(
            size: Size(sw, barHeight),
            painter: BottomNavPainter(),
          ),

          // Items Row
          Container(
            height: barHeight,
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, iconSize),
                _buildNavItem(1, iconSize),
                SizedBox(width: fabSize + 10), // Notch Space
                _buildNavItem(2, iconSize),
                _buildNavItem(3, iconSize),
              ],
            ),
          ),

          // Center FAB Button
          Positioned(
            top: 0, // Adjusted for perfect notch fit
            child: GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.addvehicles),
              child: Container(
                height: fabSize,
                width: fabSize,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B4E9F),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 38,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, double iconSize) {
    final item = _navItems[index];
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        if (!isSelected) Get.offAllNamed(item.route);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            isSelected ? item.activeIcon : item.inactiveIcon,
            height: iconSize,
            width: iconSize,
            color: isSelected ? const Color(0xFF1B4E9F) : Colors.black54,
          ),
          const SizedBox(height: 5),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w700,
              color: isSelected ? const Color(0xFF1B4E9F) : Color(0xff313131),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final String activeIcon, inactiveIcon, label, route;
  const _NavItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
    required this.route,
  });
}