import 'package:get/get.dart';
import 'package:motorbridge/core/services/controller/add_vehicle_controller.dart';
import 'package:motorbridge/core/services/controller/authcontroller.dart';
import 'package:motorbridge/core/services/controller/home_controller.dart';

import '../services/controller/profile_controller.dart';

class DependencyInjection {
  static void bindings() {
    
    Get.lazyPut(()=>AuthController(), fenix: true);

    //======================PROFILE==================================
    Get.lazyPut(()=>ProfileController(), fenix: true);

    //============================add_vehicle===================================
    Get.lazyPut(()=>AddVehicleController(),fenix: true);

    //============================home_controller===============================
    Get.lazyPut(()=>HomeController(), fenix: true);
  }
}