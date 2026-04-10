// import 'package:flutter/material.dart';
// import 'package:motorbridge/general_widget/customappbar.dart';
// import 'package:get/get.dart';
//
// class VehicleDetails extends StatelessWidget {
//   const VehicleDetails({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     const Color primaryColor = Color(0xFF1B4E9F);
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F6F8),
//       appBar: CustomAppBar(
//         title: "Vehicle Details",
//         backgroundImage: "assets/image/appbar.png",
//         leftIcon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
//         onLeftTap: () => Get.back(),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Vehicle Hero Section
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.05),
//                     blurRadius: 15,
//                     offset: const Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Image.asset(
//                     "assets/image/Rectangle 2.png",
//                     height: 180,
//                     fit: BoxFit.contain,
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     "Toyota Hilux",
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   const Text(
//                     "2.4 D-4D Invincible X",
//                     style: TextStyle(color: Colors.grey, fontSize: 16),
//                   ),
//                   const SizedBox(height: 15),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFFFD54F),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Text(
//                       "AB12 CDE",
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w900,
//                         letterSpacing: 2,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 25),
//
//             const Text(
//               "Important Dates",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 15),
//
//             _buildDateCard("MOT Status", "Valid until 15 Oct 2026", Icons.check_circle, Colors.green),
//             _buildDateCard("Tax Status", "Taxed until 01 Nov 2026", Icons.monetization_on, primaryColor),
//             _buildDateCard("Insurance", "Expires 20 Dec 2026", Icons.security, Colors.orange),
//
//             const SizedBox(height: 25),
//
//             const Text(
//               "Vehicle Specifications",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 15),
//
//             _buildSpecGrid(),
//
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDateCard(String title, String status, IconData icon, Color color) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: color, size: 28),
//           const SizedBox(width: 15),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//               Text(status, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
//             ],
//           ),
//           const Spacer(),
//           const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSpecGrid() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: GridView.count(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         crossAxisCount: 2,
//         childAspectRatio: 2.5,
//         mainAxisSpacing: 20,
//         crossAxisSpacing: 20,
//         children: [
//           _buildSpecItem("Engine", "2.4L Diesel"),
//           _buildSpecItem("Year", "2026"),
//           _buildSpecItem("Fuel Type", "Diesel"),
//           _buildSpecItem("Transmission", "Automatic"),
//           _buildSpecItem("Color", "White"),
//           _buildSpecItem("Doors", "4"),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSpecItem(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//         const SizedBox(height: 4),
//         Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//       ],
//     );
//   }
// }
