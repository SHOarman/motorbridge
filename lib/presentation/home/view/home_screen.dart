import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// Project specific imports
import 'package:motorbridge/core/route/app_routes.dart';
import 'package:motorbridge/general_widget/custom_bottom_nav_bar.dart';
import 'package:motorbridge/presentation/home/widget/add_vehicle_card.dart';
import 'package:motorbridge/presentation/home/widget/custom_action_button.dart';
import 'package:motorbridge/presentation/home/widget/custom_action_card.dart';
import 'package:motorbridge/utils/app_text_styles.dart';
import 'package:motorbridge/utils/app_sizes.dart';
import '../../../core/services/controller/home_controller.dart';
import '../widget/vehiclecard.dart';
import 'helpandtutorial.dart';

final List<Map<String, String>> whyChooseData = [
  {
    "title": "Never Miss a Deadline",
    "desc": "Smart notifications remind you when your MOT, tax, insurance, or service is due. Stay legal and safe on UK roads without the stress of remembering dates.",
    "image": "assets/image/Rectangle 11.png",
    "icon": "assets/icon/activereminder.png",
  },
  {
    "title": "All Dates in One Place",
    "desc": "Track MOT expiry, road tax, and service schedules for all your vehicles from a single dashboard.",
    "image": "assets/image/Rectangle 11 (8).png",
    "icon": "assets/icon/uis_calender.png",
  },
  {
    "title": "Stay Road Legal",
    "desc": "Driving without valid MOT, tax, or insurance can result in fines up to £1,000, points on your licence, or even vehicle seizure.",
    "image": "assets/image/Rectangle 11 (9).png",
    "icon": "assets/icon/image 3.png",
  },
  {
    "title": "Digital Document Storage",
    "desc": "Upload and store all your vehicle documents securely in the cloud. Access certificates anytime, anywhere.",
    "image": "assets/image/Rectangle 11 (10).png",
    "icon": "assets/icon/calendar 1.png",
  },
  {
    "title": "Multi-Vehicle Management",
    "desc": "Whether you have a car, van, bike, or HGV, manage unlimited vehicles from one account.",
    "image": "assets/image/Rectangle 11 (11).png",
    "icon": "assets/icon/calendar 1 (1).png",
  },
  {
    "title": "Access Anywhere",
    "desc": "Your virtual garage is accessible from any device. Check expiry dates on your phone while at the garage.",
    "image": "assets/image/Rectangle 11 (12).png",
    "icon": "assets/icon/calendar 1 (2).png",
  },
  {
    "title": "Track Running Costs",
    "desc": "Monitor all your vehicle expenses including fuel, servicing, MOT, insurance, and repairs.",
    "image": "assets/image/Rectangle 11 (13).png",
    "icon": "assets/icon/calendar 1 (3).png",
  },
];

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Error", "Could not launch $url");
    }
  }

  void showWhyChoosePopup(BuildContext context) {
    int currentIndex = 0;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final dialogPageHeight = screenHeight * 0.52;
    final imageHeight = screenHeight * 0.20;
    final headerSpacing = screenHeight * 0.025;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.03,
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: dialogPageHeight,
                      child: PageView.builder(
                        itemCount: whyChooseData.length,
                        onPageChanged: (index) => setState(() => currentIndex = index),
                        itemBuilder: (context, index) {
                          var item = whyChooseData[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: RichText(
                                        text: TextSpan(
                                          style: AppTextStyles.bigText.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black,
                                          ),
                                          children: const [
                                            TextSpan(text: "Why choose "),
                                            TextSpan(
                                              text: "Motor Bridge\nUK?",
                                              style: TextStyle(color: Color(0xFF1B4E9F)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                                      ),
                                      child: Image.asset(item['icon']!, width: 26, height: 26),
                                    ),
                                  ],
                                ),
                                SizedBox(height: headerSpacing),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1B4E9F),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        width: double.infinity,
                                        height: imageHeight,
                                        margin: const EdgeInsets.all(12),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.asset(item['image']!, fit: BoxFit.cover),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['title']!,
                                              style: AppTextStyles.bigText.copyWith(fontSize: 16, color: Colors.white),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              item['desc']!,
                                              maxLines: 3,
                                              style: AppTextStyles.smallText.copyWith(fontSize: 11, color: const Color(0xffD8D8D8)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(whyChooseData.length, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: currentIndex == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: currentIndex == index ? const Color(0xFF1B4E9F) : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppSizes(context);
    const Color primaryColor = Color(0xFF1B4E9F);

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(s.homeAppBarHeight),
        child: AppBar(
          backgroundColor: primaryColor,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              children: [
                Positioned(
                  right: -40,
                  top: -40,
                  child: Image.asset('assets/image/Image__3_-removebg-preview.png', width: 220),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                          child: Image.asset('assets/image/img.png', height: 40, fit: BoxFit.cover),
                        ),
                        const Spacer(),
                        const Text("Hi Tanvir", style: TextStyle(color: Colors.white, fontSize: 16)),
                        const SizedBox(height: 4),
                        const Text("Welcome to your", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        const Row(
                          children: [
                            Text("Virtual ", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                            Text("Garage", style: TextStyle(color: Colors.white54, fontSize: 26, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text("Bridging the gaps to smarter motoring.", style: TextStyle(color: Color(0xffEFEFEF), fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                const SizedBox(height: 110),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: const BoxDecoration(
                      color: Color(0xffFFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(9)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                          spreadRadius: 0,
                          blurStyle: BlurStyle.normal
                        )
                      ]
                     
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(18, 0, 18, MediaQuery.of(context).padding.bottom + 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddVehicleCard(
                  title: "Add Your Vehicle To Your Virtual Garage",
                  imagePath: "assets/image/whitecar.png",
                  onAddPressed: () => Get.toNamed(AppRoutes.addvehicles),
                  subtitle: 'Add your vehicle, get timely reminders,\nand never miss an important date.',
                ),
                const SizedBox(height: 16),
                CustomActionCard(
                  title: "Why Choose Motorbridge",
                  bgColor: const Color(0x33000BE0),
                  contentColor: const Color(0xFF000BE0),
                  onTap: () => showWhyChoosePopup(context),
                  iconPath: 'assets/icon/Vector (2).png',
                ),
                const SizedBox(height: 10),
                CustomActionCard(
                  title: "Help & Tutorial",
                  bgColor: const Color.fromRGBO(0, 177, 0, 0.2),
                  contentColor: const Color(0xFF00B100),
                  onTap: () => Get.to(() => const HelpAndTutorialView()),
                  iconPath: 'assets/icon/Frame (5).png',
                ),
                const SizedBox(height: 30),
                CustomActionButton(
                  title: "Motoring Emergencies",
                  subtitle: "Quick access to emergency contact & insurance details",
                  iconPath: "assets/icon/Frame (6).png",
                  bgColor: const Color(0xffBD1D1D),
                  contentColor: const Color(0xffFCFDFF),
                  onTap: () => Get.toNamed(AppRoutes.motoringemergencies),
                ),
                const SizedBox(height: 8),
                CustomActionButton(
                  title: "Visit Motor Bridge UK",
                  subtitle: "All of your motoring solutions",
                  iconPath: 'assets/icon/Frame (7).png',
                  bgColor: const Color(0xFF283593),
                  contentColor: Colors.white,
                  iconAfterText: true,
                  onTap: () => _launchUrl("https://motor-bridge.co.uk/"),
                ),
                const SizedBox(height: 20),
                Text(
                  "Added Vehicles",
                  style: AppTextStyles.bigText.copyWith(fontSize: 22, fontWeight: FontWeight.w500, color: const Color(0xff525252)),
                ),
                const SizedBox(height: 10),
                VehicleCard(
                  hasBorder: true,
                  registrationTextColor: const Color(0xff000000),
                  vehicleName: "Hilux",
                  year: "2026",
                  engineCode: "2GD-FTV",
                  vehicleTag: "Vehicle 1",
                  registrationNumber: "AB12 CDE",
                  vehicleImage: "assets/image/Rectangle_2-removebg-preview.png",
                  onTagTap: () {},
                  onViewDetails: () => Get.toNamed(AppRoutes.vehicledetails),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Important: Motor Bridge UK is a reminder tool only...",
                  style: TextStyle(color: Color(0xff888888), fontSize: 14),
                ),
                const SizedBox(height: 15),
                const Text("© 2026 Motor Bridge UK. All rights reserved.", style: TextStyle(color: Color(0xff888888), fontSize: 14)),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () => _launchUrl("https://motor-bridge.co.uk"),
                  child: const Text(
                    "| motor-bridge.co.uk",
                    style: TextStyle(color: Color(0xff888888), fontSize: 14, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}