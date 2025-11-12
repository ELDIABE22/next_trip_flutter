import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:next_trip/core/utils/helpers.dart';
import 'package:next_trip/features/bookings/domain/entities/flight_booking.dart';
import 'package:next_trip/features/flights/infrastructure/models/flight_model.dart';
import 'package:next_trip/features/flights/infrastructure/models/passenger_model.dart';
import 'package:next_trip/features/flights/infrastructure/models/seat_model.dart';

class FlightBookingModel extends FlightBooking {
  FlightBookingModel({
    required super.bookingId,
    required super.userId,
    required super.flight,
    required super.totalPrice,
    super.status,
    super.passengers,
    super.seats,
    super.isRoundTrip,
    super.tripType,
    super.relatedBookingId,
    super.totalRoundTripPrice,
    super.createdAt,
    super.updatedAt,
  });

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

  factory FlightBookingModel.fromMap(
    String id,
    Map<String, dynamic> map, {
    List<PassengerModel>? passengers,
    List<SeatModel>? seats,
  }) {
    try {
      return FlightBookingModel(
        bookingId: id,
        userId: map['userId'] as String? ?? '',
        flight: FlightModel.fromMap(
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
        isRoundTrip: map['isRoundTrip'] as bool?,
        tripType: map['tripType'] != null
            ? TripType.values.firstWhere(
                (e) => e.name == map['tripType'],
                orElse: () => TripType.oneWay,
              )
            : null,
        relatedBookingId: map['relatedBookingId'] as String?,
        totalRoundTripPrice: (map['totalRoundTripPrice'] as num?)?.toInt(),
        createdAt: parseDateTime(map['createdAt']),
        updatedAt: parseDateTime(map['updatedAt']),
      );
    } catch (e) {
      debugPrint('Error creating FlightBookingModel from map: $e');
      rethrow;
    }
  }

  factory FlightBookingModel.fromEntity(FlightBooking entity) {
    return FlightBookingModel(
      bookingId: entity.bookingId,
      userId: entity.userId,
      flight: entity.flight,
      totalPrice: entity.totalPrice,
      passengers: entity.passengers,
      seats: entity.seats,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isRoundTrip: entity.isRoundTrip,
      tripType: entity.tripType,
      relatedBookingId: entity.relatedBookingId,
      totalRoundTripPrice: entity.totalRoundTripPrice,
    );
  }
}
