import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:next_trip/features/flights/data/models/flight_model.dart';
import 'package:intl/intl.dart';

enum BookingStatus { pending, confirmed, cancelled, completed }

class FlightBooking {
  final String bookingId;
  final String userId;
  final Flight flight;
  final int totalPrice;
  final BookingStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  FlightBooking({
    required this.bookingId,
    required this.userId,
    required this.flight,
    required this.totalPrice,
    this.status = BookingStatus.confirmed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  String get totalPriceLabel {
    final formatter = NumberFormat("#,###", "es_CO");
    return '\$${formatter.format(totalPrice)} COP';
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'userId': userId,
      'flight_details': flight.toMap(),
      'totalPrice': totalPrice,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory FlightBooking.fromMap(String id, Map<String, dynamic> map) {
    return FlightBooking(
      bookingId: id,
      userId: map['userId'] as String,
      flight: Flight.fromMap(
        map['flight_details']['id'] as String,
        map['flight_details'] as Map<String, dynamic>,
      ),
      totalPrice: (map['totalPrice'] as num).toInt(),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => BookingStatus.pending,
      ),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }
}
