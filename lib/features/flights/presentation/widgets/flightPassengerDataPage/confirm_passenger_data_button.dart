import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/custom_button.dart';

class ConfirmPassengerDataButton extends StatelessWidget {
  const ConfirmPassengerDataButton({super.key});

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
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: CustomButton(
                text: "Confirmar",
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Funcionalidad en desarrollo"),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
