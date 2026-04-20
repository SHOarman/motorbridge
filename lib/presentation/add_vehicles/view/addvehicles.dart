import 'package:flutter/material.dart';
import 'package:motorbridge/general_widget/custom_bottom_nav_bar.dart';
import 'package:motorbridge/general_widget/customappbar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:get/get.dart';
import 'package:motorbridge/core/services/controller/add_vehicle_controller.dart';
import 'vehicletype.dart';
import 'importantdates.dart';
import 'moredetails.dart';
import 'galleryimages.dart';

class AddVehiclesScreen extends StatefulWidget {
  
  const AddVehiclesScreen({super.key});

  @override
  State<AddVehiclesScreen> createState() => _AddVehiclesScreenState();
}

class _AddVehiclesScreenState extends State<AddVehiclesScreen> {
  final _pageController = PageController();
  final controller = Get.put(AddVehicleController());

  @override
  void initState() {
    super.initState();
    // Sync controller and page controller
    ever(controller.currentStep, (int step) {
      if (_pageController.hasClients && _pageController.page!.round() != step) {
        _pageController.animateToPage(
          step,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 4),


      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        backgroundImage: "assets/image/Image__3_-removebg-preview.png",
        title: 'Add Vehicle',
        // leftIcon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        // onLeftTap: (){
        //   Get.back();
        // },
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          
          SmoothPageIndicator(
            controller: _pageController,
            count: 4, // Total 4 pages
            effect: const ExpandingDotsEffect(
              activeDotColor: Color(0xFF2D6A8F), // Dark blue
              dotColor: Color(0xFFB0D4EC),      // Light blue
              dotHeight: 8,
              dotWidth: 24,
              expansionFactor: 2.5, 
              spacing: 8,
            ),
          ),

          const SizedBox(height: 25),

          // 2. PageView containing the steps
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => controller.setStep(index),
              children: const [
                VehicleTypeStep(),
                ImportantDatesStep(),
                MoreDetailsStep(),
                GalleryImagesStep(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
