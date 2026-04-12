import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:motorbridge/core/route/app_routes.dart';

class AddDocumentController extends GetxController {
  var selectedFile = Rxn<XFile>();
  final ImagePicker _picker = ImagePicker();

  Future<void> pickFile() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedFile.value = image;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick file: $e");
    }
  }

  void clearFile() {
    selectedFile.value = null;
  }

  void uploadDocument() {
    if (selectedFile.value == null) {
      Get.snackbar("Error", "Please select a file first");
      return;
    }
    // Implement upload logic here
    Get.snackbar("Success", "Document uploaded successfully");
    
    // Navigate to homepage after success
    Future.delayed(const Duration(seconds: 1), () {
      Get.offAllNamed(AppRoutes.home);
    });
  }
}
