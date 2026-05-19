import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import 'package:motorbridge/general_widget/customappbar.dart';
import 'package:motorbridge/core/services/api_sevices/api_services.dart';
import 'package:motorbridge/utils/app_text_styles.dart';

class AllReportsView extends StatefulWidget {
  const AllReportsView({super.key});

  @override
  State<AllReportsView> createState() => _AllReportsViewState();
}

class _AllReportsViewState extends State<AllReportsView> {
  List<dynamic> reports = [];
  bool isLoading = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null || token.isEmpty) {
        setState(() {
          errorMessage = "User is not logged in.";
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse("${ApiServices.baseurl}/api/report"),
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("Fetch reports status: ${response.statusCode}");
      debugPrint("Fetch reports body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          setState(() {
            reports = data['data']['items'] ?? [];
          });
        } else {
          setState(() {
            errorMessage = data['message'] ?? "Failed to load reports.";
          });
        }
      } else {
        setState(() {
          errorMessage = "Server error: ${response.statusCode}";
        });
      }
    } catch (e) {
      debugPrint("Error fetching reports: $e");
      setState(() {
        errorMessage = "Connection error. Please try again.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDateString(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "N/A";
    try {
      final parsed = DateTime.parse(dateStr);
      return "${parsed.day.toString().padLeft(2, '0')}/${parsed.month.toString().padLeft(2, '0')}/${parsed.year} at ${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: CustomAppBar(
        title: "Accident Reports",
        backgroundImage: "assets/image/Image__3_-removebg-preview.png",
        leftIcon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 20,
        ),
        onLeftTap: () => Get.back(),
      ),
      body: RefreshIndicator(
        onRefresh: fetchReports,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        errorMessage,
                        style: AppTextStyles.smallText.copyWith(
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: fetchReports,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2664A3),
                        ),
                        child: const Text(
                          "Retry",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : reports.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "No accident reports found.",
                        style: AppTextStyles.smallText.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final item = reports[index];
                  final report = (item['report'] != null && item['report'] is Map && item['report'].isNotEmpty) ? item['report'] : item;
                  final summary = item['summary'] ?? {};
                  final accidentDetails = summary['accidentDetails'] ?? report['accidentDetails'] ?? item['accidentDetails'] ?? {};

                  // Get details
                  final dateStr =
                      accidentDetails['dateTime'] ??
                      report['accidentDateTime'] ??
                      '';
                  final location =
                      accidentDetails['location'] ??
                      report['location'] ??
                      'Not specified';
                  final photosCount =
                      summary['counts']?['scenePhotos'] ??
                      (report['scenePhotos'] as List?)?.length ??
                      0;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xffCECECE),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(8),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.accidentReportDetail,
                            arguments: item,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffFFF4D0),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.warning_amber_rounded,
                                          color: Color(0xffFDC209),
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        "Report #${reports.length - index}",
                                        style: AppTextStyles.bigText.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xff2A2A2A),
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.visibility,
                                      color: Color(0xff2664A3),
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      Get.toNamed(
                                        AppRoutes.accidentReportDetail,
                                        arguments: item,
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 24,
                                color: Color(0xffEEEEEE),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined, size: 14, color: Color(0xff666666)),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          location,
                                          style: AppTextStyles.smallText.copyWith(
                                            fontSize: 13,
                                            color: const Color(0xff666666),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (photosCount > 0)
                                        Row(
                                          children: [
                                            const Icon(Icons.photo_library_outlined, size: 14, color: Color(0xff2664A3)),
                                            const SizedBox(width: 4),
                                            Text(
                                              "$photosCount Photo${photosCount > 1 ? 's' : ''}",
                                              style: AppTextStyles.smallText.copyWith(
                                                fontSize: 12,
                                                color: const Color(0xff2664A3),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        )
                                      else
                                        const SizedBox.shrink(),
                                      Text(
                                        formatDateString(dateStr),
                                        style: AppTextStyles.smallText.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xff2A2A2A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
