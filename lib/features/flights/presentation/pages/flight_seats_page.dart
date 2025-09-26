import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/features/flights/data/models/seat_model.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/flight_card.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSeatsPage/confirm_button.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSeatsPage/seat_grid.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSeatsPage/seat_legends.dart';
import 'package:next_trip/features/flights/data/models/flight_model.dart';
import 'package:intl/intl.dart';

class FlightSeatsPage extends StatefulWidget {
  final Flight flight;

  const FlightSeatsPage({super.key, required this.flight});

  @override
  State<FlightSeatsPage> createState() => _FlightSeatsPageState();
}

class _FlightSeatsPageState extends State<FlightSeatsPage> {
  List<Seat> selectedSeats = [];

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
                    total: widget.flight.totalPriceLabelCop,
                    flightDate: DateFormat(
                      'dd/MM/yyyy',
                    ).format(widget.flight.departureDateTime),
                    departureTime: widget.flight.departureTimeStr,
                    arrivalTime: widget.flight.arrivalTimeStr,
                    originIata: widget.flight.originIata,
                    destinationIata: widget.flight.destinationIata,
                    durationLabel: widget.flight.durationLabel,
                    isDirect: widget.flight.isDirect,
                    navigateToSeatsOnTap: false,
                  ),
                  const SizedBox(height: 10),
                  SeatLegends(),
                  const SizedBox(height: 20),
                  SeatGrid(
                    flightId: widget.flight.id,
                    onSelectionChanged: (seats) {
                      setState(() {
                        selectedSeats = seats;
                      });
                    },
                  ),
                  const SizedBox(height: 90),
                ],
              ),
            ),

            ConfirmButton(
              selectedSeats: selectedSeats,
              flight: widget.flight,
            ),
          ],
        ),
      ),
    );
  }
}
