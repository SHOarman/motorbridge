import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import '../../../general_widget/custom_bottom_nav_bar.dart';
import '../../../general_widget/customappbar.dart';
import '../../home/widget/vehiclecard.dart';
import '../../../core/services/controller/home_controller.dart';

class Vehicles extends StatelessWidget {
  const Vehicles({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());
    controller.fetchVehicles(); // Trigger refresh on loading page

    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 1),
      appBar: const CustomAppBar(
        title: "Added Vehicles",
        backgroundImage: "assets/image/Image__3_-removebg-preview.png",
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.vehiclesList.isEmpty) {
          return const Center(
            child: Text(
              "No vehicles added yet",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                ...List.generate(controller.vehiclesList.length, (index) {
                  final vehicle = controller.vehiclesList[index];
                  final List<dynamic> gallery = vehicle['galleryImages'] is List ? vehicle['galleryImages'] : [];
                  final String imgPath = gallery.isNotEmpty ? gallery[0].toString() : '';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: VehicleCard(
                      hasBorder: true,
                      vehicleName: "${vehicle['make'] ?? ''} ${vehicle['model'] ?? ''}",
                      year: (vehicle['year'] ?? '').toString(),
                      engineCode: vehicle['engineCode'] ?? '',
                      vehicleTag: "Vehicle ${index + 1}",
                      registrationNumber: vehicle['registration'] ?? '',
                      vehicleImage: imgPath,
                      onTagTap: () {},
                      onViewDetails: () {
                        Get.toNamed(AppRoutes.vehicledetails, arguments: vehicle);
                      },
                    ),
                  );
                }),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }
}