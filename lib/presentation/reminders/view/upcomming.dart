import 'package:flutter/material.dart';

import '../widget/custom_text.dart';

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
                dateColor: Color(0xff2A2A2A),
                title: "MOT",
                date: "26 Apr 2026",
                expiryStatus: "Expires in 5 Days",
                vehicleName: "Vehicle 1",
                buttonText: "Book Now",
                iconPath: "assets/icon/Group (4).png",
                backgroundColor: Colors.white,
                titleColor: Colors.black87,

                expiryTextColor: Colors.grey.shade700,
                buttonColor: const Color(0xFF1B4E9F),
                badgeBackgroundColor: const Color(0xFFFFF4D0),
                badgeTextColor: const Color(0xFFFDC209),
                onButtonPressed: () {},
                buttonIconPath: 'assets/icon/fluent_share-20-filled.svg',
              ),
              SizedBox(height: 10,),
              CustomReminderCard(
                dateColor: Color(0xff2A2A2A),
                title: "MOT",
                date: "26 Apr 2026",
                expiryStatus: "Expires in 5 Days",
                vehicleName: "Vehicle 1",
                buttonText: "Book Now",
                iconPath: "assets/icon/Group (4).png",
                backgroundColor: Colors.white,
                titleColor: Colors.black87,

                expiryTextColor: Colors.grey.shade700,
                buttonColor: const Color(0xFF1B4E9F),
                badgeBackgroundColor: const Color(0xFFFFF4D0),
                badgeTextColor: const Color(0xFFFDC209),
                onButtonPressed: () {},
                buttonIconPath: 'assets/icon/fluent_share-20-filled.svg',
              ),
              SizedBox(height: 10,),
              CustomReminderCard(

                dateColor: Color(0xff2A2A2A),
                title: "MOT",
                date: "26 Apr 2026",
                expiryStatus: "Expires in 5 Days",
                vehicleName: "Vehicle 1",
                buttonText: "Book Now",
                iconPath: "assets/icon/Group (4).png",
                backgroundColor: Colors.white,
                titleColor: Colors.black87,

                expiryTextColor: Colors.grey.shade700,
                buttonColor: const Color(0xFF1B4E9F),
                badgeBackgroundColor: const Color(0xFFFFF4D0),
                badgeTextColor: const Color(0xFFFDC209),
                onButtonPressed: () {},
                buttonIconPath: 'assets/icon/fluent_share-20-filled.svg',
              ),



            ],

          ),
        ),
      ),


    );


  }

}
