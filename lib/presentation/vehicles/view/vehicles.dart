import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import '../../../general_widget/custom_bottom_nav_bar.dart';
import '../../../general_widget/customappbar.dart';
import '../../home/widget/vehiclecard.dart';

class Vehicles extends StatelessWidget {
  const Vehicles({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 1),
      appBar: const CustomAppBar(
        title: "Added Vehicles",
        backgroundImage: "assets/image/appbar.png",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            VehicleCard(
              vehicleName: "Hilux",
              year: "2026",
              engineCode: "2GD-FTV",
              vehicleTag: "Vehicle 1",
              registrationNumber: "AB12 CDE",
              vehicleImage: "assets/image/Rectangle 2.png",
              onTagTap: () {},
              onViewDetails: () {
                Get.toNamed(AppRoutes.vehicledetails);
              },
            ),
            const SizedBox(height: 10),
            VehicleCard(
              vehicleName: "Hilux",
              year: "2026",
              engineCode: "2GD-FTV",
              vehicleTag: "Vehicle 2",
              registrationNumber: "AB12 CDE",
              vehicleImage: "assets/image/Rectangle 2.png",
              registrationColor: const Color(0xffE5EFF9),
              registrationTextColor: const Color(0xff535353),
              onTagTap: () {},
              onViewDetails: () {
                Get.toNamed(AppRoutes.vehicledetails);
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}