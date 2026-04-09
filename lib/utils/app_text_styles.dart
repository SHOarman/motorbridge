import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  // Nunito is a very close rounded alternative to SF Pro Rounded on Google Fonts
  static TextStyle get smallText =>
      GoogleFonts.nunito(fontSize: 14.sp, fontWeight: FontWeight.w400);

  static TextStyle get bigText =>
      GoogleFonts.nunito(fontSize: 32.sp, fontWeight: FontWeight.w700);

  // You can add more specific keys here if needed
}
