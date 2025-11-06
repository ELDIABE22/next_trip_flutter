import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_trip/features/flights/application/bloc/flight_bloc.dart';
import 'package:next_trip/features/flights/application/bloc/flight_event.dart';
import 'package:next_trip/features/flights/application/bloc/flight_state.dart';
import 'package:next_trip/features/flights/domain/entities/flight.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/flight_result.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/flight_search_form.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/flight_filters.dart';
import 'package:next_trip/features/flights/presentation/pages/flight_seats_page.dart';
import 'package:next_trip/core/widgets/page_layout.dart';

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
  int selectedIndex = 0;
  DateTime? _returnDate;
  String? _originCity;
  String? _destinationCity;
  bool _isRoundTrip = false;

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
    _originCity = originCity;
    _destinationCity = destinationCity;
    _returnDate = returnDate;
    _isRoundTrip = !isOneWay;

    context.read<FlightBloc>().add(
      SearchFlightsRequested(
        originCity: originCity,
        destinationCity: destinationCity,
        departureDate: departureDate,
        isRoundTrip: !isOneWay,
      ),
    );

    if (!isOneWay && returnDate != null) {
      context.read<FlightBloc>().add(
        SearchReturnFlightsRequested(
          originCity: destinationCity,
          destinationCity: originCity,
          returnDate: returnDate,
        ),
      );
    }
  }

  void _onOutboundFlightSelected() {
    if (_isRoundTrip && _returnDate != null) {
      _searchReturnFlights();
    }
  }

  void _clearResults() {
    context.read<FlightBloc>().add(ClearFlightsRequested());

    setState(() {
      _isRoundTrip = false;
    });
  }

  Future<void> _searchReturnFlights() async {
    if (_returnDate == null ||
        _originCity == null ||
        _destinationCity == null) {
      return;
    }
    context.read<FlightBloc>().add(
      SearchReturnFlightsRequested(
        originCity: _destinationCity!,
        destinationCity: _originCity!,
        returnDate: _returnDate!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlightBloc, FlightState>(
      builder: (context, state) {
        List<Flight> flights = [];
        List<Flight> returnFlights = [];
        bool isLoading = false;
        String? error;
        Flight? selectedOutbound;
        Flight? selectedReturn;

        if (state is FlightLoading) {
          isLoading = true;
        } else if (state is FlightLoaded) {
          flights = state.flights;
          returnFlights = state.returnFlights;
          selectedOutbound = state.selectedOutboundFlight;
          selectedReturn = state.selectedReturnFlight;
        } else if (state is FlightError) {
          error = state.message;
        }

        final bool hasCompleteRoundTrip =
            _isRoundTrip && selectedOutbound != null && selectedReturn != null;

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
              onTripTypeChanged: _clearResults,
            ),
            const SizedBox(height: 20),

            if (error != null)
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withAlpha(75)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

            if (isLoading && flights.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(),
                ),
              ),

            if (!isLoading && flights.isEmpty && _originCity != null)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black.withAlpha(75)),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.flight_takeoff,
                      color: Colors.black,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No se encontraron vuelos de ida',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Intenta con fechas o destinos diferentes',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

            if (flights.isNotEmpty)
              FlightFilters(
                onFiltersChanged: () => setState(() {}),
                isReturnFlight: false,
              ),

            if (flights.isNotEmpty)
              FlightResult(
                flights: flights,
                originCity: _originCity ?? widget.originCity ?? '',
                destinationCity:
                    _destinationCity ?? widget.destinationCity ?? '',
                title: _isRoundTrip ? 'Vuelos de ida' : 'Vuelos disponibles',
                showSelectButton: _isRoundTrip,
                selectedFlightId: selectedOutbound?.id,
                onFlightSelected: (flight) {
                  context.read<FlightBloc>().add(SelectOutboundFlight(flight));
                  _onOutboundFlightSelected();
                },
                isReturnTrip: false,
              ),

            if (_isRoundTrip &&
                selectedOutbound != null &&
                returnFlights.isEmpty &&
                !isLoading)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withAlpha(75)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Vuelo de ida seleccionado',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Buscando vuelos de regreso...',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            if (returnFlights.isNotEmpty)
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

            if (_isRoundTrip &&
                selectedOutbound != null &&
                returnFlights.isEmpty &&
                !isLoading &&
                _returnDate != null)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black.withAlpha(75)),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.flight_land,
                      color: Colors.black,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No se encontraron vuelos de regreso',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Intenta con una fecha diferente para el regreso',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

            if (returnFlights.isNotEmpty)
              FlightFilters(
                onFiltersChanged: () => setState(() {}),
                isReturnFlight: true,
                title: 'Filtros vuelos de regreso',
              ),

            if (returnFlights.isNotEmpty)
              FlightResult(
                flights: returnFlights,
                originCity: _destinationCity ?? widget.destinationCity ?? '',
                destinationCity: _originCity ?? widget.originCity ?? '',
                title: 'Vuelos de regreso',
                showSelectButton: false,
                selectedFlightId: selectedReturn?.id,
                onFlightSelected: (flight) {
                  context.read<FlightBloc>().add(SelectReturnFlight(flight));
                },
                isReturnTrip: true,
              ),

            if (hasCompleteRoundTrip)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withAlpha(75)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Vuelos seleccionados',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ida: ${selectedOutbound.originCity} → ${selectedOutbound.destinationCity}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Regreso: ${selectedReturn.originCity} → ${selectedReturn.destinationCity}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Total: ${(selectedOutbound.totalPriceCop + selectedReturn.totalPriceCop).toString()} COP',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FlightSeatsPage(
                                  flight: selectedOutbound!,
                                  returnFlight: selectedReturn,
                                  isRoundTrip: true,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Continuar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
