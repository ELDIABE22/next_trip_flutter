import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/flight_model.dart';
import '../models/seat_model.dart';
import '../models/passenger_model.dart';
import '../../domain/entities/flight.dart';
import '../../domain/entities/seat.dart';
import '../../domain/entities/passenger.dart';

abstract class FlightRemoteDataSource {
  Future<List<Flight>> searchFlights({
    required String originCity,
    required String destinationCity,
    required DateTime departureDate,
  });

  Future<List<Flight>> searchReturnFlights({
    required String originCity,
    required String destinationCity,
    required DateTime returnDate,
  });

  Future<Flight?> getFlightById(String flightId);

  Future<bool> checkSeatAvailability(String flightId, int requiredSeats);

  Future<void> createBooking({
    required String userId,
    required Flight flight,
    required List<Seat> seats,
    required List<Passenger> passengers,
    required int totalPrice,
  });

  Future<void> createRoundTripBooking({
    required String userId,
    required Flight outboundFlight,
    required Flight returnFlight,
    required List<Seat> outboundSeats,
    required List<Seat> returnSeats,
    required List<Passenger> passengers,
    required double totalPrice,
  });
}

class FlightRemoteDataSourceImpl implements FlightRemoteDataSource {
  final FirebaseFirestore firestore;

  FlightRemoteDataSourceImpl({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Flight>> searchFlights({
    required String originCity,
    required String destinationCity,
    required DateTime departureDate,
  }) async {
    final querySnapshot = await firestore
        .collection('flights')
        .where('originCity', isEqualTo: originCity)
        .where('destinationCity', isEqualTo: destinationCity)
        .get();

    final flights = querySnapshot.docs
        .map((doc) {
          return FlightModel.fromMap(doc.id, doc.data());
        })
        .where((flight) {
          final flightDate = DateTime(
            flight.departureDateTime.year,
            flight.departureDateTime.month,
            flight.departureDateTime.day,
          );
          final searchDate = DateTime(
            departureDate.year,
            departureDate.month,
            departureDate.day,
          );
          return flightDate.isAtSameMomentAs(searchDate);
        })
        .toList();

    flights.sort((a, b) => a.departureDateTime.compareTo(b.departureDateTime));

    return flights;
  }

  @override
  Future<List<Flight>> searchReturnFlights({
    required String originCity,
    required String destinationCity,
    required DateTime returnDate,
  }) async {
    final querySnapshot = await firestore
        .collection('flights')
        .where('originCity', isEqualTo: originCity)
        .where('destinationCity', isEqualTo: destinationCity)
        .get();

    final flights = querySnapshot.docs
        .map((doc) {
          return FlightModel.fromMap(doc.id, doc.data());
        })
        .where((flight) {
          final flightDate = DateTime(
            flight.departureDateTime.year,
            flight.departureDateTime.month,
            flight.departureDateTime.day,
          );
          final searchDate = DateTime(
            returnDate.year,
            returnDate.month,
            returnDate.day,
          );
          return flightDate.isAtSameMomentAs(searchDate);
        })
        .toList();

    flights.sort((a, b) => a.departureDateTime.compareTo(b.departureDateTime));

    return flights;
  }

  @override
  Future<Flight?> getFlightById(String flightId) async {
    final doc = await firestore.collection('flights').doc(flightId).get();

    if (!doc.exists) return null;

    return FlightModel.fromMap(doc.id, doc.data()!);
  }

  @override
  Future<bool> checkSeatAvailability(String flightId, int requiredSeats) async {
    final flight = await getFlightById(flightId);
    if (flight == null) return false;

    return (flight.availableSeats ?? 0) >= requiredSeats;
  }

  @override
  Future<void> createBooking({
    required String userId,
    required Flight flight,
    required List<Seat> seats,
    required List<Passenger> passengers,
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
    required List<Seat> outboundSeats,
    required List<Seat> returnSeats,
    required List<Passenger> passengers,
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
}
