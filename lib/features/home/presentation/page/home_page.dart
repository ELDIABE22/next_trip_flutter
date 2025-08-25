import 'package:flutter/material.dart';
import 'package:next_trip/features/home/presentation/widgets/welcome_actions.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Image.asset(
            "assets/images/welcome.webp",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Texto arriba a la izquierda
          Positioned(
            top: 40,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Bienvenido",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 5,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Inicia sesión o regístrate para continuar",
                  style: TextStyle(
                    color: Color(0xFFEFECEC),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Botón fijo abajo
          const WelcomeActions(),
        ],
      ),
    );
  }
}
