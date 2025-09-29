import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/custom_button.dart';

class ConfirmPassengerDataButton extends StatelessWidget {
  final int seatCount;
  final int addedPassengersCount;
  final String seatNumber;
  final List<String> passengerTypes;
  final bool hasAtLeastOneAdult;
  final bool isRoundTrip;
  final VoidCallback? onPressed;

  const ConfirmPassengerDataButton({
    super.key,
    required this.seatCount,
    required this.addedPassengersCount,
    required this.seatNumber,
    required this.passengerTypes,
    required this.hasAtLeastOneAdult,
    this.isRoundTrip = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final allPassengersAdded = addedPassengersCount >= seatCount;

    String buttonText;
    if (!allPassengersAdded) {
      buttonText = "Agregar más pasajeros ($addedPassengersCount/$seatCount)";
    } else if (!hasAtLeastOneAdult) {
      buttonText = "Se requiere al menos un adulto";
    } else {
      buttonText = isRoundTrip
          ? "Confirmar datos (Ida y Vuelta)"
          : "Confirmar datos";
    }

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
                  Colors.white.withValues(alpha: 0.9),
                ],
              ),
            ),
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Información del estado
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _getStatusColor().withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _getStatusIcon(),
                            color: _getStatusColor(),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _getStatusText(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _getStatusColor(),
                                  ),
                                ),
                                if (isRoundTrip)
                                  Text(
                                    'Reserva de ida y vuelta',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: _getStatusColor().withValues(
                                        alpha: 0.8,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (allPassengersAdded) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$addedPassengersCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Botón principal
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
      ),
    );
  }

  Color _getStatusColor() {
    if (!hasAtLeastOneAdult && addedPassengersCount > 0) return Colors.red;
    if (addedPassengersCount < seatCount) return Colors.orange;
    return Colors.green;
  }

  IconData _getStatusIcon() {
    if (!hasAtLeastOneAdult && addedPassengersCount > 0) {
      return Icons.error_outline;
    }
    if (addedPassengersCount < seatCount) return Icons.info_outline;
    return Icons.check_circle_outline;
  }

  String _getStatusText() {
    if (!hasAtLeastOneAdult && addedPassengersCount > 0) {
      return 'Debe haber al menos un adulto';
    }
    if (addedPassengersCount < seatCount) {
      return 'Faltan ${seatCount - addedPassengersCount} pasajero(s)';
    }
    return 'Todos los pasajeros agregados';
  }
}
