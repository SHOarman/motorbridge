import 'package:flutter/material.dart';

import '../widget/customText.dart';

class ExpiredData extends StatelessWidget {
  const ExpiredData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [

              SizedBox(height: 20),

              CustomReminderCard(
                title: "Insurance",
                date: "Due: 10 Jan 2026",
                expiryStatus: "Expired 20 Days Ago",
                vehicleName: "Vehicle 1",
                buttonText: "Pay Tax Online",
                iconPath: "assets/icon/image 3.png",
                backgroundColor: Color(0xffFDEBEB),
                titleColor: Colors.black87,
                dateColor: Colors.grey.shade600,
                expiryTextColor: Color(0xffEA0E0E),
                buttonColor: const Color(0xFF1B4E9F),
                badgeBackgroundColor: const Color(0xFFFFD0D0),
                badgeTextColor: const Color(0xFFFD0909),
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
