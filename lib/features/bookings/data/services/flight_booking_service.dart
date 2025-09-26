import 'package:cloud_firestore/cloud_firestore.dart';
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
      'status': 'confirmed',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // 🔹 Guardar la reserva principal
    batch.set(bookingRef, bookingData);

    // 🔹 Guardar pasajeros
    for (final passenger in passengers) {
      final passengerRef = bookingRef
          .collection('passengers')
          .doc(passenger.id);
      batch.set(passengerRef, passenger.toMap());
    }

    // 🔹 Guardar asientos dentro de la reserva (subcolección seats de booking)
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

    // 🔹 Referencia al vuelo
    final flightRef = _firestore.collection('flights').doc(flight.id);

    // 🔹 Actualizar asientos en la subcolección del vuelo
    for (final seat in selectedSeats) {
      final flightSeatRef = flightRef.collection('seats').doc(seat.id);
      batch.set(flightSeatRef, {
        'status': SeatStatus.unavailable.name,
        'isAvailable': false,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    // 🔹 Actualizar número de asientos disponibles en el vuelo
    batch.update(flightRef, {
      'availableSeats': FieldValue.increment(-selectedSeats.length),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // 🔹 Ejecutar batch
    await batch.commit();
  }
}
