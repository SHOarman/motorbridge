import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/services/controller/add_vehicle_controller.dart';
import 'package:motorbridge/general_widget/customtaxbutton.dart';
import 'package:motorbridge/utils/app_colors.dart';
import 'package:motorbridge/utils/app_text_styles.dart';

class VehicleTypeStep extends StatelessWidget {
  const VehicleTypeStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddVehicleController());

    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    // Responsive dimensions
    final double hPad        = sw * 0.050;   // horizontal page padding ~18px
    final double cardWidth   = (sw - hPad * 2 - 12 * 3) / 4; // 4 cards fit evenly
    final double cardHeight  = cardWidth * 0.94;
    final double imgSize     = cardWidth * 0.46;
    final double cardFont    = sw * 0.032;   // ~11–12px
    final double labelFont   = sw * 0.048;   // ~17px
    final double hintFont    = sw * 0.034;   // ~12px
    final double fieldFont   = sw * 0.038;   // ~14px
    final double vGap        = sh * 0.022;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: vGap),

          // ── Section title ──
          Text(
            "Vehicle Type*",
            style: TextStyle(
              fontSize: sw * 0.045,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: sh * 0.018),

          // ── Vehicle type cards ──
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildVehicleCard(
                    context: context,
                    type: 'Car',
                    iconPath: 'assets/image/car (1) 1 (3).png',
                    isSelected: controller.selectedVehicleType.value == 'Car',
                    onTap: () => controller.setVehicleType('Car'),
                    cardWidth: cardWidth,
                    cardHeight: cardHeight,
                    imgSize: imgSize,
                    fontSize: cardFont,
                  ),
                  _buildVehicleCard(
                    context: context,
                    type: 'Van',
                    iconPath: 'assets/image/car (1) 1.png',
                    isSelected: controller.selectedVehicleType.value == 'Van',
                    onTap: () => controller.setVehicleType('Van'),
                    cardWidth: cardWidth,
                    cardHeight: cardHeight,
                    imgSize: imgSize,
                    fontSize: cardFont,
                  ),
                  _buildVehicleCard(
                    context: context,
                    type: 'Bike',
                    iconPath: 'assets/image/car (1) 1 (1).png',
                    isSelected: controller.selectedVehicleType.value == 'Bike',
                    onTap: () => controller.setVehicleType('Bike'),
                    cardWidth: cardWidth,
                    cardHeight: cardHeight,
                    imgSize: imgSize,
                    fontSize: cardFont,
                  ),
                  _buildVehicleCard(
                    context: context,
                    type: 'HGV',
                    iconPath: 'assets/image/car (1) 1 (2).png',
                    isSelected: controller.selectedVehicleType.value == 'HGV',
                    onTap: () => controller.setVehicleType('HGV'),
                    cardWidth: cardWidth,
                    cardHeight: cardHeight,
                    imgSize: imgSize,
                    fontSize: cardFont,
                  ),
                ],
              )),

          SizedBox(height: vGap),

          // ── Registration ──
          _buildLabel(context, "Registration*", labelFont),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: controller.registrationController,
                  hint: "e.g., AB12 CDE",
                  hintFont: hintFont,
                  fieldFont: fieldFont,
                  vPad: sh * 0.018,
                  hPad: sw * 0.040,
                ),
              ),
              SizedBox(width: sw * 0.025),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: sw * 0.038,
                    vertical: sh * 0.018,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Find Vehicle",
                  style: TextStyle(fontSize: fieldFont),
                ),
              ),
            ],
          ),

          SizedBox(height: vGap),

          // ── Make ──
          _buildLabel(context, "Make*", labelFont),
          _buildTextField(
            controller: controller.makeController,
            hint: "e.g., TOYOTA",
            hintFont: hintFont,
            fieldFont: fieldFont,
            vPad: sh * 0.018,
            hPad: sw * 0.040,
          ),

          SizedBox(height: vGap),

          // ── Model ──
          _buildLabel(context, "Model*", labelFont),
          _buildTextField(
            controller: controller.modelController,
            hint: "e.g., HILUX",
            hintFont: hintFont,
            fieldFont: fieldFont,
            vPad: sh * 0.018,
            hPad: sw * 0.040,
          ),

          SizedBox(height: vGap),

          // ── Year picker ──
          _buildLabel(context, "Year", labelFont),
          GestureDetector(
            onTap: () => _showYearPicker(context, controller),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: sw * 0.040,
                vertical: sh * 0.018,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                        controller.selectedYear.value ?? "Select Year",
                        style: TextStyle(
                          color: controller.selectedYear.value == null
                              ? Colors.grey
                              : Colors.black87,
                          fontSize: fieldFont,
                        ),
                      )),
                  Icon(Icons.keyboard_arrow_down,
                      color: Colors.grey, size: sw * 0.055),
                ],
              ),
            ),
          ),

          SizedBox(height: sh * 0.045),

          // ── Save & Continue ──
          CustomButton(
            text: "Save & Continue",
            onTap: () => controller.setStep(1),
            backgroundColor: const Color(0xff3876B3),
          ),

          SizedBox(height: vGap),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Vehicle type card
  // ─────────────────────────────────────────────────────────
  Widget _buildVehicleCard({
    required BuildContext context,
    required String type,
    required String iconPath,
    required bool isSelected,
    required VoidCallback onTap,
    required double cardWidth,
    required double cardHeight,
    required double imgSize,
    required double fontSize,
  }) {
    const activeColor = Color(0xFF1B4E9F);
    const borderColor = Color(0xFFB0D4EC);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: cardWidth,
        height: cardHeight,
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
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: imgSize,
              height: imgSize,
              fit: BoxFit.contain,
              color: isSelected ? Colors.white : activeColor,
            ),
            SizedBox(height: cardHeight * 0.08),
            Text(
              type,
              style: TextStyle(
                color: isSelected ? Colors.white : activeColor,
                fontWeight: FontWeight.w600,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Section label
  // ─────────────────────────────────────────────────────────
  Widget _buildLabel(BuildContext context, String label, double fontSize) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: AppTextStyles.bigText.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: const Color(0xff2A2A2A),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Text field
  // ─────────────────────────────────────────────────────────
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required double hintFont,
    required double fieldFont,
    required double vPad,
    required double hPad,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(fontSize: fieldFont),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: hintFont),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
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
          borderSide:
              const BorderSide(color: Color(0xFF1B4E9F), width: 1.5),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Year picker bottom sheet
  // ─────────────────────────────────────────────────────────
  void _showYearPicker(
      BuildContext context, AddVehicleController controller) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final currentYear = DateTime.now().year;
    final years = List.generate(
        currentYear - 1950 + 1, (i) => (currentYear - i).toString());

    Get.bottomSheet(
      Container(
        height: sh * 0.50,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: sh * 0.012),
            Container(
              width: sw * 0.10,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: sh * 0.022),
              child: Text(
                "Select Vehicle Year",
                style: TextStyle(
                  fontSize: sw * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: years.length,
                itemBuilder: (context, index) {
                  final selected =
                      controller.selectedYear.value == years[index];
                  return ListTile(
                    title: Text(
                      years[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: sw * 0.040,
                        fontWeight:
                            selected ? FontWeight.bold : FontWeight.normal,
                        color: selected
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
}
