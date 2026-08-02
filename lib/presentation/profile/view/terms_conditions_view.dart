import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/services/controller/terms_controller.dart';
import 'package:motorbridge/general_widget/customappbar.dart';
import 'package:motorbridge/utils/app_text_styles.dart';

class TermsConditionsView extends StatelessWidget {
  const TermsConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final TermsController controller = Get.put(TermsController());

    return Scaffold(
      appBar: CustomAppBar(
        title: "Terms & Conditions",
        leftIcon: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0x33FFFFFF),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        ),
        onLeftTap: () => Get.back(),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.fetchTerms(),
          color: const Color(0xFF004AAD),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF004AAD),
                ),
              );
            }

            if (controller.errorMessage.value != null) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 54, color: Colors.redAccent),
                      const SizedBox(height: 16),
                      Text(
                        controller.errorMessage.value!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bigText.copyWith(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => controller.fetchTerms(),
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        label: const Text("Retry"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004AAD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }

            if (controller.terms.isEmpty) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  alignment: Alignment.center,
                  child: Text(
                    "No Terms & Conditions available.",
                    style: AppTextStyles.bigText.copyWith(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16.0),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                if (controller.lastUpdatedFormatted.value != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0x14004AAD),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0x33004AAD),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: Color(0xFF004AAD),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Last Updated: ${controller.lastUpdatedFormatted.value}",
                          style: AppTextStyles.bigText.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF004AAD),
                          ),
                        ),
                      ],
                    ),
                  ),
                ...controller.terms.map((item) {
                  final sectionTitle = (item['sectionTitle'] ?? '').toString().trim();
                  final title = (item['title'] ?? '').toString().trim();
                  final content = (item['content'] ?? '').toString().trim();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: const Color.fromRGBO(182, 192, 209, 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (sectionTitle.isNotEmpty) ...[
                          Text(
                            sectionTitle,
                            style: AppTextStyles.bigText.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF004AAD),
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                        if (title.isNotEmpty) ...[
                          Text(
                            title,
                            style: AppTextStyles.bigText.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (content.isNotEmpty)
                          Text(
                            content,
                            style: AppTextStyles.bigText.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF475569),
                              height: 1.5,
                            ),
                          ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 30),
              ],
            );
          }),
        ),
      ),
    );
  }
}
