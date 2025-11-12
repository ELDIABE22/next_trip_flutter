import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:next_trip/features/bookings/domain/entities/flight_booking.dart';
import 'package:next_trip/features/bookings/domain/repositories/flight_booking_repository.dart';
import 'package:next_trip/features/bookings/infrastructure/models/flight_booking_model.dart';
import 'package:next_trip/features/flights/domain/entities/flight.dart';
import 'package:next_trip/features/flights/infrastructure/models/flight_model.dart';
import 'package:next_trip/features/flights/infrastructure/models/passenger_model.dart';
import 'package:next_trip/features/flights/infrastructure/models/seat_model.dart';

class FlightBookingRemoteDataSource implements FlightBookingRepository {
  final FirebaseFirestore firestore;

  FlightBookingRemoteDataSource({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createBooking({
    required String userId,
    required Flight flight,
    required List<SeatModel> seats,
    required List<PassengerModel> passengers,
    required int totalPrice,
  }) async {
    final bookingRef = firestore.collection('flight_bookings').doc();
    final batch = firestore.batch();

    final bookingData = {
      'bookingId': bookingRef.id,
      'userId': userId,
      'flightId': flight.id,
      'flight_details': FlightModel.fromEntity(flight).toMap(),
      'totalPrice': totalPrice,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    batch.set(bookingRef, bookingData);

    // Guardar pasajeros en subcolección
    for (final passenger in passengers) {
      final passengerRef = bookingRef
          .collection('passengers')
          .doc(passenger.id);
      batch.set(passengerRef, PassengerModel.fromEntity(passenger).toMap());
    }

    // Guardar asientos en subcolección de la reserva
    for (final seat in seats) {
      final seatRef = bookingRef.collection('seats').doc(seat.id);
      batch.set(seatRef, SeatModel.fromEntity(seat).toMap());
    }

    // Actualizar estado de asientos en la colección de vuelos
    final flightRef = firestore.collection('flights').doc(flight.id);
    for (final seat in seats) {
      final flightSeatRef = flightRef.collection('seats').doc(seat.id);
      batch.set(flightSeatRef, {
        'status': 'unavailable',
        'isAvailable': false,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    // Actualizar disponibilidad de asientos del vuelo
    batch.update(flightRef, {
      'availableSeats': FieldValue.increment(-seats.length),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  @override
  Future<void> createRoundTripBooking({
    required String userId,
    required Flight outboundFlight,
    required Flight returnFlight,
    required List<SeatModel> outboundSeats,
    required List<SeatModel> returnSeats,
    required List<PassengerModel> passengers,
    required double totalPrice,
  }) async {
    final batch = firestore.batch();

    // Crear booking de ida
    final outboundBookingRef = firestore.collection('flight_bookings').doc();
    final returnBookingRef = firestore.collection('flight_bookings').doc();

    final totalRoundTripPrice = totalPrice.toInt();

    // Booking de ida
    final outboundBookingData = {
      'bookingId': outboundBookingRef.id,
      'userId': userId,
      'flightId': outboundFlight.id,
      'flight_details': FlightModel.fromEntity(outboundFlight).toMap(),
      'totalPrice': (outboundFlight.totalPriceCop * outboundSeats.length),
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'isRoundTrip': true,
      'tripType': 'outbound',
      'relatedBookingId': returnBookingRef.id,
      'totalRoundTripPrice': totalRoundTripPrice,
    };

    batch.set(outboundBookingRef, outboundBookingData);

    // Booking de regreso
    final returnBookingData = {
      'bookingId': returnBookingRef.id,
      'userId': userId,
      'flightId': returnFlight.id,
      'flight_details': FlightModel.fromEntity(returnFlight).toMap(),
      'totalPrice': (returnFlight.totalPriceCop * returnSeats.length),
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'isRoundTrip': true,
      'tripType': 'back',
      'relatedBookingId': outboundBookingRef.id,
      'totalRoundTripPrice': totalRoundTripPrice,
    };

    batch.set(returnBookingRef, returnBookingData);

    // Guardar pasajeros en ambas reservas
    for (final passenger in passengers) {
      // Pasajeros del vuelo de ida
      final outboundPassengerRef = outboundBookingRef
          .collection('passengers')
          .doc(passenger.id);
      batch.set(
        outboundPassengerRef,
        PassengerModel.fromEntity(passenger).toMap(),
      );

      // Pasajeros del vuelo de regreso
      final returnPassengerRef = returnBookingRef
          .collection('passengers')
          .doc(passenger.id);
      batch.set(
        returnPassengerRef,
        PassengerModel.fromEntity(passenger).toMap(),
      );
    }

    // Guardar asientos de ida en subcolección de la reserva de ida
    for (final seat in outboundSeats) {
      final seatRef = outboundBookingRef.collection('seats').doc(seat.id);
      batch.set(seatRef, SeatModel.fromEntity(seat).toMap());
    }

    // Guardar asientos de regreso en subcolección de la reserva de regreso
    for (final seat in returnSeats) {
      final seatRef = returnBookingRef.collection('seats').doc(seat.id);
      batch.set(seatRef, SeatModel.fromEntity(seat).toMap());
    }

    // Actualizar asientos en vuelo de ida
    final outboundFlightRef = firestore
        .collection('flights')
        .doc(outboundFlight.id);
    for (final seat in outboundSeats) {
      final flightSeatRef = outboundFlightRef.collection('seats').doc(seat.id);
      batch.set(flightSeatRef, {
        'status': 'unavailable',
        'isAvailable': false,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    // Actualizar asientos en vuelo de regreso
    final returnFlightRef = firestore
        .collection('flights')
        .doc(returnFlight.id);
    for (final seat in returnSeats) {
      final flightSeatRef = returnFlightRef.collection('seats').doc(seat.id);
      batch.set(flightSeatRef, {
        'status': 'unavailable',
        'isAvailable': false,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    // Actualizar disponibilidad de asientos
    batch.update(outboundFlightRef, {
      'availableSeats': FieldValue.increment(-outboundSeats.length),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    batch.update(returnFlightRef, {
      'availableSeats': FieldValue.increment(-returnSeats.length),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  @override
  Future<List<FlightBookingModel>> getUserBookings({
    required String userId,
  }) async {
    try {
      final querySnapshot = await firestore
          .collection('flight_bookings')
          .where('userId', isEqualTo: userId)
          .get();

      List<FlightBookingModel> bookings = [];

      for (final doc in querySnapshot.docs) {
        final bookingData = doc.data();

        final passengersSnapshot = await doc.reference
            .collection('passengers')
            .get();

        final passengers = passengersSnapshot.docs
            .map((p) => PassengerModel.fromMap(p.id, p.data()))
            .toList();

        final seatsSnapshot = await doc.reference.collection('seats').get();
        final seats = seatsSnapshot.docs
            .map((s) => SeatModel.fromMap(s.id, s.data()))
            .toList();

        final booking = FlightBookingModel.fromMap(
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

  @override
  Future<List<Map<String, FlightBookingModel>>> getUserRoundTripBookings({
    required String userId,
  }) async {
    try {
      final querySnapshot = await firestore
          .collection('flight_bookings')
          .where('userId', isEqualTo: userId)
          .where('isRoundTrip', isEqualTo: true)
          .get();

      List<FlightBookingModel> roundTripBookings = [];

      for (final doc in querySnapshot.docs) {
        final bookingData = doc.data();

        final passengersSnapshot = await doc.reference
            .collection('passengers')
            .get();
        final passengers = passengersSnapshot.docs
            .map((p) => PassengerModel.fromMap(p.id, p.data()))
            .toList();

        final seatsSnapshot = await doc.reference.collection('seats').get();
        final seats = seatsSnapshot.docs
            .map((s) => SeatModel.fromMap(s.id, s.data()))
            .toList();

        final booking = FlightBookingModel.fromMap(
          doc.id,
          {
            ...bookingData,
            'passengers': passengers.map((p) => p.toMap()).toList(),
            'seats': seats.map((s) => s.toMap()).toList(),
          },
          passengers: passengers,
          seats: seats,
        );

        roundTripBookings.add(booking);
      }

      final Map<String, Map<String, FlightBookingModel>> grouped = {};

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

  @override
  Future<void> cancelBooking({required String bookingId}) async {
    try {
      final bookingRef = firestore.collection('flight_bookings').doc(bookingId);
      final bookingSnapshot = await bookingRef.get();

      if (!bookingSnapshot.exists) {
        debugPrint('No existe una reserva con el ID: $bookingId');
        return;
      }

      final bookingData = bookingSnapshot.data()!;
      final flightId = bookingData['flightId'] as String?;
      final status = bookingData['status'] as String?;

      if (status == 'cancelled') {
        debugPrint('La reserva ya estaba cancelada.');
        return;
      }

      if (status == 'completed') {
        debugPrint('La reserva ya se completo');
        return;
      }

      final batch = firestore.batch();

      batch.update(bookingRef, {
        'status': 'cancelled',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final seatsSnapshot = await bookingRef.collection('seats').get();

      if (flightId != null) {
        final flightRef = firestore.collection('flights').doc(flightId);

        for (final seatDoc in seatsSnapshot.docs) {
          final seatId = seatDoc.id;
          final seatRef = flightRef.collection('seats').doc(seatId);

          batch.update(seatRef, {
            'status': 'available',
            'isAvailable': true,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }

        batch.update(flightRef, {
          'availableSeats': FieldValue.increment(seatsSnapshot.size),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      debugPrint('Reserva $bookingId cancelada correctamente.');
    } catch (e) {
      debugPrint('Error al cancelar la reserva: $e');
      rethrow;
    }
  }
}
