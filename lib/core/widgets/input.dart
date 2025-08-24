import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String labelText;
  final Icon? icon;
  final Color? labelColor;
  final Color? bgColor;

  const Input({
    super.key,
    required this.labelText,
    this.icon,
    this.labelColor,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: labelColor ?? Color(0xFF9C9C9C)),
        filled: true,
        fillColor: bgColor ?? Color(0xFFF4F4F4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none,
        ),
        suffixIcon: icon != null
            ? Icon(icon!.icon, color: labelColor, size: icon!.size)
            : null,
      ),
    );
  }
}
