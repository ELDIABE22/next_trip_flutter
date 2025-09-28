import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:next_trip/features/auth/data/controllers/auth_controller.dart';

class Header extends StatelessWidget {
  final double containerHeight;
  final double imageSize;
  final double top;
  final double right;
  final BoxDecoration? radial;
  final Color? textColor;
  final String title;
  final bool showUserBelowTitle;

  const Header({
    super.key,
    required this.containerHeight,
    required this.imageSize,
    required this.top,
    required this.right,
    this.radial,
    this.textColor,
    required this.title,
    this.showUserBelowTitle = false,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 7,
                    ),
                  ),
                  if (showUserBelowTitle)
                    _buildUserSection(context, textColor: textColor),
                ],
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

  Widget _buildUserSection(BuildContext context, {Color? textColor}) {
    final user = FirebaseAuth.instance.currentUser;
    final color = textColor ?? Colors.white;

    if (user != null) {
      return TextButton.icon(
        onPressed: () => AuthController().signOut(),
        icon: const Icon(Icons.logout, color: Colors.red, size: 18),
        label: const Text('Salir', style: TextStyle(color: Colors.red)),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            style: OutlinedButton.styleFrom(
              foregroundColor: color,
              side: BorderSide(color: color),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Iniciar sesión', style: TextStyle(fontSize: 14)),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Registrarse', style: TextStyle(fontSize: 14)),
          ),
        ],
      );
    }
  }
}
