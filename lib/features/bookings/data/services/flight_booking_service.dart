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
  }) async {
    final bookingRef = _firestore.collection('flight_bookings').doc();
    final batch = _firestore.batch();

    final bookingData = {
      'bookingId': bookingRef.id,
      'userId': userId,
      'flightId': flight.id,
      'flight_details': flight.toMap(),
      'totalPrice': totalPrice,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
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
}
