import 'package:flutter/material.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? textColor;
  final Color? iconColor;
  final Color? bgColor;

  const Appbar({
    super.key,
    required this.title,
    this.textColor,
    this.iconColor,
    this.bgColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor ?? Colors.white,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: textColor ?? Colors.black,
        ),
      ),
      iconTheme: IconThemeData(color: iconColor ?? Colors.black),
      elevation: 0,
    );
  }
}
