import 'package:flutter/material.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/flight_card.dart';

class FlightResult extends StatelessWidget {
  const FlightResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ida',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.flight, size: 28, color: Colors.black),
            const SizedBox(width: 10),
            Text(
              'Bogotá a Barranquilla',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        Column(
          children: List.generate(5, (index) => FlightCard(total: "278.550")),
        ),
      ],
    );
  }
}
