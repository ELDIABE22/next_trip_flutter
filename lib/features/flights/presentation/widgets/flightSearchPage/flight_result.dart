import 'package:flutter/material.dart';
import 'package:next_trip/features/flights/domain/entities/flight.dart';
import 'package:next_trip/features/flights/presentation/pages/flight_seats_page.dart';
import 'flight_card.dart';

class FlightResult extends StatelessWidget {
  final List<Flight> flights;
  final String originCity;
  final String destinationCity;
  final String title;
  final bool showSelectButton;
  final String? selectedFlightId;
  final void Function(Flight)? onFlightSelected;
  final bool isReturnTrip;

  const FlightResult({
    super.key,
    required this.flights,
    required this.originCity,
    required this.destinationCity,
    required this.title,
    this.showSelectButton = false,
    this.selectedFlightId,
    this.onFlightSelected,
    this.isReturnTrip = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        ...flights.map((flight) {
          final isSelected = flight.id == selectedFlightId;
          return FlightCard(
            flight: flight,
            isSelected: isSelected,
            showSelectButton: showSelectButton,
            onTap: () => _handleFlightTap(context, flight),
          );
        }),
      ],
    );
  }

  void _handleFlightTap(BuildContext context, Flight flight) {
    if (showSelectButton) {
      onFlightSelected?.call(flight);
    } else if (isReturnTrip) {
      onFlightSelected?.call(flight);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              FlightSeatsPage(flight: flight, isRoundTrip: false),
        ),
      );
    }
  }
}
