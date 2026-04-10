import 'package:flutter/material.dart';
import '../../../general_widget/custom_bottom_nav_bar.dart';
import '../../../general_widget/customappbar.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 3),
      appBar: CustomAppBar(
        title: "Profile",
        backgroundImage: "assets/image/appbar.png",
      ),
      body: const Center(
        child: Text("Profile Screen - Under Development"),
      ),
    );
  }
}
