import 'package:flutter/material.dart';

import '../../../utils/app_text_styles.dart';

class RunningCostsCard extends StatelessWidget {
  final String iconPath;
  final String trendIconPath;
  final String repairIconPath;
  final String arrowIconPath;
  final VoidCallback onPressed;

  const RunningCostsCard({
    super.key,
    required this.iconPath,
    required this.trendIconPath,
    required this.repairIconPath,
    required this.arrowIconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xffE6F9F3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(iconPath, height: 24, width: 24),
              ),
              const SizedBox(width: 15),
              Text(
                "Running Costs",
                style: AppTextStyles.bigText.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff101828),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xffF0FFF4),
              border: Border.all(
                color: const Color(0xff27AE60).withValues(alpha: 0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xff27AE60),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    trendIconPath,
                    height: 24,
                    width: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      "Total Spent",
                      style: AppTextStyles.smallText.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff006045),

                      )
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "£2050.00",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff1A1A1A),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Text(
                  "1 entries",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff27AE60),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Top Expenses",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff1A1A1A),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xffFFF1F0),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Image.asset(repairIconPath, height: 20, width: 20),
                    const SizedBox(width: 10),
                    const Text(
                      "Repairs",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff1A1A1A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      "£2050.00",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffE74C3C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  "100%",
                  style: TextStyle(fontSize: 14, color: Color(0xff888888)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff1E68F5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "View All Expenses & Add New",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    arrowIconPath,
                    height: 16,
                    width: 16,
                    color: Colors.white,
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
