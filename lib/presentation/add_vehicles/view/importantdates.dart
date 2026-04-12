import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/services/controller/add_vehicle_controller.dart';
import 'package:motorbridge/general_widget/customtaxbutton.dart';
import 'package:motorbridge/presentation/vehicles/widget/customdatecard.dart';


class ImportantDatesStep extends StatelessWidget {
  const ImportantDatesStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddVehicleController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Important Dates",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 25),
            
            CustomDateCard(
              label: "MOT Expiry",
              placeholder: "mm/dd/yyyy",
              imagePath: "assets/icon/uis_calender.png",
              dateValue: controller.motExpiryDate,
            ),
            
            const SizedBox(height: 20),
            
            CustomDateCard(
              label: "Road Tax Expiry",
              placeholder: "mm/dd/yyyy",
              imagePath: "assets/icon/uis_calender.png",
              dateValue: controller.roadTaxExpiryDate,
            ),
            
            const SizedBox(height: 20),
            
            CustomDateCard(
              label: "Insurance Expiry",
              placeholder: "mm/dd/yyyy",
              imagePath: "assets/icon/uis_calender.png",
              dateValue: controller.insuranceExpiryDate,
            ),
            
            const SizedBox(height: 20),
            
            CustomDateCard(
              label: "Service Due",
              placeholder: "mm/dd/yyyy",
              imagePath: "assets/icon/uis_calender.png",
              dateValue: controller.serviceDueDate,
            ),
            
            const SizedBox(height: 20),
            
            CustomDateCard(
              label: "Breakdown Cover Expiry",
              placeholder: "mm/dd/yyyy",
              imagePath: "assets/icon/uis_calender.png",
              dateValue: controller.breakdownExpiryDate,
            ),
            
            const SizedBox(height: 40),


            CustomButton(text: "Save & Continue", onTap: (){
              controller.setStep(2);
            },backgroundColor: Color(0xff3876B3),),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
