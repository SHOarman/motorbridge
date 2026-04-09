import 'package:flutter/material.dart';

import '../../../general_widget/custom_bottom_nav_bar.dart';
import '../../../general_widget/customappbar.dart';
import '../../home/widget/vehiclecard.dart';

class Vehicels extends StatelessWidget {
  const Vehicels({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),

      appBar: CustomAppBar(
        title: "Added Vehicles",
        backgroundImage: "assets/image/appbar.png",



      ),

     body: SingleChildScrollView(
       child: Column(
         children: [

           SizedBox(height: 10,),

           VehicleCard(
             vehicleName: "Hilux",
             year: "2026",
             engineCode: "2GD-FTV",
             vehicleTag: "Vehicle 1",
             registrationNumber: "AB12 CDE",
             vehicleImage: "assets/image/Rectangle 2.png",
             onTagTap: () {},
             onViewDetails: () {},
           ),

           SizedBox(height: 10,),

           VehicleCard(
             vehicleName: "Hilux",
             year: "2026",
             engineCode: "2GD-FTV",
             vehicleTag: "Vehicle 2",
             registrationNumber: "AB12 CDE",
             vehicleImage: "assets/image/Rectangle 2.png",
             registrationColor:Color(0xffE5EFF9) ,
             registrationTextColor: Color(0xff535353),
             onTagTap: () {},
             onViewDetails: () {},
           ),

           SizedBox(height: 40,),


         ],
       ),
     ),
    );
  }
}