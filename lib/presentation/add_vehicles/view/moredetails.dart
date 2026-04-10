import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/services/controller/add_vehicle_controller.dart';
import 'package:motorbridge/utils/app_colors.dart';

import '../../../general_widget/customtaxbutton.dart';

class MoreDetailsStep extends StatelessWidget {
  const MoreDetailsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddVehicleController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "More Details (OPTIONAL)",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 25),
            
            _buildLabel("VIN (Vehicle Identification Number)"),
            _buildTextField(
              controller: controller.vinController,
              hint: "e.g., WBA 273937923 937",
            ),
            
            const SizedBox(height: 20),
            
            _buildLabel("V5C Document Number"),
            _buildTextField(
              controller: controller.v5cController,
              hint: "e.g., 273937923 937",
            ),
            
            const SizedBox(height: 20),
            
            _buildLabel("Fuel Type"),
            _buildSelectorCard(
              value: controller.selectedFuelType,
              hint: "Select fuel type",
              onTap: () => _showSelectionPopup(
                context, 
                "Select Fuel Type", 
                ["Petrol", "Diesel", "Electric", "Hybrid", "LPG"],
                (val) => controller.setFuelType(val),
              ),
            ),
            
            const SizedBox(height: 20),
            
            _buildLabel("Body Type"),
            _buildSelectorCard(
              value: controller.selectedBodyType,
              hint: "Select Body type",
              onTap: () => _showSelectionPopup(
                context, 
                "Select Body Type", 
                ["Sedan", "Hatchback", "SUV", "Coupe", "Convertible", "Van", "Pickup"],
                (val) => controller.setBodyType(val),
              ),
            ),
            
            const SizedBox(height: 20),
            
            _buildLabel("Engine Size"),
            _buildTextField(
              controller: controller.engineSizeController,
              hint: "e.g., 2734",
            ),
            
            const SizedBox(height: 20),
            
            _buildLabel("Engine Code"),
            _buildTextField(
              controller: controller.engineCodeController,
              hint: "e.g., 2734",
            ),
            
            const SizedBox(height: 40),
            
            // Action Buttons
            CustomButton(text: "Save & Continue", onTap: (){
              controller.setStep(3);
            },backgroundColor: Color(0xff3876B3),),
            
            const SizedBox(height: 12),





            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton(
                onPressed: () {
                  controller.setStep(3); // Skip to Gallery
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Skip",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showSelectionPopup(
    BuildContext context, 
    String title, 
    List<String> options, 
    Function(String) onSelect
  ) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      options[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      onSelect(options[index]);
                      Get.back();
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFF454545),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1B4E9F), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSelectorCard({
    required RxnString value,
    required String hint,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => Text(
              value.value ?? hint,
              style: TextStyle(
                color: value.value == null ? Colors.grey : Colors.black87,
                fontSize: 15,
              ),
            )),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
