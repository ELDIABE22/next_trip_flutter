import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/flight_card.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSeatsPage/confirm_button.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSeatsPage/seat_grid.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSeatsPage/seat_legends.dart';

class FlightSeatsPage extends StatefulWidget {
  const FlightSeatsPage({super.key});

  @override
  State<FlightSeatsPage> createState() => _FlightSeatsPageState();
}

class _FlightSeatsPageState extends State<FlightSeatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(title: "Selecciona tu asiento"),
      body: Container(
        decoration: AppConstantsColors.radialBackground,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  FlightCard(
                    total: "557.100",
                    passengersText: '2 Pasajeros',
                    flightDate: '01/09/2025',
                  ),
                  const SizedBox(height: 10),
                  SeatLegends(),
                  const SizedBox(height: 20),
                  SeatGrid(),
                  const SizedBox(height: 90),
                ],
              ),
            ),

            ConfirmButton(),
          ],
        ),
      ),
    );
  }
}
