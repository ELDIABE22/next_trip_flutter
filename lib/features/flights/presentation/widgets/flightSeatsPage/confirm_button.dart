import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/custom_button.dart';
import 'package:next_trip/features/flights/data/models/seat_model.dart';
import 'package:next_trip/features/flights/data/models/flight_model.dart';
import 'package:next_trip/features/flights/presentation/pages/flight_passenger_data_page.dart';

class ConfirmButton extends StatelessWidget {
  final List<Seat> selectedSeats;
  final Flight flight;

  const ConfirmButton({
    super.key,
    required this.selectedSeats,
    required this.flight,
  });

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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              text: "Continuar con la reserva",
              onPressed: selectedSeats.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FlightPassengerDataPage(
                            seatCount: selectedSeats.length,
                            flight: flight,
                            selectedSeats: selectedSeats,
                            seatNumber: selectedSeats.isNotEmpty
                                ? selectedSeats.first.id
                                : '',
                          ),
                        ),
                      );
                    },
            ),
          ],
        ),
      ),
    );
  }
}
