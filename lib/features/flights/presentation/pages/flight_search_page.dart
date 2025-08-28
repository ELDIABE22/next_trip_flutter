import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/page_layout.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/flight_result.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/flight_search_form.dart';

class FlightSearchPage extends StatefulWidget {
  const FlightSearchPage({super.key});

  @override
  State<FlightSearchPage> createState() => _FlightSearchPageState();
}

class _FlightSearchPageState extends State<FlightSearchPage> {
  bool isOneWay = true;
  int passengers = 2;
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      titleHeader: 'VUELOS',
      title: 'Tu viaje comienza aquí: elige y reserva tu vuelo',
      selectedIndex: selectedIndex,
      onItemTapped: onItemTapped,
      children: [
        FlightSearchForm(),
        const SizedBox(height: 20),
        FlightResult(),
      ],
    );
  }
}
