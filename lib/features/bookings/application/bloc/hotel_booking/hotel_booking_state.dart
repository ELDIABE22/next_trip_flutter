import 'package:equatable/equatable.dart';
import 'package:next_trip/features/bookings/infrastructure/models/hotel_booking_model.dart';

abstract class HotelBookingState extends Equatable {
  const HotelBookingState();

  @override
  List<Object?> get props => [];
}

class HotelBookingInitial extends HotelBookingState {}

class HotelBookingLoading extends HotelBookingState {}

class HotelBookingSuccess extends HotelBookingState {
  final String message;
  final HotelBookingModel? booking;

  const HotelBookingSuccess(this.message, {this.booking});

  @override
  List<Object?> get props => [message, booking];
}

class HotelBookingError extends HotelBookingState {
  final String error;

  const HotelBookingError(this.error);

  @override
  List<Object?> get props => [error];
}

class HotelBookingsLoaded extends HotelBookingState {
  final List<HotelBookingModel> bookings;

  const HotelBookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}
