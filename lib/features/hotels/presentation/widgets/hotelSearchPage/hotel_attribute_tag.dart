import 'package:flutter/material.dart';

class HotelAttributeTag extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? textColor;
  final Color? bgColor;

  const HotelAttributeTag({
    super.key,
    required this.title,
    required this.icon,
    this.textColor,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: bgColor ?? Colors.black,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: textColor ?? Colors.white),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: textColor ?? const Color(0xFFFFFFFF),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
