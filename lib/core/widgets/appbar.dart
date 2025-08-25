import 'package:flutter/material.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color? textColor;
  final Color? iconColor;
  final Color? bgColor;
  final bool isTransparent;

  const Appbar({
    super.key,
    this.title,
    this.textColor,
    this.iconColor,
    this.bgColor,
    this.isTransparent = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: isTransparent
          ? Colors.transparent
          : bgColor ?? Colors.white,
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: textColor ?? Colors.black,
              ),
            )
          : null,
      iconTheme: IconThemeData(color: iconColor ?? Colors.black),
      elevation: isTransparent ? 0 : 4,
      flexibleSpace: isTransparent ? const SizedBox.shrink() : null,
    );
  }
}
