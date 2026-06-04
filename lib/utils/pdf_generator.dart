import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:motorbridge/core/services/api_sevices/api_services.dart';

class PdfGenerator {
  static Future<void> generateAndShareAccidentReport(Map<String, dynamic> item) async {
    final report = (item['report'] != null && item['report'] is Map && item['report'].isNotEmpty) ? item['report'] : item;
    final summary = item['summary'] ?? {};
    final accidentDetails = summary['accidentDetails'] ?? report['accidentDetails'] ?? item['accidentDetails'] ?? {};
    
    final String dateStr = accidentDetails['dateTime'] ?? report['accidentDateTime'] ?? report['date'] ?? report['createdAt'] ?? 'Not specified';
    final String location = accidentDetails['location'] ?? report['location'] ?? 'Not specified';
    final String incidentDetails = accidentDetails['description'] ?? report['incidentDetails'] ?? report['description'] ?? 'Not specified';
    final String weatherConditions = accidentDetails['weatherConditions'] ?? report['weatherConditions'] ?? report['weather'] ?? 'Not specified';
    final String roadConditions = accidentDetails['roadConditions'] ?? report['roadConditions'] ?? report['road'] ?? 'Not specified';
    final String damageDescription = accidentDetails['damageDescription'] ?? report['damageDescription'] ?? report['damage'] ?? 'Not specified';
    
    final List<dynamic> thirdParties = (report['thirdParties'] is List) ? report['thirdParties'] : [];
    final List<dynamic> witnesses = (report['witnesses'] is List) ? report['witnesses'] : [];
    
    final List<dynamic> scenePhotos = [];
    final scenePhotosData = report['scenePhotos'];
    if (scenePhotosData is List) {
      scenePhotos.addAll(scenePhotosData);
    } else if (scenePhotosData is String && scenePhotosData.isNotEmpty) {
      scenePhotos.add(scenePhotosData);
    }

    final pdf = pw.Document();

    List<pw.ImageProvider> imageProviders = [];
    for (var photoUrl in scenePhotos) {
      if (photoUrl != null && photoUrl.toString().isNotEmpty) {
         try {
           final fullUrl = ApiServices.getFirstImageUrl(photoUrl);
           if (fullUrl.isNotEmpty) {
             final image = await networkImage(fullUrl);
             imageProviders.add(image);
           }
         } catch (e) {
           // ignore
         }
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Text('Accident Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
            pw.Divider(color: PdfColors.blue900, thickness: 2),
            pw.SizedBox(height: 20),
            
            _buildSectionTitle('Accident Details'),
            _buildDetailRow('Date & Time', dateStr),
            _buildDetailRow('Location', location),
            _buildDetailRow('Weather', weatherConditions),
            _buildDetailRow('Road Condition', roadConditions),
            _buildDetailRow('Damage', damageDescription),
            
            pw.SizedBox(height: 10),
            pw.Text('Incident Description:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(incidentDetails),
            pw.SizedBox(height: 20),
            
            _buildSectionTitle('Other Information'),
            _buildDetailRow('Injuries', (report['injuries'] == true || report['injuries'] == 'true' || report['injuries'] == 'Yes') ? 'Yes' : 'No'),
            _buildDetailRow('Police Attended', (report['policeAttended'] == true || report['policeAttended'] == 'true' || report['policeAttended'] == 'Yes') ? 'Yes' : 'No'),
            pw.SizedBox(height: 20),
            
            _buildSectionTitle('Third Party Information'),
            if (thirdParties.isNotEmpty)
              ...thirdParties.map((tp) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 10),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Name', (tp['fullName'] ?? 'N/A').toString()),
                    _buildDetailRow('Phone', (tp['phoneNumber'] ?? 'N/A').toString()),
                    _buildDetailRow('Email', (tp['emailAddress'] ?? 'N/A').toString()),
                    _buildDetailRow('Registration', (tp['registration'] ?? 'N/A').toString()),
                    _buildDetailRow('Make', (tp['make'] ?? 'N/A').toString()),
                    _buildDetailRow('Model', (tp['model'] ?? 'N/A').toString()),
                    _buildDetailRow('Insurance', (tp['insuranceCompany'] ?? 'N/A').toString()),
                    _buildDetailRow('Policy', (tp['policyNumber'] ?? 'N/A').toString()),
                  ],
                ),
              )).toList()
            else
              pw.Text('No third party information provided.', style: const pw.TextStyle(color: PdfColors.grey700)),
            pw.SizedBox(height: 20),
            
            _buildSectionTitle('Witness Information'),
            if (witnesses.isNotEmpty)
              ...witnesses.map((wt) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 10),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Name', (wt['fullName'] ?? 'N/A').toString()),
                    _buildDetailRow('Phone', (wt['phoneNumber'] ?? 'N/A').toString()),
                    _buildDetailRow('Email', (wt['emailAddress'] ?? 'N/A').toString()),
                    _buildDetailRow('Statement', (wt['statement'] ?? 'N/A').toString()),
                  ],
                ),
              )).toList()
            else
              pw.Text('No witness information provided.', style: const pw.TextStyle(color: PdfColors.grey700)),
            pw.SizedBox(height: 20),
            
            _buildSectionTitle('Scene Photos'),
            if (imageProviders.isNotEmpty)
              pw.Wrap(
                spacing: 10,
                runSpacing: 10,
                children: imageProviders.map((img) => pw.Container(
                  width: 150,
                  height: 150,
                  child: pw.Image(img, fit: pw.BoxFit.cover),
                )).toList(),
              )
            else
              pw.Text('No scene photos provided.', style: const pw.TextStyle(color: PdfColors.grey700)),
          ];
        },
      ),
    );

    try {
      final bytes = await pdf.save();
      await Printing.sharePdf(bytes: bytes, filename: 'accident_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    } catch (e) {

      Get.snackbar("Error", "Failed to generate PDF: $e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  static pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10, top: 10),
      child: pw.Text(title, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800)),
    );
  }

  static pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 120,
            child: pw.Text('$label:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.grey800)),
          ),
          pw.Expanded(
            child: pw.Text(value, style: const pw.TextStyle(color: PdfColors.black)),
          ),
        ],
      ),
    );
  }
}
