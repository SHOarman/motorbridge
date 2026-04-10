import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/services/controller/add_vehicle_controller.dart';
import 'package:motorbridge/utils/app_text_styles.dart';

class CustomDateCard extends StatelessWidget {
  final String label;
  final String placeholder;
  final String imagePath;
  final RxString dateValue;

  final AddVehicleController controller = Get.find<AddVehicleController>();

  CustomDateCard({
    super.key,
    required this.label,
    required this.placeholder,
    required this.imagePath,
    required this.dateValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:  AppTextStyles.bigText.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xff454545)
          ),
        ),
        const SizedBox(height: 8),

        GestureDetector(
          onTap: () => controller.chooseDate(context, dateValue),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                  dateValue.value.isEmpty
                      ? placeholder
                      : dateValue.value,
                  style: TextStyle(
                    color: dateValue.value.isEmpty ? Colors.grey : Colors.black,
                    fontSize: 16,
                  ),
                )),

                Image.asset(
                  imagePath,
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.calendar_today, color: Color(0xFF2D6A8F)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}