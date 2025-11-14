import 'package:equatable/equatable.dart';
import 'package:next_trip/features/hotels/infrastructure/models/hotel_model.dart';

abstract class HotelBookingEvent extends Equatable {
  const HotelBookingEvent();

  @override
  List<Object?> get props => [];
}

class CreateBookingRequested extends HotelBookingEvent {
  final HotelModel hotel;
  final String userId;
  final String guestName;
  final String guestEmail;
  final String guestPhone;
  final DateTime checkInDate;
  final DateTime checkOutDate;

  const CreateBookingRequested({
    required this.hotel,
    required this.userId,
    required this.guestName,
    required this.guestEmail,
    required this.guestPhone,
    required this.checkInDate,
    required this.checkOutDate,
  });

  @override
  List<Object?> get props => [
    hotel,
    userId,
    guestName,
    guestEmail,
    guestPhone,
    checkInDate,
    checkOutDate,
  ];
}

class GetBookingsByUserRequested extends HotelBookingEvent {
  final String userId;

  const GetBookingsByUserRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class GetUserBookingsStreamRequested extends HotelBookingEvent {
  final String userId;

  const GetUserBookingsStreamRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CancelBookingRequested extends HotelBookingEvent {
  final String id;

  const CancelBookingRequested(this.id);

  @override
  List<Object?> get props => [id];
}
