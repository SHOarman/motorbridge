import 'package:flutter/material.dart';

import '../widget/customText.dart';

class UpcomingData  extends StatelessWidget {
  const UpcomingData ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20,),

              CustomReminderCard(
                title: "MOT",
                date: "26 Apr 2026",
                expiryStatus: "Expires in 5 Days",
                vehicleName: "Vehicle 1",
                buttonText: "Book Now",
                iconPath: "assets/icon/Group (4).png",
                backgroundColor: Colors.white,
                titleColor: Colors.black87,
                dateColor: Colors.grey.shade600,
                expiryTextColor: Colors.grey.shade700,
                buttonColor: const Color(0xFF1B4E9F),
                badgeBackgroundColor: const Color(0xFFFFF4D0),
                badgeTextColor: const Color(0xFFFDC209),
                onButtonPressed: () => print("Booking clicked"),
                buttonIconPath: 'assets/icon/fluent_share-20-filled.png',
              ),
              SizedBox(height: 10,),
              CustomReminderCard(
                title: "MOT",
                date: "26 Apr 2026",
                expiryStatus: "Expires in 5 Days",
                vehicleName: "Vehicle 1",
                buttonText: "Book Now",
                iconPath: "assets/icon/Group (4).png",
                backgroundColor: Colors.white,
                titleColor: Colors.black87,
                dateColor: Colors.grey.shade600,
                expiryTextColor: Colors.grey.shade700,
                buttonColor: const Color(0xFF1B4E9F),
                badgeBackgroundColor: const Color(0xFFFFF4D0),
                badgeTextColor: const Color(0xFFFDC209),
                onButtonPressed: () => print("Booking clicked"),
                buttonIconPath: 'assets/icon/fluent_share-20-filled.png',
              ),
              SizedBox(height: 10,),
              CustomReminderCard(
                title: "MOT",
                date: "26 Apr 2026",
                expiryStatus: "Expires in 5 Days",
                vehicleName: "Vehicle 1",
                buttonText: "Book Now",
                iconPath: "assets/icon/Group (4).png",
                backgroundColor: Colors.white,
                titleColor: Colors.black87,
                dateColor: Colors.grey.shade600,
                expiryTextColor: Colors.grey.shade700,
                buttonColor: const Color(0xFF1B4E9F),
                badgeBackgroundColor: const Color(0xFFFFF4D0),
                badgeTextColor: const Color(0xFFFDC209),
                onButtonPressed: () => print("Booking clicked"),
                buttonIconPath: 'assets/icon/fluent_share-20-filled.png',
              ),



            ],

          ),
        ),
      ),


    );


  }

}
