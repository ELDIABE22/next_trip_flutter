import 'package:flutter/material.dart';
import 'package:next_trip/features/flights/data/controllers/flight_controller.dart';
import 'package:next_trip/core/widgets/page_layout.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/flight_result.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/flight_search_form.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/flight_filters.dart';

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

  int selectedIndex = 0;

  DateTime? _returnDate;
  String? _originCity;
  String? _destinationCity;
  String? _originCountry;
  String? _destinationCountry;

  @override
  void dispose() {
    flightController.dispose();
    super.dispose();
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> _handleSearch({
    required String originCity,
    required String destinationCity,
    required DateTime departureDate,
    DateTime? returnDate,
    required bool isOneWay,
  }) async {
    setState(() {
      _originCity = originCity;
      _destinationCity = destinationCity;
      _originCountry = widget.originCountry;
      _destinationCountry = widget.destinationCountry;
      _returnDate = returnDate;
    });

    await flightController.searchFlights(
      originCity: originCity,
      destinationCity: destinationCity,
      departureDate: departureDate,
      isRoundTrip: !isOneWay,
    );

    setState(() {});
  }

  void _onOutboundFlightSelected() {
    if (flightController.isRoundTrip && _returnDate != null) {
      _searchReturnFlights();
    }
  }

  Future<void> _searchReturnFlights() async {
    if (_returnDate == null ||
        _originCity == null ||
        _destinationCity == null) {
      return;
    }

    await flightController.searchReturnFlights(
      originCity: _destinationCity!,
      destinationCity: _originCity!,
      returnDate: _returnDate!,
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

        if (flightController.flights.isNotEmpty)
          FlightFilters(
            controller: flightController,
            onFiltersChanged: () => setState(() {}),
            isReturnFlight: false,
          ),

        if (flightController.flights.isNotEmpty || flightController.loading)
          FlightResult(
            controller: flightController,
            originCity: _originCity ?? widget.originCity ?? '',
            originCountry: _originCountry ?? widget.originCountry ?? '',
            title: flightController.isRoundTrip
                ? 'Vuelos de ida'
                : 'Vuelos disponibles',
            showSelectButton: flightController.isRoundTrip,
            onFlightSelected: flightController.isRoundTrip
                ? _onOutboundFlightSelected
                : null,
            isReturnTrip: false,
          ),

        if (flightController.isRoundTrip &&
            flightController.hasOutboundFlight &&
            flightController.returnFlights.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                const Expanded(child: Divider()),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Vuelos de regreso',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
          ),

        if (flightController.isRoundTrip &&
            flightController.returnFlights.isNotEmpty)
          FlightFilters(
            controller: flightController,
            onFiltersChanged: () => setState(() {}),
            isReturnFlight: true,
            title: 'Filtros vuelos de regreso',
          ),

        if (flightController.isRoundTrip &&
            (flightController.returnFlights.isNotEmpty ||
                flightController.returnLoading))
          FlightResult(
            controller: flightController,
            originCity: _destinationCity ?? widget.destinationCity ?? '',
            originCountry:
                _destinationCountry ?? widget.destinationCountry ?? '',
            title: 'Vuelos de regreso',
            showSelectButton: false,
            isReturnTrip: true,
          ),
      ],
    );
  }
}
