import 'package:flutter/material.dart';

class Responsive {
  final double screenWidth;
  final double screenHeight;
  final double ratio;

  Responsive(
      this.screenWidth, this.screenHeight, this.ratio); // Pass values directly

  static bool isMobile(double screenWidth) => screenWidth < 600;

  static bool isTablet(double screenWidth) =>
      screenWidth >= 600 && screenWidth < 900;

  static bool isDesktop(double screenWidth) => screenWidth >= 900;

  // Add more breakpoint helper methods as needed

  double hp(double percent) => screenHeight * percent / 100;

  double wp(double percent) => screenWidth * percent / 100;

  // Utility methods for sizing, spacing, etc. (optional)
  double padding(double percent) => wp(percent); // Adjust as needed for padding
  double margin(double percent) => wp(percent); // Adjust as needed for margin
  double textSize(double baseSize, BuildContext context) {
    // Pass context here
    if (isMobile(screenWidth)) {
      return baseSize * 0.8; // Adjust for mobile scaling
    } else if (isTablet(screenWidth)) {
      return baseSize; // Adjust for tablet scaling
    } else {
      return baseSize * 1.2; // Adjust for desktop scaling
    }
  }
}
