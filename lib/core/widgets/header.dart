import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final double containerHeight;
  final double imageSize;
  final double top;
  final double right;
  final BoxDecoration? radial;
  final Color? textColor;

  const Header({
    super.key,
    required this.containerHeight,
    required this.imageSize,
    required this.top,
    required this.right,
    this.radial,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: containerHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Fondo
          Container(
            decoration: radial,
            width: double.infinity,
            height: containerHeight,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: radial == null ? Colors.black : null,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'NEXTTRIP',
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 7,
                ),
              ),
            ),
          ),

          // Imagen posicionada
          Positioned(
            top: top,
            right: right,
            child: Image.asset(
              textColor == null
                  ? 'assets/images/logo-app-white.webp'
                  : 'assets/images/logo-app-black.webp',
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
