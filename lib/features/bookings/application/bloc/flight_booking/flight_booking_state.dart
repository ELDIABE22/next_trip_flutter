import 'package:equatable/equatable.dart';
import 'package:next_trip/features/bookings/domain/entities/flight_booking.dart';
import 'package:next_trip/features/bookings/infrastructure/models/flight_booking_model.dart';

abstract class FlightBookingState extends Equatable {
  const FlightBookingState();

  @override
  List<Object?> get props => [];
}

class FlightBookingInitial extends FlightBookingState {}

class FlightBookingLoading extends FlightBookingState {}

class FlightBookingSuccess extends FlightBookingState {
  final String message;

  const FlightBookingSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class FlightBookingError extends FlightBookingState {
  final String error;

  const FlightBookingError(this.error);

  @override
  List<Object?> get props => [error];
}

class UserBookingsLoaded extends FlightBookingState {
  final List<FlightBookingModel> bookings;

  const UserBookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class UserRoundTripBookingsLoaded extends FlightBookingState {
  final List<Map<String, FlightBooking>> bookings;

  const UserRoundTripBookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}
