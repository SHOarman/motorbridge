import 'package:flutter/material.dart';
import 'package:motorbridge/utils/app_text_styles.dart';

class VehicleDocumentsCard extends StatelessWidget {
  final VoidCallback onAddTap;
  final Function(String) onViewTap;

  const VehicleDocumentsCard({
    super.key,
    required this.onAddTap,
    required this.onViewTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      // margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xffEEEEEE), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Vehicle Documents",
            style: AppTextStyles.bigText.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xff2A2A2A),
            ),
          ),
          const SizedBox(height: 16),
          DocumentItem(
            title: "MOT Certificate",
            onViewTap: () => onViewTap("MOT Certificate"),
          ),
          const SizedBox(height: 12),
          DocumentItem(
            title: "Insurance Certificate",
            onViewTap: () => onViewTap("Insurance Certificate"),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onAddTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff1B3A6E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, color: Colors.white, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    "Add Documents",
                    style: AppTextStyles.smallText.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DocumentItem extends StatelessWidget {
  final String title;
  final VoidCallback onViewTap;

  const DocumentItem({
    super.key,
    required this.title,
    required this.onViewTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffF0F0F0), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xffFFEBEE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "PDF",
              style: TextStyle(
                color: Color(0xffE53935),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.smallText.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color(0xff4A4A4A),
              ),
            ),
          ),
          GestureDetector(
            onTap: onViewTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xffF1F3F8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "View",
                style: AppTextStyles.smallText.copyWith(
                  color: const Color(0xff607D8B),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}