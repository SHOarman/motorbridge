import 'package:flutter/material.dart';
import 'package:motorbridge/utils/app_sizes.dart';

class VehicleCard extends StatelessWidget {
  final String vehicleName;
  final String year;
  final String engineCode;
  final String vehicleTag;
  final String registrationNumber;
  final String vehicleImage;
  final VoidCallback onViewDetails;
  final VoidCallback onTagTap;
  final Color registrationColor;
  final Color registrationTextColor;

  const VehicleCard({
    super.key,
    required this.vehicleName,
    required this.year,
    required this.engineCode,
    required this.vehicleTag,
    required this.registrationNumber,
    required this.vehicleImage,
    required this.onViewDetails,
    required this.onTagTap,
    this.registrationColor = const Color(0xFFFFD54F),
    this.registrationTextColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppSizes(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            vehicleName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: s.fontXXL,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF333333),
                            ),
                          ),
                        ),
                        SizedBox(width: s.spaceS),
                        Text(
                          year,
                          style: TextStyle(
                            fontSize: s.fontM,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      engineCode,
                      style: TextStyle(
                        fontSize: s.fontM,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onTagTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    vehicleTag,
                    style: TextStyle(
                      color: const Color(0xFFFFB300),
                      fontWeight: FontWeight.bold,
                      fontSize: s.fontM,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: s.spaceM),

          // Registration Number Plate
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: registrationColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      registrationNumber,
                      style: TextStyle(
                        fontSize: s.fontXL,
                        fontWeight: FontWeight.w900,
                        color: registrationTextColor,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: s.spaceM),
          SizedBox(
            height: s.vehicleCardImageHeight,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(vehicleImage, fit: BoxFit.contain),
            ),
          ),
          SizedBox(height: s.spaceM),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onViewDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B4E9F),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "View Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: s.fontL,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_right_alt, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}