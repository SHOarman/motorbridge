import 'package:flutter/material.dart';

class AddVehicleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onAddPressed;

  const AddVehicleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF4A89D3), Color(0xFF1B4E9F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // ব্যাকগ্রাউন্ড সার্কেল এফেক্ট
          Positioned(
            right: -20,
            top: -20,
            child: CircleAvatar(
              radius: 70,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
            ),
          ),

          // গাড়ির ইমেজ
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              imagePath,
              height: 160,
              fit: BoxFit.contain,
            ),
          ),

          // টেক্সট এবং বাটন সেকশন
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Add Vehicle Button
                GestureDetector(
                  onTap: onAddPressed,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF265DAB),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 5,
                        )
                      ],
                    ),
                    child: const Text(
                      "Add Vehicle +",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}