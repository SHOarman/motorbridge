import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import 'package:motorbridge/general_widget/custom_bottom_nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:motorbridge/presentation/home/widget/add_vehicle_card.dart';
import 'package:motorbridge/presentation/home/widget/custom_action_button.dart';
import 'package:motorbridge/presentation/home/widget/custom_action_card.dart';

import 'package:motorbridge/utils/app_text_styles.dart';
import '../../../core/services/controller/home_controller.dart';
import '../widget/vehiclecard.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Error", "Could not launch $url");
    }
  }



  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1B4E9F);

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(260),
        child: AppBar(
          backgroundColor: primaryColor,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              children: [
                Positioned(
                  right: -40,
                  top: -40,
                  child: Image.asset(
                    'assets/image/appbar.png',
                    width: 220,
                    opacity: const AlwaysStoppedAnimation(0.5),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            'assets/image/Frame 427318960.png',
                            height: 35,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          "Hi Tanvir",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Welcome to your",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              "Virtual ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Garage",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Bridging the gap for motoring.",
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          MediaQuery.of(context).padding.bottom + 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddVehicleCard(
              title: "Add Your Vehicle To Your Virtual Garage",
              subtitle:
                  "Add your vehicle, get timely reminders,\n and never miss an important date.",
              imagePath: "assets/image/whitecar.png",
              onAddPressed: () {
                Get.toNamed(AppRoutes.addvehicles);
              },
            ),
            const SizedBox(height: 16),
            CustomActionCard(
              title: "Why Choose Motorbridge",
              bgColor: const Color(0x33000BE0),
              contentColor: const Color(0xFF000BE0),
              onTap: () {},
              iconPath: 'assets/icon/Vector (2).png',
            ),
            const SizedBox(height: 10),
            CustomActionCard(
              title: "Help & Tutorial",
              bgColor: const Color(0x3300B100),
              contentColor: const Color(0xFF00B100),
              onTap: () {},
              iconPath: 'assets/icon/Frame (5).png',
            ),
            // const SizedBox(height: 20),
            // Container(
            //   height: 400,
            //   decoration: BoxDecoration(
            //     color: const Color(0xffF99D66).withValues(alpha: 0.2),
            //     borderRadius: BorderRadius.circular(16),
            //     border: Border.all(color: const Color(0xFFFFB900), width: 1),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(20),
            //     child: Column(
            //       children: [
            //         Row(
            //           children: [
            //             Image.asset(
            //               "assets/icon/Container (19).png",
            //               width: 25,
            //               height: 25,
            //             ),
            //             const SizedBox(width: 10),
            //             Text(
            //               "Important Legal Notice",
            //               style: AppTextStyles.bigText.copyWith(
            //                 fontSize: 18,
            //                 fontWeight: FontWeight.w500,
            //               ),
            //             ),
            //           ],
            //         ),
            //         const SizedBox(height: 10),
            //         Text(
            //           "This page provides quick access to emergency\n contact numbers and your stored vehicle information.",
            //           style: AppTextStyles.smallText,
            //         ),
            //         const SizedBox(height: 6),
            //         Text(
            //           "Always call 999 in a life-threatening emergency.",
            //           style: AppTextStyles.bigText.copyWith(
            //             fontSize: 13,
            //             fontWeight: FontWeight.w500,
            //           ),
            //         ),
            //         const SizedBox(height: 10),
            //         RichText(
            //           text: const TextSpan(
            //             style: TextStyle(
            //               fontSize: 14,
            //               color: Color(0xFF4A4A4A),
            //               height: 1.5,
            //             ),
            //             children: [
            //               TextSpan(
            //                 text:
            //                     "Motor Bridge UK is a reminder and information storage tool only. ",
            //               ),
            //               TextSpan(
            //                 text: "We take no liability",
            //                 style: TextStyle(
            //                   fontWeight: FontWeight.bold,
            //                   color: Colors.black,
            //                 ),
            //               ),
            //               TextSpan(
            //                 text:
            //                     " for the accuracy of contact numbers, policy details, or any decisions made using information stored in this app.\n\n",
            //               ),
            //               TextSpan(
            //                 text: "You are solely responsible",
            //                 style: TextStyle(
            //                   fontWeight: FontWeight.bold,
            //                   color: Colors.black,
            //                 ),
            //               ),
            //               TextSpan(
            //                 text:
            //                     " for ensuring your stored information is accurate and up-to-date.",
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(height: 30),
            CustomActionButton(
              title: "Motoring Emergencies",
              subtitle: "Quick access to emergency contact & insurance details",
              iconPath: "assets/icon/Frame (6).png",
              bgColor: const Color(0xFFC62828),
              contentColor: Colors.white,
              onTap: () {},
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
            const SizedBox(height: 8),

            // const SizedBox(height: 20),
            // MyEmergencyButton(),
            const SizedBox(height: 20),
            Text(
              "Added Vehicles",
              style: AppTextStyles.bigText.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
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
            const SizedBox(height: 30),
            const Text(
              "Important: Motor Bridge UK is a reminder tool only. We accept no liability for missed renewals, fines, or any decisions made using this app. You are solely responsible for maintaining valid MOT, tax, and insurance. Always verify dates with official sources.",
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 15),
            const Text(
              "© 2026 Motor Bridge UK. All rights reserved.",
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 5),

            GestureDetector(
              onTap: () => _launchUrl("https://motor-bridge.co.uk/"),
              child: const Text(
                "| motor-bridge.co.uk",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
