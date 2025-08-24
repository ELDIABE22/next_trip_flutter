import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/custom_button.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/flight_card.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Selecciona tu asiento",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
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

            Positioned(
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
            ),
          ],
        ),
      ),
    );
  }
}
