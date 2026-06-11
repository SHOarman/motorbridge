import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/route/app_routes.dart';

class BottomNavPainter extends CustomPainter {
  final double barHeight;
  BottomNavPainter({required this.barHeight});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFFC3E1FF)
      ..style = PaintingStyle.fill;

    ui.Path path = ui.Path();
    double cornerRadius = 35.0;

    path.moveTo(0, size.height);
    path.lineTo(0, cornerRadius);
    path.quadraticBezierTo(0, 18, cornerRadius, 16);

    double cx = size.width / 2;
    double nw = 55.0;

    path.lineTo(cx - nw, 0);
    path.cubicTo(
      cx - nw + 20,
      0,
      cx - nw + 10,
      barHeight * 0.60,
      cx,
      barHeight * 0.60,
    );
    path.cubicTo(cx + nw - 10, barHeight * 0.60, cx + nw - 20, 0, cx + nw, 0);

    path.lineTo(size.width - cornerRadius, 16);
    path.quadraticBezierTo(size.width, 18, size.width, cornerRadius);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.12), 8.0, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BottomNavPainter oldDelegate) =>
      oldDelegate.barHeight != barHeight;
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  const CustomBottomNavBar({super.key, required this.selectedIndex});

  static const _navItems = [
    _NavItem(
      activeIcon: 'assets/icon/home.png',
      inactiveIcon: 'assets/icon/homeinactive.png',
      label: 'Home',
      route: AppRoutes.home,
    ),
    _NavItem(
      activeIcon: 'assets/icon/activevechile.png',
      inactiveIcon: 'assets/icon/racing (2) 1.png',
      label: 'Vehicles',
      route: AppRoutes.vehicles,
    ),
    _NavItem(
      activeIcon: 'assets/icon/activereminder.png',
      inactiveIcon: 'assets/icon/ion_notifications-outline.png',
      label: 'Reminders',
      route: AppRoutes.reminders,
    ),
    _NavItem(
      activeIcon: 'assets/icon/activeprofile.png',
      inactiveIcon: 'assets/icon/user.png',
      label: 'Profile',
      route: AppRoutes.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    final double systemNavBarHeight = MediaQuery.of(context).viewPadding.bottom;

    final double barHeight = 80.0;
    final double totalBarHeight = barHeight + systemNavBarHeight;

    final double fabSize = 55.0;
    final double iconSize = 24.0;

    return SizedBox(
      height: totalBarHeight + 10,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: Size(sw, totalBarHeight),
            painter: BottomNavPainter(barHeight: barHeight),
          ),

          Container(
            height: barHeight,
            margin: EdgeInsets.only(bottom: systemNavBarHeight),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  Expanded(child: _buildNavItem(0, iconSize)),
                  Expanded(child: _buildNavItem(1, iconSize)),
                  const SizedBox(width: 100),
                  Expanded(child: _buildNavItem(2, iconSize)),
                  Expanded(child: _buildNavItem(3, iconSize)),
                ],
              ),
            ),

            Positioned(
              bottom: totalBarHeight - (fabSize / 1.5) - 4,
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
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 36),
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
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              item.label,
              maxLines: 1,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? const Color(0xFF1B4E9F)
                    : const Color(0xff313131),
              ),
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
