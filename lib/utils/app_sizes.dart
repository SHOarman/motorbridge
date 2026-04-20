import 'package:flutter/material.dart';

/// Centralized responsive size helper.
/// Usage: final s = AppSizes(context);
/// Then use s.cardHeight, s.imageHeight, etc.
class AppSizes {
  final double screenWidth;
  final double screenHeight;

  AppSizes(BuildContext context)
      : screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height;

  // ─── Spacing ───────────────────────────────────────────────
  double get spaceXS => screenHeight * 0.008;
  double get spaceS  => screenHeight * 0.012;
  double get spaceM  => screenHeight * 0.020;
  double get spaceL  => screenHeight * 0.030;
  double get spaceXL => screenHeight * 0.050;

  // ─── Font sizes ────────────────────────────────────────────
  double get fontXS  => screenWidth * 0.028; // ~10–11px
  double get fontS   => screenWidth * 0.032; // ~12px
  double get fontM   => screenWidth * 0.038; // ~14px
  double get fontL   => screenWidth * 0.044; // ~16px
  double get fontXL  => screenWidth * 0.055; // ~20px
  double get fontXXL => screenWidth * 0.065; // ~24px

  // ─── Component heights ──────────────────────────────────────
  /// AddVehicleCard total height
  double get addVehicleCardHeight => screenHeight * 0.26;

  /// AddVehicleCard car image height
  double get addVehicleCardImageHeight => screenHeight * 0.25;

  /// Vehicle image in VehicleCard list
  double get vehicleCardImageHeight => screenHeight * 0.18;

  /// Vehicle image in VehicleDetails screen
  double get vehicleDetailImageHeight => screenHeight * 0.24;

  /// Home screen appBar height
  double get homeAppBarHeight => screenHeight * 0.30;

  // ─── Padding / margin ──────────────────────────────────────
  double get pagePadding => screenWidth * 0.05; // ~18–20px

  // ─── Border radius ─────────────────────────────────────────
  double get radiusM => 12.0;
  double get radiusL => 20.0;
  double get radiusXL => 24.0;
}
