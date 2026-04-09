import 'package:get/get.dart';

class Authcontroller extends GetxController {
  var isAgreed = false.obs;

  void toggleAgreement() {
    isAgreed.value = !isAgreed.value;
  }
}