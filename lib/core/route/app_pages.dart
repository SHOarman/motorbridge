import 'package:get/get.dart';
import 'package:motorbridge/presentation/authscreen/createaccount.dart';
import 'package:motorbridge/presentation/vehicles/view/vehicels.dart';
import '../../presentation/authscreen/forgotpassword.dart';
import '../../presentation/authscreen/resetpassword.dart';
import '../../presentation/authscreen/singin.dart';
import '../../presentation/authscreen/verificationcode.dart';
import '../../presentation/home/binding/home_binding.dart';
import '../../presentation/home/view/home_screen.dart';
import '../../presentation/splashscreen/splashscreen1.dart';
import '../../presentation/splashscreen/splashscreen2.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.splashscreen1;

  static final routes = [
    //===============================splashscreen==================================
    GetPage(name: AppRoutes.splashscreen1, page: () => const Splashscreen1()),
    GetPage(name: AppRoutes.splashscreen2, page: () => const Splashscreen2()),

    //===========================authscsrn================================================

    GetPage(name: AppRoutes.singin, page: () => const Singin()),
    GetPage(name: AppRoutes.createaccount, page: () => const Createaccount()),
    GetPage(name: AppRoutes.forgotpassword, page: () => const Forgotpassword()),
    GetPage(name: AppRoutes.resetpassword, page: () => const Resetpassword()),
    GetPage(name: AppRoutes.verificationcode, page: () => const Verificationcode()),

    //===============================home==================================
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      transitionDuration: Duration.zero,
    ),

    //=============================================vehicles===============================
    GetPage(name: AppRoutes.vehicles, page: () => const Vehicels(), transitionDuration: Duration.zero),
  ];
}
