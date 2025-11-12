import 'package:next_trip/features/flights/infrastructure/models/flight_model.dart';
import 'package:next_trip/features/flights/infrastructure/models/passenger_model.dart';
import 'package:next_trip/features/flights/infrastructure/models/seat_model.dart';

enum BookingStatus { pending, cancelled, completed }

enum TripType { oneWay, outbound, back }

class FlightBooking {
  final String bookingId;
  final String userId;
  final FlightModel flight;
  final int totalPrice;
  final List<PassengerModel> passengers;
  final List<SeatModel> seats;
  final BookingStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  final bool? isRoundTrip;
  final TripType? tripType;
  final String? relatedBookingId;
  final int? totalRoundTripPrice;

  FlightBooking({
    required this.bookingId,
    required this.userId,
    required this.flight,
    required this.totalPrice,
    this.status = BookingStatus.pending,
    this.passengers = const [],
    this.seats = const [],
    this.isRoundTrip,
    this.tripType,
    this.relatedBookingId,
    this.totalRoundTripPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  FlightBooking copyWith({
    String? bookingId,
    String? userId,
    FlightModel? flight,
    int? totalPrice,
    List<PassengerModel>? passengers,
    List<SeatModel>? seats,
    BookingStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isRoundTrip,
    TripType? tripType,
    String? relatedBookingId,
    int? totalRoundTripPrice,
  }) {
    return FlightBooking(
      bookingId: bookingId ?? this.bookingId,
      userId: userId ?? this.userId,
      flight: flight ?? this.flight,
      totalPrice: totalPrice ?? this.totalPrice,
      passengers: passengers ?? this.passengers,
      seats: seats ?? this.seats,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isRoundTrip: isRoundTrip ?? this.isRoundTrip,
      tripType: tripType ?? this.tripType,
      relatedBookingId: relatedBookingId ?? this.relatedBookingId,
      totalRoundTripPrice: totalRoundTripPrice ?? this.totalRoundTripPrice,
    );
  }
}
