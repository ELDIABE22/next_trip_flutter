import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/custom_button.dart';
import 'package:next_trip/features/auth/presentation/page/login_page.dart';
import 'package:next_trip/features/auth/presentation/page/register_page.dart';
import 'package:flutter/gestures.dart';

class WelcomeActions extends StatelessWidget {
  const WelcomeActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF).withValues(alpha: -0.5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              border: const Border(
                top: BorderSide(color: Colors.white, width: 1),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              children: [
                CustomButton(
                  text: "Crear cuenta",
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                ),

                SizedBox(height: 15),

                CustomButton(
                  text: "Ya tengo una cuenta",
                  borderColor: const Color(0xFFEFECEC),
                  backgroundColor: Colors.transparent,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),

                SizedBox(height: 15),

                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "¿Continuar como ",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      TextSpan(
                        text: "invitado?",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/flights');
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
