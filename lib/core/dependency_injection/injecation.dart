import 'package:get/get.dart';
import 'package:motorbridge/core/services/controller/authcontroller.dart';

class DependencyInjection {
  static void bindings() {
    
    Get.lazyPut(()=>Authcontroller());




  }
}