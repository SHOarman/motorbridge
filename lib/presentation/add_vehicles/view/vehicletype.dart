import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/services/controller/add_vehicle_controller.dart';
import 'package:motorbridge/general_widget/customtaxbutton.dart';
import 'package:motorbridge/utils/app_colors.dart';

class VehicleTypeStep extends StatelessWidget {

  const VehicleTypeStep({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(AddVehicleController());

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Vehicle Type*",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 15),
          
          // Vehicle Type Cards
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildVehicleCard(
                type: 'Car',
                iconPath: 'assets/image/car (1) 1 (3).png',
                isSelected: controller.selectedVehicleType.value == 'Car',
                onTap: () => controller.setVehicleType('Car'),
              ),
              _buildVehicleCard(
                type: 'Van',
                iconPath: 'assets/image/car (1) 1.png',
                isSelected: controller.selectedVehicleType.value == 'Van',
                onTap: () => controller.setVehicleType('Van'),
              ),
              _buildVehicleCard(
                type: 'Bike',
                iconPath: 'assets/image/car (1) 1 (1).png',
                isSelected: controller.selectedVehicleType.value == 'Bike',
                onTap: () => controller.setVehicleType('Bike'),
              ),
              _buildVehicleCard(
                type: 'HGV',
                iconPath: 'assets/image/car (1) 1 (2).png',
                isSelected: controller.selectedVehicleType.value == 'HGV',
                onTap: () => controller.setVehicleType('HGV'),
              ),
            ],
          )),
          
          const SizedBox(height: 25),
          

          _buildLabel("Registration*"),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: controller.registrationController,
                  hint: "e.g., AB12 CDE",
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Find Vehicle"),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          _buildLabel("Make*"),
          _buildTextField(
            controller: controller.makeController,
            hint: "e.g., TOYOTA",
          ),
          
          const SizedBox(height: 20),
          
          _buildLabel("Model*"),
          _buildTextField(
            controller: controller.modelController,
            hint: "e.g., HILUX",
          ),
          
          const SizedBox(height: 20),
          
          _buildLabel("Year"),
          GestureDetector(
            onTap: () {
              _showYearPicker(context, controller);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                    controller.selectedYear.value ?? "Select Year",
                    style: TextStyle(
                      color: controller.selectedYear.value == null ? Colors.grey : Colors.black87,
                      fontSize: 16,
                    ),
                  )),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          CustomButton(text: "Save & Continue", onTap: (){
            controller.setStep(1);
          },backgroundColor: Color(0xff3876B3),),
          

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showYearPicker(BuildContext context, AddVehicleController controller) {
    final currentYear = DateTime.now().year;
    final years = List.generate(currentYear - 1950 + 1, (index) => (currentYear - index).toString());

    Get.bottomSheet(
      Container(
        height: 400,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Select Vehicle Year",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: years.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      years[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: controller.selectedYear.value == years[index]
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: controller.selectedYear.value == years[index]
                            ? const Color(0xFF1B4E9F)
                            : Colors.black87,
                      ),
                    ),
                    onTap: () {
                      controller.selectedYear.value = years[index];
                      Get.back();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildVehicleCard({
    required String type,
    required String iconPath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final activeColor = const Color(0xFF1B4E9F);
    final borderColor = const Color(0xFFB0D4EC);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 85,
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? activeColor : borderColor,
            width: 1.5,
          ),
          boxShadow: [
            if (isSelected) 
              BoxShadow(
                color: activeColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 40,
              color: isSelected ? Colors.white : activeColor,
            ),
            const SizedBox(height: 8),
            Text(
              type,
              style: TextStyle(
                color: isSelected ? Colors.white : activeColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
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
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D3748),
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
}
