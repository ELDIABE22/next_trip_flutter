import 'package:flutter/material.dart';
import 'package:next_trip/features/home/presentation/widgets/welcome_actions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/welcome.webp",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          Positioned(
            top: 40,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  FirebaseAuth.instance.currentUser != null
                      ? "¡Bienvenido de nuevo!"
                      : "Bienvenido",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: FirebaseAuth.instance.currentUser != null
                        ? 22
                        : 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 5,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  FirebaseAuth.instance.currentUser != null
                      ? "Continúa tu viaje: busca vuelos, hoteles y carros"
                      : "Inicia sesión o regístrate para continuar",
                  style: TextStyle(
                    color: Color(0xFFEFECEC),
                    fontSize: FirebaseAuth.instance.currentUser != null
                        ? 12
                        : 15,
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
