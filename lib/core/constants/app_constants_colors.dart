import 'package:flutter/material.dart';

class AppConstantsColors {
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF1E293B);

  static const Color textColorWhite = Color(0xFFFFFFFF);
  static const Color textColor1 = Color(0xFF888888);
  static const Color textColor2 = Color(0xFFE9E9E9);

  static const Color buttonColor1 = Color(0xFF37BF37);
  static const Color buttonColor2 = Color(0xFFE9E9E9);

  static const BoxDecoration radialBackground = BoxDecoration(
    gradient: RadialGradient(
      center: Alignment(0.0, -0.9),
      radius: 1.8,
      colors: [
        AppConstantsColors.backgroundLight,
        Colors.black,
      ], // blanco abajo
      stops: [0.3, 1],
    ),
  );
}
