import 'package:flutter/material.dart';
import 'package:motorbridge/general_widget/custom_bottom_nav_bar.dart';
import 'package:motorbridge/general_widget/customappbar.dart';
import 'alldata.dart';
import 'expired.dart';
import 'upcomming.dart';

class Reminders extends StatelessWidget {
  const Reminders({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: "Reminders",
          backgroundImage: "assets/image/Image__3_-removebg-preview.png",
        ),
        bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 2),
        body: Column(
          children: [
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 60,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5EFF9),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: const Color(0xFF1B4E9F),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF7A7A7A),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                  tabs: const [
                    Tab(text: "All"),
                    Tab(text: "Upcoming"),
                    Tab(text: "Expired"),
                  ],
                ),
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  AllData(),
                  UpcomingData(),
                  ExpiredData(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
