import 'package:equatable/equatable.dart';
import 'package:next_trip/features/flights/domain/entities/flight.dart';

abstract class FlightEvent extends Equatable {
  const FlightEvent();

  @override
  List<Object?> get props => [];
}

class SearchFlightsRequested extends FlightEvent {
  final String originCity;
  final String destinationCity;
  final DateTime departureDate;
  final bool isRoundTrip;

  const SearchFlightsRequested({
    required this.originCity,
    required this.destinationCity,
    required this.departureDate,
    this.isRoundTrip = false,
  });

  @override
  List<Object?> get props => [
    originCity,
    destinationCity,
    departureDate,
    isRoundTrip,
  ];
}

class SearchReturnFlightsRequested extends FlightEvent {
  final String originCity;
  final String destinationCity;
  final DateTime returnDate;

  const SearchReturnFlightsRequested({
    required this.originCity,
    required this.destinationCity,
    required this.returnDate,
  });

  @override
  List<Object?> get props => [originCity, destinationCity, returnDate];
}

class SelectOutboundFlight extends FlightEvent {
  final Flight flight;

  const SelectOutboundFlight(this.flight);

  @override
  List<Object?> get props => [flight];
}

class SelectReturnFlight extends FlightEvent {
  final Flight flight;

  const SelectReturnFlight(this.flight);

  @override
  List<Object?> get props => [flight];
}

class ClearFlightsRequested extends FlightEvent {
  const ClearFlightsRequested();
}
