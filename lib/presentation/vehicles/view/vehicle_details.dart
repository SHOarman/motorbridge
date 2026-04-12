import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import 'package:motorbridge/general_widget/customappbar.dart';
import 'package:get/get.dart';
import 'package:motorbridge/presentation/vehicles/widget/running_costs_card.dart';
import 'package:motorbridge/presentation/vehicles/widget/vehicle_documents_card.dart';
import 'package:motorbridge/utils/app_text_styles.dart';

import '../../reminders/widget/custom_text.dart';
import '../widget/custom_vehicle_field.dart';

class VehicleDetails extends StatelessWidget {
  const VehicleDetails({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1B4E9F);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: CustomAppBar(
        title: "Vehicle Details",
        backgroundImage: "assets/image/appbar.png",
        leftIcon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 20,
        ),
        onLeftTap: () => Get.back(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xff9DBDEE),
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/image/Rectangle_2-removebg-preview.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 15,
                          right: 15,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xffFFF4D0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              "Vehicle 1",
                              style: AppTextStyles.smallText.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xffFDC209),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Toyota Hilux",
                        style: AppTextStyles.bigText.copyWith(
                          fontSize: 24,
                          color: const Color(0xff2A2A2A),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Edit",
                                style: AppTextStyles.smallText.copyWith(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Image.asset(
                                "assets/icon/Vector (3).png",
                                height: 15,
                                width: 15,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "2GD-FTV. 2026",
                    style: AppTextStyles.smallText.copyWith(
                      fontSize: 16,
                      color: const Color(0xff888888),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xff141414),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(7),
                      color: const Color(0xffFDC209),
                    ),
                    child: Center(
                      child: Text(
                        "AB12 CDE",
                        style: AppTextStyles.bigText.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff2A2A2A),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            SizedBox(height: 20),
            CustomReminderCard(
              title: "MOT",
              date: "26 Apr 2026",
              vehicleName: "Due Soon",
              buttonText: "Book Now",
              iconPath: 'assets/icon/Group (4).png',
              buttonIconPath: 'assets/icon/fluent_share-20-filled.png',
              backgroundColor: Colors.white,
              titleColor: const Color(0xff2A2A2A),
              dateColor: const Color(0xff888888),
              expiryTextColor: const Color(0xff14B11C),
              buttonColor: primaryColor,
              customButtonTextColor: Colors.white,
              badgeBackgroundColor: const Color(0xffF4CC9D),
              badgeTextColor: const Color(0xff3F2402),
              borderColor: const Color(0xffCECECE),
              onButtonPressed: () {},
            ),
            CustomReminderCard(
              title: "Road Tax",
              date: "10 Jul 2026",
              vehicleName: "Upcoming",
              buttonText: "Pay Tax Online",
              iconPath: 'assets/icon/image 2.png',
              buttonIconPath: 'assets/icon/fluent_share-20-filled.png',
              backgroundColor: Colors.white,
              titleColor: const Color(0xff2A2A2A),
              dateColor: const Color(0xff888888),
              expiryTextColor: const Color(0xff14B11C),
              buttonColor: primaryColor,
              customButtonTextColor: Colors.white,
              badgeBackgroundColor: const Color(0xffD1FADF),
              badgeTextColor: const Color(0xff14B11C),
              borderColor: const Color(0xffCECECE),
              onButtonPressed: () {},
            ),
            CustomReminderCard(
              title: "Insurance",
              date: "10 July 2026",
              vehicleName: "Upcoming",
              buttonText: "Find Insurance",
              iconPath: 'assets/icon/image 3.png',
              buttonIconPath: 'assets/icon/fluent_share-20-filled.png',
              backgroundColor: Colors.white,
              titleColor: const Color(0xff2A2A2A),
              dateColor: const Color(0xff888888),
              expiryTextColor: const Color(0xff14B11C),
              buttonColor: primaryColor,
              customButtonTextColor: Colors.white,
              badgeBackgroundColor: const Color(0xffD1FADF),
              badgeTextColor: const Color(0xff14B11C),
              borderColor: const Color(0xffCECECE),
              onButtonPressed: () {},
            ),

            CustomReminderCard(
              title: "Service Due",
              date: "10 June 2026",
              vehicleName: "Upcoming",
              buttonText: "Book Now",
              iconPath: 'assets/icon/mdi_tools.png',
              buttonIconPath: 'assets/icon/fluent_share-20-filled.png',
              backgroundColor: Colors.white,
              titleColor: const Color(0xff2A2A2A),
              dateColor: const Color(0xff888888),
              expiryTextColor: const Color(0xff14B11C),
              buttonColor: primaryColor,
              customButtonTextColor: Colors.white,
              badgeBackgroundColor: const Color(0xffD1FADF),
              badgeTextColor: const Color(0xff14B11C),
              borderColor: const Color(0xffCECECE),
              onButtonPressed: () {},
            ),

            CustomReminderCard(
              title: "Breakdown Cover",
              date: "1 Jan 2026",
              vehicleName: "Expired",
              buttonText: "Find Cover",
              iconPath: 'assets/icon/image 4.png',
              buttonIconPath: 'assets/icon/fluent_share-20-filled.png',
              backgroundColor: Colors.white,
              titleColor: const Color(0xff2A2A2A),
              dateColor: const Color(0xff888888),
              expiryTextColor: const Color(0xff14B11C),
              buttonColor: primaryColor,
              customButtonTextColor: Colors.white,
              badgeBackgroundColor: const Color(0xffDABBBB),
              badgeTextColor: const Color(0xffB11414),
              borderColor: const Color(0xffDABBBB),
              onButtonPressed: () {},
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  CustomVehicleField(
                    label: "Engine Size",
                    hintText: "e.g., WBA 273937923 937",
                  ),
                  CustomVehicleField(
                    label: "Vin Number",
                    hintText: "e.g., WBA 273937923 937",
                  ),
                  CustomVehicleField(
                    label: "Engine Number",
                    hintText: "e.g., WBA 273937923 937",
                  ),
                  CustomVehicleField(label: "Color", hintText: "e.g., White"),
                  CustomVehicleField(
                    label: "Bhp",
                    hintText: "e.g., 150",
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            RunningCostsCard(
              iconPath: "assets/icon/Icon (18).png",
              trendIconPath: "assets/icon/Icon (19).png",
              repairIconPath: "assets/icon/Icon (20).png",
              arrowIconPath: "assets/icon/Icon (21).png",
              onPressed: () {},
            ),


            SizedBox(height: 20,),
            
            VehicleDocumentsCard(onAddTap: (){
              Get.toNamed(AppRoutes.addDocuments);
            }, onViewTap: (String p1) {
              print(p1);

            },),
            SizedBox(height: 20,),



          ],
        ),
      ),
    );
  }
}
