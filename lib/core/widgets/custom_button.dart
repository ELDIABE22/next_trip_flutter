import 'package:flutter/material.dart';
import '../constants/app_constants_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              offset: const Offset(0, 8),
              blurRadius: 30,
              spreadRadius: 0,
            ),
          ],
          borderRadius: BorderRadius.circular(25),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: Colors.grey.withValues(alpha: 0.3),
            disabledForegroundColor: Colors.grey.withValues(alpha: 0.5),
            backgroundColor: backgroundColor ?? Colors.black,
            foregroundColor: textColor ?? AppConstantsColors.textColorWhite,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            shadowColor: Colors.transparent,
            elevation: 0,
          ),
          child: Text(text, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
