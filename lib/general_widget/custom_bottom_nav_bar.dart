import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/route/app_routes.dart';

class BottomNavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFFD1E9FF)
      ..style = PaintingStyle.fill;

    ui.Path path = ui.Path();
    path.moveTo(0.0, size.height * 0.50);
    path.quadraticBezierTo(0.0, 0.0, 20.0, 0.0);
    path.lineTo(size.width * 0.35, 0.0);

    path.cubicTo(
      size.width * 0.40, 0.0,
      size.width * 0.40, size.height * 0.58,
      size.width * 0.50, size.height * 0.58,
    );
    path.cubicTo(
      size.width * 0.60, size.height * 0.58,
      size.width * 0.60, 0.0,
      size.width * 0.65, 0.0,
    );

    path.lineTo(size.width - 20.0, 0.0);
    path.quadraticBezierTo(size.width, 0.0, size.width, size.height * 0.50);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.5), 5.0, true);
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
    final sh = MediaQuery.of(context).size.height;

    // Responsive dimensions
    final double navHeight  = sh * 0.105;
    final double barHeight  = navHeight * 0.85;
    final double fabSize    = sw * 0.158;   // ~58px on 360px screen
    final double iconSize   = sw * 0.065;   // ~23px
    final double labelSize  = sw * 0.028;   // ~10px
    final double fabIconSize = sw * 0.090;  // ~32px

    return SizedBox(
      height: navHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Custom painted background
          CustomPaint(
            size: Size(sw, barHeight),
            painter: BottomNavPainter(),
          ),

          // Nav items row
          Container(
            height: barHeight,
            padding: EdgeInsets.symmetric(horizontal: sw * 0.025),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, iconSize, labelSize),
                _buildNavItem(1, iconSize, labelSize),
                SizedBox(width: fabSize),
                _buildNavItem(2, iconSize, labelSize),
                _buildNavItem(3, iconSize, labelSize),
              ],
            ),
          ),

          // Floating "+" button
          Positioned(
            top: -fabSize * 0.12,
            child: GestureDetector(
              onTap: () {
                if (selectedIndex != 4) {
                  Get.toNamed(AppRoutes.addvehicles);
                }
              },
              child: Container(
                height: fabSize,
                width: fabSize,
                decoration: BoxDecoration(
                  color: selectedIndex == 4
                      ? const Color(0xFF0D2D5E)
                      : const Color(0xFF1B4E9F),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedIndex == 4
                        ? Colors.lightBlueAccent
                        : Colors.white,
                    width: sw * 0.010,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: fabIconSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, double iconSize, double labelSize) {
    final item = _navItems[index];
    final bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        if (!isSelected) Get.toNamed(item.route);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            isSelected ? item.activeIcon : item.inactiveIcon,
            height: iconSize,
            width: iconSize,
          ),
          const SizedBox(height: 3),
          Text(
            item.label,
            style: TextStyle(
              fontSize: labelSize,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF1B4E9F) : Colors.black54,
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