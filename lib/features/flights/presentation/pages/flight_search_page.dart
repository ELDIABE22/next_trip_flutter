import 'package:flutter/material.dart';
import 'package:next_trip/features/flights/data/controllers/flight_controller.dart';
import 'package:next_trip/core/widgets/page_layout.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/flight_result.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/flight_search_form.dart';

class FlightSearchPage extends StatefulWidget {
  final String? originCountry;
  final String? originCity;
  final String? destinationCountry;
  final String? destinationCity;
  final DateTime? date;

  const FlightSearchPage({
    super.key,
    this.originCountry,
    this.originCity,
    this.destinationCountry,
    this.destinationCity,
    this.date,
  });

  @override
  State<FlightSearchPage> createState() => _FlightSearchPageState();
}

class _FlightSearchPageState extends State<FlightSearchPage> {
  final FlightController flightController = FlightController();

  bool isOneWay = true;
  int passengers = 2;
  int selectedIndex = 0;

  bool _isSearching = false;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> _handleSearch({
    required String originCity,
    required String destinationCity,
    required DateTime departureDate,
  }) async {
    setState(() {
      _isSearching = true;
    });

    await flightController.searchFlights(
      originCity: originCity,
      destinationCity: destinationCity,
      departureDate: departureDate,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      titleHeader: 'VUELOS',
      title: 'Tu viaje comienza aquí: elige y reserva tu vuelo',
      selectedIndex: selectedIndex,
      onItemTapped: onItemTapped,
      children: [
        FlightSearchForm(
          originCountry: widget.originCountry,
          originCity: widget.originCity,
          destinationCountry: widget.destinationCountry,
          destinationCity: widget.destinationCity,
          onSearch: _handleSearch,
        ),
        const SizedBox(height: 20),
        if (_isSearching)
          FlightResult(
            controller: flightController,
            originCountry: widget.originCountry!,
            originCity: widget.originCity!,
          ),
      ],
    );
  }
}
