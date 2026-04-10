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
    path.moveTo(0.0, 40.0);
    path.quadraticBezierTo(0.0, 0.0, 20.0, 0.0); // Fixed radius logic
    path.lineTo(size.width * 0.35, 0.0);

    path.cubicTo(
      size.width * 0.40, 0.0,
      size.width * 0.40, 45.0,
      size.width * 0.50, 45.0,
    );
    path.cubicTo(
      size.width * 0.60, 45.0,
      size.width * 0.60, 0.0,
      size.width * 0.65, 0.0,
    );

    path.lineTo(size.width - 20.0, 0.0);
    path.quadraticBezierTo(size.width, 0.0, size.width, 40.0);
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
    return SizedBox(
      height: 100,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 80),
            painter: BottomNavPainter(),
          ),
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0),
                _buildNavItem(1),
                const SizedBox(width: 60),
                _buildNavItem(2),
                _buildNavItem(3),
              ],
            ),
          ),
          Positioned(
            top: -5,
            child: GestureDetector(
              onTap: () {
                // Navigate only if not already on the Add Vehicles page
                if (selectedIndex != 4) {
                  Get.toNamed(AppRoutes.addvehicles);
                }
              },
              child: Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  // Darker color if selectedIndex is 4
                  color: selectedIndex == 4
                      ? const Color(0xFF0D2D5E)
                      : const Color(0xFF1B4E9F),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: selectedIndex == 4 ? Colors.lightBlueAccent : Colors.white,
                      width: 4
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 35),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = _navItems[index];
    final bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        if (!isSelected) Get.toNamed(item.route);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(isSelected ? item.activeIcon : item.inactiveIcon,
              height: 26, width: 26),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 11,
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
  const _NavItem(
      {required this.activeIcon,
        required this.inactiveIcon,
        required this.label,
        required this.route});
}