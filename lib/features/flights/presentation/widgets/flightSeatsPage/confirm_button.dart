import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/custom_button.dart';
import 'package:next_trip/features/flights/data/models/seat_model.dart';
import 'package:next_trip/features/flights/data/models/flight_model.dart';
import 'package:next_trip/features/flights/presentation/pages/flight_passenger_data_page.dart';

class ConfirmButton extends StatelessWidget {
  final List<Seat> selectedSeats;
  final Flight flight;
  final bool isRoundTrip;
  final List<Seat>? outboundSeats;
  final List<Seat>? returnSeats;
  final Flight? outboundFlight;
  final Flight? returnFlight;

  const ConfirmButton({
    super.key,
    required this.selectedSeats,
    required this.flight,
    this.isRoundTrip = false,
    this.outboundSeats,
    this.returnSeats,
    this.outboundFlight,
    this.returnFlight,
  });

  bool get _canContinue {
    if (!isRoundTrip) {
      return selectedSeats.isNotEmpty;
    } else {
      return (outboundSeats?.isNotEmpty ?? false) &&
          (returnSeats?.isNotEmpty ?? false);
    }
  }

  String get _buttonText {
    if (!isRoundTrip) {
      if (selectedSeats.isEmpty) {
        return "Selecciona tus asientos";
      }
      return "Continuar con ${selectedSeats.length} asiento${selectedSeats.length > 1 ? 's' : ''}";
    } else {
      final outboundCount = outboundSeats?.length ?? 0;
      final returnCount = returnSeats?.length ?? 0;

      if (outboundCount == 0 && returnCount == 0) {
        return "Selecciona asientos para ida y regreso";
      } else if (outboundCount == 0) {
        return "Selecciona asientos de ida";
      } else if (returnCount == 0) {
        return "Selecciona asientos de regreso";
      } else {
        return "Continuar con reserva ida y vuelta";
      }
    }
  }

  int get _totalSeats {
    if (!isRoundTrip) {
      return selectedSeats.length;
    } else {
      return (outboundSeats?.length ?? 0) + (returnSeats?.length ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Información de asientos seleccionados
                if (_canContinue || isRoundTrip) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: _canContinue
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _canContinue
                            ? Colors.green.withValues(alpha: 0.3)
                            : Colors.orange.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _canContinue
                              ? Icons.check_circle
                              : Icons.info_outline,
                          color: _canContinue ? Colors.green : Colors.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isRoundTrip) ...[
                                Text(
                                  selectedSeats.isEmpty
                                      ? 'Ningún asiento seleccionado'
                                      : 'Asientos: ${selectedSeats.map((s) => s.id).join(', ')}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: _canContinue
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                              ] else ...[
                                if ((outboundSeats?.isNotEmpty ?? false))
                                  Text(
                                    'Ida: ${outboundSeats!.map((s) => s.id).join(', ')}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green,
                                    ),
                                  ),
                                if ((returnSeats?.isNotEmpty ?? false))
                                  Text(
                                    'Regreso: ${returnSeats!.map((s) => s.id).join(', ')}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green,
                                    ),
                                  ),
                                if ((outboundSeats?.isEmpty ?? true) ||
                                    (returnSeats?.isEmpty ?? true))
                                  Text(
                                    'Completa la selección de asientos',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.orange[700],
                                    ),
                                  ),
                              ],
                            ],
                          ),
                        ),
                        if (_canContinue) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$_totalSeats',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Botón principal
                CustomButton(
                  text: _buttonText,
                  onPressed: _canContinue
                      ? () => _handleContinue(context)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleContinue(BuildContext context) {
    if (!isRoundTrip) {
      // Flujo normal para solo ida
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FlightPassengerDataPage(
            seatCount: selectedSeats.length,
            flight: flight,
            selectedSeats: selectedSeats,
            seatNumber: selectedSeats.isNotEmpty ? selectedSeats.first.id : '',
            isRoundTrip: false,
          ),
        ),
      );
    } else {
      // Flujo para ida y vuelta
      if (outboundFlight != null &&
          returnFlight != null &&
          (outboundSeats?.isNotEmpty ?? false) &&
          (returnSeats?.isNotEmpty ?? false)) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlightPassengerDataPage(
              seatCount: (outboundSeats!.length + returnSeats!.length),
              flight: outboundFlight!,
              selectedSeats: [...outboundSeats!, ...returnSeats!],
              seatNumber: outboundSeats!.first.id,
              isRoundTrip: true,
              outboundFlight: outboundFlight,
              returnFlight: returnFlight,
              outboundSeats: outboundSeats,
              returnSeats: returnSeats,
            ),
          ),
        );
      }
    }
  }
}
