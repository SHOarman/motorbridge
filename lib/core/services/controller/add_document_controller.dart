import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../api_sevices/api_services.dart';

class AddDocumentController extends GetxController {
  var selectedFile = Rxn<PlatformFile>();
  var fileBytes = Rxn<Uint8List>();

  final titleController = TextEditingController();
  String vehicleId = "";
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    vehicleId = Get.arguments?.toString() ?? "";
  }

  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }

  Future<void> pickFile() async {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Get.back();
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('Files / Gallery'),
                onTap: () {
                  Get.back();
                  _pickFromFilePicker();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
      if (image != null) {
        final bytes = await image.readAsBytes();
        selectedFile.value = PlatformFile(
          name: image.name,
          size: bytes.length,
          bytes: bytes,
          path: image.path,
        );
        fileBytes.value = bytes;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to capture image: $e", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> _pickFromFilePicker() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
        withData: kIsWeb,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        selectedFile.value = file;

        if (kIsWeb) {
          fileBytes.value = file.bytes;
        } else {
          if (file.path != null) {
            fileBytes.value = await File(file.path!).readAsBytes();
          } else {
            fileBytes.value = file.bytes;
          }
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick file: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  void clearFile() {
    selectedFile.value = null;
    fileBytes.value = null;
  }

  Future<void> uploadDocument() async {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      Get.snackbar("Error", "Please enter a document title",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }
    if (selectedFile.value == null || fileBytes.value == null) {
      Get.snackbar("Error", "Please select a file first",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiServices.create_documet),
      );

      request.headers.addAll({
        "Authorization": "Bearer $token",
      });

      request.fields['title'] = title;
      request.fields['vehicle'] = vehicleId;
      request.fields['vehicleId'] = vehicleId;
      request.fields['vehicle_id'] = vehicleId;
      request.fields['userId'] = (prefs.getString('userId') ?? "");

      String fileName = selectedFile.value!.name;
      String ext = fileName.split('.').last.toLowerCase();

      // Send the file under the single key 'files' expected by backend's Multer middleware
      var multipartFile = http.MultipartFile.fromBytes(
        'files',
        fileBytes.value!,
        filename: fileName,
        contentType: MediaType(ext == 'pdf' ? 'application' : 'image', ext),
      );
      request.files.add(multipartFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint("uploadDocument status: ${response.statusCode}");
      debugPrint("uploadDocument body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          var decoded = jsonDecode(response.body);
          if (decoded is Map && decoded['data'] != null) {
            final docData = decoded['data'];
            final String docId = (docData['_id'] ?? docData['id'] ?? '').toString();
            final String titleStr = (docData['title'] ?? '').toString();
            
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            if (docId.isNotEmpty && vehicleId.isNotEmpty) {
              await prefs.setString("doc_vehicle_$docId", vehicleId);
            }

            debugPrint("==================================================");
            debugPrint("🚀 DOCUMENT CREATION SUCCESS 🚀");
            debugPrint("📝 Created Document Name: $titleStr");
            debugPrint("🔑 Created Document _id: $docId");
            debugPrint("🚗 Associated Vehicle ID: $vehicleId");
            debugPrint("==================================================");
          }
        } catch (e) {
          debugPrint("Error parsing uploaded document response: $e");
        }

        if (Get.context != null) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            const SnackBar(
              content: Text("Document uploaded successfully"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        Get.back(result: true);
      } else {
        String errorMsg = "Failed to upload: ${response.statusCode}";
        try {
          var decoded = jsonDecode(response.body);
          if (decoded is Map && decoded.containsKey('message')) {
            errorMsg = decoded['message'];
          }
        } catch (_) {}

        if (Get.context != null) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text("Something went wrong: $e"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}