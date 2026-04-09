import 'package:flutter/material.dart';

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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                        Text(
                          vehicleName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          year,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      engineCode,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
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
                    style: const TextStyle(
                      color: Color(0xFFFFB300),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Registration Number Plate Section
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: registrationColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Container(
                //   width: 12,
                //   decoration: BoxDecoration(
                //     color: Colors.black.withOpacity(0.1),
                //     borderRadius: const BorderRadius.only(
                //       topLeft: Radius.circular(8),
                //       bottomLeft: Radius.circular(8),
                //     ),
                //   ),
                // ),
                Expanded(
                  child: Center(
                    child: Text(
                      registrationNumber,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: registrationTextColor,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),

          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(vehicleImage, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onViewDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B4E9F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "View Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_right_alt, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}