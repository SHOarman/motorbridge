import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'accident_report_tab.dart';
import '../../../utils/app_text_styles.dart';

class PhotosVideosView extends StatelessWidget {
  const PhotosVideosView({super.key});

  @override
  Widget build(BuildContext context) {
    final AccidentReportTabController controller =
        Get.find<AccidentReportTabController>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Accident Scene Photos",
                  style: AppTextStyles.bigText.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff0A0A0A),
                  ),
                ),
                const SizedBox(height: 20),

                // Helper Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF), // Light Blue
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFDBEAFE),width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "What to Photograph:",
                        style: AppTextStyles.internt.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildBulletItem("Damage to all vehicles involved"),
                      _buildBulletItem("Overall view of the accident scene"),
                      _buildBulletItem("Road signs, markings, and conditions"),
                      _buildBulletItem("Skid marks or debris"),
                      _buildBulletItem("License plates of other vehicles"),
                      _buildBulletItem(
                          "Position of vehicles after the accident"),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Take Photos Button
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => controller.pickImages(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.camera_alt_outlined,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              "Take Photos",
                              style: AppTextStyles.smallText.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Take photos of the accident scene to\ninclude in your report",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.internt.copyWith(
                          fontSize: 14,
                          color: const Color(0xff4A5565),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // Preview Box
                Obx(() {
                  if (controller.accidentPhotos.isEmpty) return const SizedBox();
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle,
                              color: Color(0xFF00C950), size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "${controller.accidentPhotos.length} Photos Taken",
                            style: AppTextStyles.smallText.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF00C950),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 30),
          // Navigation Buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () => controller.previousTab(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      foregroundColor: const Color(0xFF1E293B),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_back, size: 20),
                        const SizedBox(width: 10),
                        Text("Previous",
                            style: AppTextStyles.smallText
                                .copyWith(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: Obx(() {
                    bool isValid = controller.accidentPhotos.isNotEmpty;
                    return ElevatedButton(
                      onPressed: isValid ? () => controller.nextTab() : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            const Color(0xFF2563EB).withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Next",
                              style: AppTextStyles.smallText.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          const SizedBox(width: 10),
                          const Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.internt.copyWith(
                fontSize: 14,
                color: const Color(0xff0A0A0A),
                fontWeight: FontWeight.w400
              ),
            ),
          ),
        ],
      ),
    );
  }
}
