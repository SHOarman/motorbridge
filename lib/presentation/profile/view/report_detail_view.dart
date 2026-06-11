import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:motorbridge/core/services/api_sevices/api_services.dart';

class ReportDetailView extends StatelessWidget {
  const ReportDetailView({super.key});

  String formatDateTime(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return "Not specified";
    try {
      DateTime parsed;
      if (dateStr.contains('/')) {
        final clean = dateStr.replaceAll(',', '').trim();
        final parts = clean.split(' ');
        final dateParts = parts[0].split('/');
        if (dateParts.length == 3) {
          int day = int.parse(dateParts[0]);
          int month = int.parse(dateParts[1]);
          int year = int.parse(dateParts[2]);
          int hour = 0;
          int minute = 0;
          if (parts.length > 1) {
            final timeParts = parts[1].split(':');
            if (timeParts.length >= 2) {
              hour = int.parse(timeParts[0]);
              minute = int.parse(timeParts[1]);
            }
          }
          parsed = DateTime(year, month, day, hour, minute);
        } else {
          parsed = DateTime.parse(dateStr);
        }
      } else {
        parsed = DateTime.parse(dateStr);
      }

      final year = parsed.year;
      final month = parsed.month.toString().padLeft(2, '0');
      final day = parsed.day.toString().padLeft(2, '0');
      final hourInt = parsed.hour;
      final isPM = hourInt >= 12;
      final displayHour = hourInt > 12 ? hourInt - 12 : (hourInt == 0 ? 12 : hourInt);
      final displayPeriod = isPM ? "PM" : "AM";
      final displayMinute = parsed.minute.toString().padLeft(2, '0');
      return "$year-$month-$day at $displayHour:$displayMinute $displayPeriod";
    } catch (_) {
      return dateStr;
    }
  }

  String formatBool(dynamic value) {
    if (value == null) return "No";
    if (value is bool) return value ? "Yes" : "No";
    if (value is String) {
      if (value.toLowerCase() == 'true' || value.toLowerCase() == 'yes') return "Yes";
      return "No";
    }
    return "No";
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(' ', ''),
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      Get.snackbar(
        "Error",
        "Could not launch phone dialer",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _viewFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Text("Failed to load image", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> item = Get.arguments ?? {};
    final Map<String, dynamic> report = (item['report'] != null && item['report'] is Map && item['report'].isNotEmpty) ? item['report'] : item;
    final Map<String, dynamic> summary = item['summary'] ?? {};
    final Map<String, dynamic> accidentDetails = summary['accidentDetails'] ?? report['accidentDetails'] ?? item['accidentDetails'] ?? {};

    // Retrieve fields dynamically from backend structure with multiple robust fallbacks
    final String dateStr = accidentDetails['dateTime'] ?? report['accidentDateTime'] ?? report['date'] ?? report['createdAt'] ?? '';
    final String location = accidentDetails['location'] ?? report['location'] ?? 'Not specified';
    final String description = accidentDetails['description'] ?? report['incidentDetails'] ?? report['description'] ?? 'Not specified';
    final String weather = accidentDetails['weatherConditions'] ?? report['weatherConditions'] ?? report['weather'] ?? 'Not specified';
    final String road = accidentDetails['roadConditions'] ?? report['roadConditions'] ?? report['road'] ?? 'Not specified';
    final String damage = accidentDetails['damageDescription'] ?? report['damageDescription'] ?? report['damage'] ?? 'Not specified';

    final String injuries = formatBool(accidentDetails['injuries'] ?? report['injuries']);
    final String police = formatBool(accidentDetails['policeAttended'] ?? report['policeAttended']);

    final List<dynamic> thirdParties = report['thirdParties'] ?? [];
    final List<dynamic> witnesses = report['witnesses'] ?? [];
    final List<dynamic> scenePhotos = report['scenePhotos'] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Premium light grey-slate background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 24),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Report Preview",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (scenePhotos.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
                  child: Text(
                    "Accident Scene Photos",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0F172A),
                    ),
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: scenePhotos.length,
                    itemBuilder: (context, idx) {
                      String path = scenePhotos[idx].toString();
                      String fullUrl;
                      if (path.startsWith('http://') || path.startsWith('https://')) {
                        fullUrl = path;
                      } else {
                        if (!path.startsWith('/')) {
                          path = '/$path';
                        }
                        fullUrl = "${ApiServices.baseurl}$path";
                      }
                      return GestureDetector(
                        onTap: () => _viewFullScreenImage(context, fullUrl),
                        child: Container(
                          width: 120,
                          margin: const EdgeInsets.only(right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xffE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(5),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              fullUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: const Color(0xffE2E8F0),
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Accident Details Card
              _buildSectionCard(
                icon: Icons.description,
                title: "Accident Details",
                children: [
                  _buildFieldRow("Date & Time", formatDateTime(dateStr)),
                  _buildFieldRow("Location", location),
                  _buildFieldRow("Description", description),
                  _buildFieldRow("Weather Conditions", weather),
                  _buildFieldRow("Road Conditions", road),
                  _buildFieldRow("Damage Description", damage),
                  _buildFieldRow("Injuries", injuries),
                  _buildFieldRow("Police Attended", police),
                ],
              ),

              // Third Party Card
              if (thirdParties.isNotEmpty)
                ...thirdParties.map((party) => _buildSectionCard(
                      icon: Icons.group,
                      title: "Third Party Information",
                      children: [
                        _buildFieldRow("Full Name", party['fullName'] ?? 'Not specified'),
                        _buildFieldRow("Phone Number", party['phoneNumber'] ?? 'Not specified'),
                        _buildFieldRow("Email Address", party['emailAddress'] ?? 'Not specified'),
                        _buildFieldRow("Registration", party['registration'] ?? 'Not specified'),
                        _buildFieldRow("Make", party['make'] ?? 'Not specified'),
                        _buildFieldRow("Model", party['model'] ?? 'Not specified'),
                        _buildFieldRow("Insurance Company", party['insuranceCompany'] ?? 'Not specified'),
                        _buildFieldRow("Policy Number", party['policyNumber'] ?? 'Not specified'),
                      ],
                      phoneToCall: party['phoneNumber'],
                    )),

              // Witnesses Card
              if (witnesses.isNotEmpty)
                ...witnesses.map((witness) => _buildSectionCard(
                      icon: Icons.visibility,
                      title: "Witness Information",
                      children: [
                        _buildFieldRow("Full Name", witness['fullName'] ?? 'Not specified'),
                        _buildFieldRow("Phone Number", witness['phoneNumber'] ?? 'Not specified'),
                        _buildFieldRow("Email Address", witness['emailAddress'] ?? 'Not specified'),
                        _buildFieldRow("Statement", witness['statement'] ?? 'Not specified'),
                      ],
                      phoneToCall: witness['phoneNumber'],
                    )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
    String? phoneToCall,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xff2563EB), size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0F172A),
                    ),
                  ),
                ),
                if (phoneToCall != null && phoneToCall.trim().isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.phone, color: Color(0xff10B981)),
                    onPressed: () => _makePhoneCall(phoneToCall),
                  ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(color: Color(0xffE2E8F0), thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xff64748B),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xff0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
