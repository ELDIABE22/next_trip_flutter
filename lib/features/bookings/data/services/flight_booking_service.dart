import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:next_trip/features/bookings/data/models/flight_booking_model.dart';
import 'package:next_trip/features/flights/data/models/flight_model.dart';
import 'package:next_trip/features/flights/data/models/passenger_model.dart';
import 'package:next_trip/features/flights/data/models/seat_model.dart';

class FlightBookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createBooking({
    required String userId,
    required Flight flight,
    required List<Passenger> passengers,
    required List<Seat> selectedSeats,
    required int totalPrice,
    bool? isRoundTrip,
    TripType? tripType,
    String? relatedBookingId,
    int? totalRoundTripPrice,
  }) async {
    final bookingRef = _firestore.collection('flight_bookings').doc();
    final batch = _firestore.batch();

    final bookingData = {
      'bookingId': bookingRef.id,
      'userId': userId,
      'flightId': flight.id,
      'flight_details': flight.toMap(),
      'totalPrice': totalPrice,
      'status': BookingStatus.pending.name,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      if (isRoundTrip != null) 'isRoundTrip': isRoundTrip,
      if (tripType != null) 'tripType': tripType.name,
      if (relatedBookingId != null) 'relatedBookingId': relatedBookingId,
      if (totalRoundTripPrice != null)
        'totalRoundTripPrice': totalRoundTripPrice,
    };

    batch.set(bookingRef, bookingData);

    for (final passenger in passengers) {
      final passengerRef = bookingRef
          .collection('passengers')
          .doc(passenger.id);
      batch.set(passengerRef, passenger.toMap());
    }

    for (final seat in selectedSeats) {
      final seatRef = bookingRef.collection('seats').doc(seat.id);

      final updatedSeat = Seat(
        id: seat.id,
        row: seat.row,
        column: seat.column,
        status: SeatStatus.unavailable,
        isAvailable: false,
      );

      batch.set(seatRef, updatedSeat.toMap());
    }

    final flightRef = _firestore.collection('flights').doc(flight.id);

    for (final seat in selectedSeats) {
      final flightSeatRef = flightRef.collection('seats').doc(seat.id);
      batch.set(flightSeatRef, {
        'status': SeatStatus.unavailable.name,
        'isAvailable': false,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    batch.update(flightRef, {
      'availableSeats': FieldValue.increment(-selectedSeats.length),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  Future<void> createRoundTripBooking({
    required String userId,
    required Flight outboundFlight,
    required Flight returnFlight,
    required List<Passenger> passengers,
    required List<Seat> outboundSeats,
    required List<Seat> returnSeats,
    required int totalPrice,
  }) async {
    final batch = _firestore.batch();

    try {
      final outboundRef = _firestore.collection('flight_bookings').doc();
      final returnRef = _firestore.collection('flight_bookings').doc();

      final outboundBookingId = outboundRef.id;
      final returnBookingId = returnRef.id;

      final outboundPrice = outboundFlight.totalPriceCop * outboundSeats.length;
      final returnPrice = returnFlight.totalPriceCop * returnSeats.length;

      final outboundBookingData = {
        'bookingId': outboundBookingId,
        'userId': userId,
        'flightId': outboundFlight.id,
        'flight_details': outboundFlight.toMap(),
        'totalPrice': outboundPrice,
        'status': BookingStatus.pending.name,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isRoundTrip': true,
        'tripType': TripType.outbound.name,
        'relatedBookingId': returnBookingId,
        'totalRoundTripPrice': totalPrice,
      };

      batch.set(outboundRef, outboundBookingData);

      for (final passenger in passengers) {
        final passengerRef = outboundRef
            .collection('passengers')
            .doc(passenger.id);
        batch.set(passengerRef, passenger.toMap());
      }

      for (final seat in outboundSeats) {
        final seatRef = outboundRef.collection('seats').doc(seat.id);
        final updatedSeat = Seat(
          id: seat.id,
          row: seat.row,
          column: seat.column,
          status: SeatStatus.unavailable,
          isAvailable: false,
        );
        batch.set(seatRef, updatedSeat.toMap());
      }

      final returnBookingData = {
        'bookingId': returnBookingId,
        'userId': userId,
        'flightId': returnFlight.id,
        'flight_details': returnFlight.toMap(),
        'totalPrice': returnPrice,
        'status': BookingStatus.pending.name,
        'createdAt': FieldValue.serverTimestamp(),
        'isRoundTrip': true,
        'tripType': TripType.back.name,
        'relatedBookingId': outboundBookingId,
        'totalRoundTripPrice': totalPrice,
      };

      batch.set(returnRef, returnBookingData);

      for (final passenger in passengers) {
        final passengerRef = returnRef
            .collection('passengers')
            .doc(passenger.id);
        batch.set(passengerRef, passenger.toMap());
      }

      for (final seat in returnSeats) {
        final seatRef = returnRef.collection('seats').doc(seat.id);
        final updatedSeat = Seat(
          id: seat.id,
          row: seat.row,
          column: seat.column,
          status: SeatStatus.unavailable,
          isAvailable: false,
        );
        batch.set(seatRef, updatedSeat.toMap());
      }

      final outboundFlightRef = _firestore
          .collection('flights')
          .doc(outboundFlight.id);
      for (final seat in outboundSeats) {
        final flightSeatRef = outboundFlightRef
            .collection('seats')
            .doc(seat.id);
        batch.set(flightSeatRef, {
          'status': SeatStatus.unavailable.name,
          'isAvailable': false,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      batch.update(outboundFlightRef, {
        'availableSeats': FieldValue.increment(-outboundSeats.length),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final returnFlightRef = _firestore
          .collection('flights')
          .doc(returnFlight.id);
      for (final seat in returnSeats) {
        final flightSeatRef = returnFlightRef.collection('seats').doc(seat.id);
        batch.set(flightSeatRef, {
          'status': SeatStatus.unavailable.name,
          'isAvailable': false,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      batch.update(returnFlightRef, {
        'availableSeats': FieldValue.increment(-returnSeats.length),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Error al crear la reserva de ida y vuelta: $e');
    }
  }

  Future<List<FlightBooking>> getUserBookings(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('flight_bookings')
          .where('userId', isEqualTo: userId)
          .get();

      List<FlightBooking> bookings = [];

      for (final doc in querySnapshot.docs) {
        final bookingData = doc.data();

        final passengersSnapshot = await doc.reference
            .collection('passengers')
            .get();

        final passengers = passengersSnapshot.docs
            .map((p) => Passenger.fromMap(p.data()))
            .toList();

        final seatsSnapshot = await doc.reference.collection('seats').get();
        final seats = seatsSnapshot.docs
            .map((s) => Seat.fromMap(s.data()))
            .toList();

        final booking = FlightBooking.fromMap(
          doc.id,
          bookingData,
          passengers: passengers,
          seats: seats,
        );

        bookings.add(booking);
      }

      return bookings;
    } catch (e) {
      debugPrint('Error fetching bookings: $e');
      return [];
    }
  }

  Future<List<Map<String, FlightBooking>>> getUserRoundTripBookings(
    String userId,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('flight_bookings')
          .where('userId', isEqualTo: userId)
          .where('isRoundTrip', isEqualTo: true)
          .get();

      List<FlightBooking> roundTripBookings = [];

      for (final doc in querySnapshot.docs) {
        final bookingData = doc.data();

        final passengersSnapshot = await doc.reference
            .collection('passengers')
            .get();
        final passengers = passengersSnapshot.docs
            .map((p) => Passenger.fromMap(p.data()))
            .toList();

        final seatsSnapshot = await doc.reference.collection('seats').get();
        final seats = seatsSnapshot.docs
            .map((s) => Seat.fromMap(s.data()))
            .toList();

        final booking = FlightBooking.fromMap(
          doc.id,
          bookingData,
          passengers: passengers,
          seats: seats,
        );

        roundTripBookings.add(booking);
      }

      final Map<String, Map<String, FlightBooking>> grouped = {};

      for (final booking in roundTripBookings) {
        final relatedId = booking.relatedBookingId;
        if (relatedId != null) {
          final groupKey = [booking.bookingId, relatedId]..sort();
          final key = groupKey.join('-');

          if (!grouped.containsKey(key)) {
            grouped[key] = {};
          }

          if (booking.tripType == TripType.outbound) {
            grouped[key]!['outbound'] = booking;
          } else if (booking.tripType == TripType.back) {
            grouped[key]!['back'] = booking;
          }
        }
      }

      return grouped.values
          .where(
            (pair) =>
                pair.containsKey('outbound') && pair.containsKey('return'),
          )
          .toList();
    } catch (e) {
      debugPrint('Error fetching round trip bookings: $e');
      return [];
    }
  }
}
