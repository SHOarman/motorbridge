import 'package:get/get.dart';
import 'package:motorbridge/core/services/controller/authcontroller.dart';

import '../services/controller/profile_controller.dart';

class DependencyInjection {
  static void bindings() {
    
    Get.lazyPut(()=>AuthController());

    //======================PROFILE==================================
    Get.lazyPut(()=>ProfileController());




  }
}