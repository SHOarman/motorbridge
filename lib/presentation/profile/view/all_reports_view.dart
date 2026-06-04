import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import 'package:motorbridge/general_widget/customappbar.dart';
import 'package:motorbridge/core/services/api_sevices/api_services.dart';
import 'package:motorbridge/utils/app_text_styles.dart';
import 'package:motorbridge/utils/pdf_generator.dart';

import '../../home/view/accident_report_tab.dart';

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

  Future<void> deleteReport(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.delete(
        Uri.parse("${ApiServices.baseurl}/api/report/$id"),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Report deleted successfully", backgroundColor: Colors.green, colorText: Colors.white);
        fetchReports();
      } else {
        Get.snackbar("Error", "Failed to delete report");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }
  }

  void _showDeleteConfirmation(String id) {
    Get.dialog(
      AlertDialog(
        title: const Text("Delete Report"),
        content: const Text("Are you sure you want to delete this report?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Get.back();
              deleteReport(id);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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
                                  Expanded(
                                    child: Row(
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
                                        Expanded(
                                          child: Text(
                                            "Report #${reports.length - index}",
                                            style: AppTextStyles.bigText.copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xff2A2A2A),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: const Icon(
                                              Icons.visibility,
                                              color: Color(0xff2664A3),
                                              size: 22,
                                            ),
                                            onPressed: () {
                                              Get.toNamed(
                                                AppRoutes.accidentReportDetail,
                                                arguments: item,
                                              );
                                            },
                                          ),
                                          const SizedBox(width: 12),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.orange,
                                              size: 22,
                                            ),
                                            onPressed: () {
                                              Get.delete<AccidentReportTabController>();
                                              Get.toNamed(
                                                AppRoutes.accidentReport,
                                                arguments: item,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: const Icon(
                                              Icons.picture_as_pdf_outlined,
                                              color: Colors.redAccent,
                                              size: 22,
                                            ),
                                            onPressed: () {
                                              PdfGenerator.generateAndShareAccidentReport(item);
                                            },
                                          ),
                                          const SizedBox(width: 12),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.red,
                                              size: 22,
                                            ),
                                            onPressed: () {
                                              final String reportId = (item['report'] != null ? item['report']['_id'] ?? item['report']['id'] : item['_id'] ?? item['id'])?.toString() ?? '';
                                              if (reportId.isNotEmpty) {
                                                _showDeleteConfirmation(reportId);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
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
