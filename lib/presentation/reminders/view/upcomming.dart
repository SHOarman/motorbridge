import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:motorbridge/core/services/controller/home_controller.dart';
import 'package:motorbridge/presentation/reminders/widget/custom_text.dart';

class UpcomingData extends StatelessWidget {
  const UpcomingData({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final allReminders = controller.getReminders();
        final upcomingReminders = allReminders
            .where((r) =>
                r['status'] == 'upcoming' ||
                r['status'] == 'due_soon' ||
                r['status'] == 'due soon')
            .toList();

        if (upcomingReminders.isEmpty) {
          return const Center(
            child: Text(
              "No upcoming reminders",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                ...upcomingReminders.map((reminder) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CustomReminderCard(
                      title: reminder['title'],
                      date: reminder['date'],
                      expiryStatus: reminder['expiryStatus'],
                      vehicleName: reminder['vehicleName'],
                      vehicleTag: reminder['vehicleTag'],
                      buttonText: reminder['buttonText'],
                      iconPath: reminder['iconPath'],
                      buttonIconPath: reminder['buttonIconPath'],
                      backgroundColor: reminder['backgroundColor'],
                      borderColor: reminder['borderColor'],
                      titleColor: reminder['titleColor'],
                      dateColor: reminder['dateColor'],
                      expiryTextColor: reminder['expiryTextColor'],
                      buttonColor: const Color(0xFF1B4E9F),
                      badgeBackgroundColor: reminder['badgeBackgroundColor'],
                      badgeTextColor: reminder['badgeTextColor'],
                      onButtonPressed: () async {
                        final urlStr = reminder['url']?.toString() ?? '';
                        if (urlStr.isNotEmpty) {
                          try {
                            final uri = Uri.parse(urlStr);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            }
                          } catch (e) {
                            debugPrint("Error launching url: $e");
                          }
                        }
                      },
                    ),
                  );
                }),
                const SizedBox(height: 120),
              ],
            ),
          ),
        );
      }),
    );
  }
}
