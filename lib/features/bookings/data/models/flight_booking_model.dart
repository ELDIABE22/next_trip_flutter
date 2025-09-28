import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:next_trip/features/flights/data/models/flight_model.dart';
import 'package:intl/intl.dart';
import 'package:next_trip/features/flights/data/models/passenger_model.dart';
import 'package:next_trip/features/flights/data/models/seat_model.dart';

enum BookingStatus { pending, cancelled, completed }

class FlightBooking {
  final String bookingId;
  final String userId;
  final Flight flight;
  final int totalPrice;
  final List<Passenger> passengers;
  final List<Seat> seats;
  final BookingStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  FlightBooking({
    required this.bookingId,
    required this.userId,
    required this.flight,
    required this.totalPrice,
    this.status = BookingStatus.pending,
    this.passengers = const [],
    this.seats = const [],
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
      'flightId': flight.id,
      'flight_details': flight.toMap(),
      'totalPrice': totalPrice,
      'status': status.name,
      'passengers': passengers.map((p) => p.toMap()).toList(),
      'seats': seats.map((s) => s.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory FlightBooking.fromMap(
    String id,
    Map<String, dynamic> map, {
    List<Passenger>? passengers,
    List<Seat>? seats,
  }) {
    try {
      return FlightBooking(
        bookingId: id,
        userId: map['userId'] as String? ?? '',
        flight: Flight.fromMap(
          map['flightId'] as String? ?? '',
          map['flight_details'] as Map<String, dynamic>,
        ),
        totalPrice: (map['totalPrice'] as num?)?.toInt() ?? 0,
        status: BookingStatus.values.firstWhere(
          (e) => e.name == map['status'],
          orElse: () => BookingStatus.pending,
        ),
        passengers: passengers ?? [],
        seats: seats ?? [],
        createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    } catch (e) {
      debugPrint('Error creating FlightBooking from map: $e');
      rethrow;
    }
  }
}
