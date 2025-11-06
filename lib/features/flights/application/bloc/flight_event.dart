import 'package:equatable/equatable.dart';
import '../../domain/entities/flight.dart';
import '../../domain/entities/seat.dart';
import '../../domain/entities/passenger.dart';

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

class CreateBookingRequested extends FlightEvent {
  final String userId;
  final Flight flight;
  final List<Seat> seats;
  final List<Passenger> passengers;
  final int totalPrice;

  const CreateBookingRequested({
    required this.userId,
    required this.flight,
    required this.seats,
    required this.passengers,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [userId, flight, seats, passengers, totalPrice];
}

class CreateRoundTripBookingRequested extends FlightEvent {
  final String userId;
  final Flight outboundFlight;
  final Flight returnFlight;
  final List<Seat> outboundSeats;
  final List<Seat> returnSeats;
  final List<Passenger> passengers;
  final double totalPrice;

  const CreateRoundTripBookingRequested({
    required this.userId,
    required this.outboundFlight,
    required this.returnFlight,
    required this.outboundSeats,
    required this.returnSeats,
    required this.passengers,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [
    userId,
    outboundFlight,
    returnFlight,
    outboundSeats,
    returnSeats,
    passengers,
    totalPrice,
  ];
}

class ClearFlightsRequested extends FlightEvent {
  const ClearFlightsRequested();
}
