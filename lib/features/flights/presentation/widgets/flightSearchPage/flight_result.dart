import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:next_trip/features/flights/data/controllers/flight_controller.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/flight_card.dart';
import 'package:next_trip/features/flights/presentation/pages/flight_seats_page.dart';

class FlightResult extends StatefulWidget {
  const FlightResult({super.key});

  @override
  State<FlightResult> createState() => _FlightResultState();
}

class _FlightResultState extends State<FlightResult> {
  late final FlightController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlightController();
    _controller.searchFlights();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        if (_controller.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_controller.error != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              _controller.error!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final flights = _controller.flights;

        if (flights.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('No se encontraron vuelos.'),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
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
                  '${flights.first.originCity} a ${flights.first.destinationCity}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Column(
              children: flights.map((f) {
                final dateStr = DateFormat(
                  'dd/MM/yyyy',
                ).format(f.departureDateTime);
                return FlightCard(
                  total: f.totalPriceLabelCop,
                  flightDate: dateStr,
                  departureTime: f.departureTimeStr,
                  arrivalTime: f.arrivalTimeStr,
                  originIata: f.originIata,
                  destinationIata: f.destinationIata,
                  durationLabel: f.durationLabel,
                  isDirect: f.isDirect,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlightSeatsPage(flight: f),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
