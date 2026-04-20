import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motorbridge/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/dependency_injection/injecation.dart';
import 'core/route/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjection.bindings();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'MotorBridge',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F6F8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          surface: const Color(0xFFF5F6F8),
        ),
        textTheme: GoogleFonts.nunitoTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonColor,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}