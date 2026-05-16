import 'package:flutter/material.dart';
import 'package:motorbridge/utils/app_text_styles.dart';

class CustomVehicleField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextStyle? labelStyle;
  final TextStyle? style;
  final bool readOnly;

  const CustomVehicleField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.labelStyle,
    this.style,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: labelStyle ?? AppTextStyles.bigText.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xff4A4A4A),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          style: style ?? AppTextStyles.bigText.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: readOnly ? Colors.grey : Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.bigText.copyWith(
                color: const Color(0xff454545),
                fontSize: 14,
                fontWeight: FontWeight.w500
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            filled: true,
            fillColor: readOnly ? const Color(0xffF9F9F9) : Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xffD0D0D0), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1B4E9F), width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}