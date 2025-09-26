import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/custom_button.dart';

class ConfirmPassengerDataButton extends StatelessWidget {
  final int seatCount;
  final int addedPassengersCount;
  final String seatNumber;
  final List<String> passengerTypes;
  final bool hasAtLeastOneAdult;
  final VoidCallback? onPressed;

  const ConfirmPassengerDataButton({
    super.key,
    required this.seatCount,
    required this.addedPassengersCount,
    required this.seatNumber,
    required this.passengerTypes,
    required this.hasAtLeastOneAdult,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final allPassengersAdded = addedPassengersCount >= seatCount;
    final buttonText = allPassengersAdded
        ? "Confirmar"
        : "Agregar más pasajeros";

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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  if (!hasAtLeastOneAdult && addedPassengersCount > 0)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Debe haber al menos un adulto',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Opacity(
                    opacity: (allPassengersAdded && hasAtLeastOneAdult)
                        ? 1.0
                        : 0.6,
                    child: IgnorePointer(
                      ignoring: !allPassengersAdded || !hasAtLeastOneAdult,
                      child: CustomButton(
                        text: buttonText,
                        onPressed: onPressed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
