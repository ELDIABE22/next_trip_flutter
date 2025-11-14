import 'package:equatable/equatable.dart';
import 'package:next_trip/features/flights/domain/entities/flight.dart';
import 'package:next_trip/features/flights/infrastructure/models/passenger_model.dart';
import 'package:next_trip/features/flights/infrastructure/models/seat_model.dart';

abstract class FlightBookingEvent extends Equatable {
  const FlightBookingEvent();

  @override
  List<Object?> get props => [];
}

class CreateBookingRequested extends FlightBookingEvent {
  final String userId;
  final Flight flight;
  final List<SeatModel> seats;
  final List<PassengerModel> passengers;
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

class CreateRoundTripBookingRequested extends FlightBookingEvent {
  final String userId;
  final Flight outboundFlight;
  final Flight returnFlight;
  final List<SeatModel> outboundSeats;
  final List<SeatModel> returnSeats;
  final List<PassengerModel> passengers;
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

class GetUserBookingsRequested extends FlightBookingEvent {
  final String userId;

  const GetUserBookingsRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class GetUserRoundTripBookingsRequested extends FlightBookingEvent {
  final String userId;

  const GetUserRoundTripBookingsRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CancelBookingRequested extends FlightBookingEvent {
  final String bookingId;

  const CancelBookingRequested(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}
