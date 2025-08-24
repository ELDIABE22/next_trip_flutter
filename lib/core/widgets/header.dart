import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 120,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Fondo
          Container(
            width: double.infinity,
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: Colors.black,
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'NEXTTRIP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 7,
                ),
              ),
            ),
          ),

          // Imagen posicionada
          Positioned(
            top: -50,
            right: -30,
            child: Image.asset(
              'assets/images/logo-app-white.webp',
              width: 150,
              height: 150,
            ),
          ),
        ],
      ),
    );
  }
}
