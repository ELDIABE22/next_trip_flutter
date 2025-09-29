import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:next_trip/features/flights/data/models/flight_model.dart';
import 'package:intl/intl.dart';
import 'package:next_trip/features/flights/data/models/passenger_model.dart';
import 'package:next_trip/features/flights/data/models/seat_model.dart';

enum BookingStatus { pending, cancelled, completed }

enum TripType { oneWay, outbound, back }

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

  String get totalPriceLabel {
    final formatter = NumberFormat("#,###", "es_CO");
    return '\$${formatter.format(totalPrice)} COP';
  }

  String get tripTypeLabel {
    switch (tripType) {
      case TripType.oneWay:
        return 'Solo ida';
      case TripType.outbound:
        return 'Vuelo de ida';
      case TripType.back:
        return 'Vuelo de regreso';
      default:
        return 'Solo ida';
    }
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
      'isRoundTrip': isRoundTrip,
      'tripType': tripType?.name,
      'relatedBookingId': relatedBookingId,
      'totalRoundTripPrice': totalRoundTripPrice,
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
        isRoundTrip: map['isRoundTrip'] as bool?,
        tripType: map['tripType'] != null
            ? TripType.values.firstWhere(
                (e) => e.name == map['tripType'],
                orElse: () => TripType.oneWay,
              )
            : null,
        relatedBookingId: map['relatedBookingId'] as String?,
        totalRoundTripPrice: (map['totalRoundTripPrice'] as num?)?.toInt(),
      );
    } catch (e) {
      debugPrint('Error creating FlightBooking from map: $e');
      rethrow;
    }
  }
}
