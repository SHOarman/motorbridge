import 'package:get/get.dart';
import 'package:motorbridge/presentation/authscreen/createaccount.dart';
import 'package:motorbridge/presentation/profile/view/editprofile.dart';
import 'package:motorbridge/presentation/vehicles/view/add_document.dart';
import 'package:motorbridge/presentation/vehicles/view/vehicles.dart';
import 'package:motorbridge/presentation/vehicles/view/vehicle_details.dart';
import '../../presentation/add_vehicles/view/addvehicles.dart';
import '../../presentation/authscreen/forgotpassword.dart';
import '../../presentation/authscreen/resetpassword.dart';
import '../../presentation/authscreen/singin.dart';
import '../../presentation/authscreen/verificationcode.dart';
import '../../presentation/home/view/home_screen.dart';
import '../../presentation/home/view/motoring_emergencies.dart';
import '../../presentation/profile/view/profile.dart';
import '../../presentation/home/view/helpandtutorial.dart';
import '../../presentation/reminders/view/reminders.dart';
import '../../presentation/splashscreen/splashscreen1.dart';
import '../../presentation/splashscreen/splashscreen2.dart';
import '../../presentation/home/view/accident_report_tab.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.splashscreen1;

  static final routes = [
    // GetPage(name: AppRoutes.home, page: ()=> const HomeScreen(), transitionDuration: Duration.zero),

    //===============================splashscreen==================================
    GetPage(name: AppRoutes.splashscreen1, page: () => const Splashscreen1()),
    GetPage(name: AppRoutes.splashscreen2, page: () => const Splashscreen2()),
    
    GetPage(name: AppRoutes.accidentReport, page: () => const AccidentReportTab()),

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
      transition: Transition.noTransition,
      transitionDuration: Duration.zero,
    ),
    GetPage(name: AppRoutes.motoringemergencies, page: () => const MotoringEmergencies(), transitionDuration: Duration.zero),
    GetPage(name: "/HelpAndTutorialView", page: () => const HelpAndTutorialView(), transitionDuration: Duration.zero),


    //=============================================vehicles===============================
    GetPage(name: AppRoutes.vehicles, page: () => const Vehicles(), transitionDuration: Duration.zero),
    GetPage(name: AppRoutes.addvehicles, page: ()=> const AddVehiclesScreen(), transitionDuration: Duration.zero),
    GetPage(name: AppRoutes.reminders, page: ()=> const Reminders(), transitionDuration: Duration.zero),
     GetPage(name: AppRoutes.vehicledetails, page: ()=> const VehicleDetails(), transitionDuration: Duration.zero),

    GetPage(name: AppRoutes.addDocuments, page: ()=> const AddDocument(), transitionDuration: Duration.zero),


    //=======================================profile======================================================
    GetPage(name: AppRoutes.profile, page: ()=> const Profile(), transitionDuration: Duration.zero),
    GetPage(name: AppRoutes.editprofile, page: ()=> const EditProfile(), transitionDuration: Duration.zero),
  ];
}
