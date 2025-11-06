import 'package:equatable/equatable.dart';
import '../../domain/entities/flight.dart';

abstract class FlightState extends Equatable {
  const FlightState();

  @override
  List<Object?> get props => [];
}

class FlightInitial extends FlightState {}

class FlightLoading extends FlightState {}

class FlightLoaded extends FlightState {
  final List<Flight> flights;
  final List<Flight> returnFlights;
  final Flight? selectedOutboundFlight;
  final Flight? selectedReturnFlight;

  const FlightLoaded({
    required this.flights,
    this.returnFlights = const [],
    this.selectedOutboundFlight,
    this.selectedReturnFlight,
  });

  @override
  List<Object?> get props => [
    flights,
    returnFlights,
    selectedOutboundFlight ?? '',
    selectedReturnFlight ?? '',
  ];
}

class FlightBookingSuccess extends FlightState {}

class FlightError extends FlightState {
  final String message;

  const FlightError(this.message);

  @override
  List<Object?> get props => [message];
}
