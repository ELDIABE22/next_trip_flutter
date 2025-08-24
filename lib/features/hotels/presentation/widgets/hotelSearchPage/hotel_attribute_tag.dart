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
    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.all(7),
      child: Row(
        children: [
          Icon(icon, size: 24, color: textColor ?? Colors.white),
          SizedBox(width: 4),
          Text(
            title,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
