import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:next_trip/features/cars/infrastructure/models/car_model.dart';
import '../models/car_booking_model.dart';

class CarBookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'car_bookings';

  // Crear nueva reserva
  Future<CarBooking> createBooking({
    required CarModel car,
    required String userId,
    required String guestName,
    required String guestEmail,
    required String guestPhone,
    required String guestLicenseNumber,
    required DateTime pickupDate,
    required DateTime returnDate,
    required TimeOfDay pickupTime,
    required TimeOfDay returnTime,
    required String pickupLocation,
    required String returnLocation,
  }) async {
    try {
      // Validar fechas
      if (returnDate.isBefore(pickupDate) ||
          returnDate.isAtSameMomentAs(pickupDate)) {
        throw Exception(
          'La fecha de devolución debe ser posterior a la de recogida',
        );
      }

      // Verificar disponibilidad del carro
      final isAvailable = await _checkCarAvailability(
        car.id,
        pickupDate,
        returnDate,
      );
      if (!isAvailable) {
        throw Exception(
          'El carro no está disponible en las fechas seleccionadas',
        );
      }

      final bookingData = CarBooking.fromCar(
        id: '',
        userId: userId,
        car: car,
        pickupDate: pickupDate,
        returnDate: returnDate,
        pickupTime: pickupTime,
        returnTime: returnTime,
        pickupLocation: pickupLocation,
        returnLocation: returnLocation,
        guestName: guestName,
        guestEmail: guestEmail,
        guestPhone: guestPhone,
        guestLicenseNumber: guestLicenseNumber,
      );

      final docRef = await _firestore
          .collection(_collection)
          .add(bookingData.toMap());

      final createdDoc = await docRef.get();
      return CarBooking.fromMap(
        createdDoc.data() as Map<String, dynamic>,
        docRef.id,
      );
    } catch (e) {
      throw Exception('Error creating car booking: $e');
    }
  }

  // Verificar disponibilidad del carro
  Future<bool> _checkCarAvailability(
    String carId,
    DateTime pickupDate,
    DateTime returnDate,
  ) async {
    try {
      final QuerySnapshot conflictingBookings = await _firestore
          .collection(_collection)
          .where('carId', isEqualTo: carId)
          .where('isActive', isEqualTo: true)
          .where(
            'status',
            whereIn: [
              BookingStatus.confirmed.name,
              BookingStatus.inProgress.name,
            ],
          )
          .get();

      for (var doc in conflictingBookings.docs) {
        final booking = CarBooking.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );

        if (_datesOverlap(
          pickupDate,
          returnDate,
          booking.pickupDate,
          booking.returnDate,
        )) {
          return false;
        }
      }

      return true;
    } catch (e) {
      throw Exception('Error checking car availability: $e');
    }
  }

  // Verificar solapamiento de fechas
  bool _datesOverlap(
    DateTime start1,
    DateTime end1,
    DateTime start2,
    DateTime end2,
  ) {
    return start1.isBefore(end2) && end1.isAfter(start2);
  }

  // Obtener reservas por usuario
  Future<List<CarBooking>> getBookingsByUser(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return CarBooking.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching user bookings: $e');
    }
  }

  // Obtener reserva por ID
  Future<CarBooking?> getBookingById(String bookingId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(bookingId)
          .get();

      if (!doc.exists) {
        return null;
      }

      return CarBooking.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw Exception('Error fetching booking: $e');
    }
  }

  // Actualizar estado de reserva
  Future<CarBooking> updateBookingStatus(
    String bookingId,
    BookingStatus newStatus,
  ) async {
    try {
      await _firestore.collection(_collection).doc(bookingId).update({
        'status': newStatus.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final updatedBooking = await getBookingById(bookingId);
      if (updatedBooking == null) {
        throw Exception('Booking not found after update');
      }

      return updatedBooking;
    } catch (e) {
      throw Exception('Error updating booking status: $e');
    }
  }

  // Cancelar reserva
  Future<CarBooking> cancelBooking(String bookingId) async {
    try {
      return await updateBookingStatus(bookingId, BookingStatus.cancelled);
    } catch (e) {
      throw Exception('Error cancelling booking: $e');
    }
  }

  // Confirmar reserva
  Future<CarBooking> confirmBooking(String bookingId) async {
    try {
      return await updateBookingStatus(bookingId, BookingStatus.confirmed);
    } catch (e) {
      throw Exception('Error confirming booking: $e');
    }
  }

  // Marcar como en progreso
  Future<CarBooking> startBooking(String bookingId) async {
    try {
      return await updateBookingStatus(bookingId, BookingStatus.inProgress);
    } catch (e) {
      throw Exception('Error starting booking: $e');
    }
  }

  // Completar reserva
  Future<CarBooking> completeBooking(String bookingId) async {
    try {
      return await updateBookingStatus(bookingId, BookingStatus.completed);
    } catch (e) {
      throw Exception('Error completing booking: $e');
    }
  }

  // Stream para obtener reservas del usuario en tiempo real
  Stream<List<CarBooking>> getUserBookingsStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return CarBooking.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  // Obtener estadísticas de reservas
  Future<Map<String, dynamic>> getBookingStatistics(String userId) async {
    try {
      final bookings = await getBookingsByUser(userId);

      int totalBookings = bookings.length;
      int confirmedBookings = bookings.where((b) => b.isConfirmed).length;
      int cancelledBookings = bookings.where((b) => b.isCancelled).length;
      int completedBookings = bookings.where((b) => b.isCompleted).length;
      int inProgressBookings = bookings.where((b) => b.isInProgress).length;

      double totalSpent = bookings.fold(
        0.0,
        (total, booking) => total + booking.totalPrice,
      );

      return {
        'totalBookings': totalBookings,
        'confirmedBookings': confirmedBookings,
        'cancelledBookings': cancelledBookings,
        'completedBookings': completedBookings,
        'inProgressBookings': inProgressBookings,
        'totalSpent': totalSpent,
      };
    } catch (e) {
      throw Exception('Error getting booking statistics: $e');
    }
  }

  // Obtener reservas por carro (para administradores)
  Future<List<CarBooking>> getBookingsByCar(String carId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('carId', isEqualTo: carId)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return CarBooking.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching car bookings: $e');
    }
  }

  // Buscar reservas con filtros
  Future<List<CarBooking>> searchBookings({
    String? userId,
    String? carId,
    BookingStatus? status,
    DateTime? fromDate,
    DateTime? toDate,
    int limit = 50,
  }) async {
    try {
      Query query = _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true);

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      if (carId != null) {
        query = query.where('carId', isEqualTo: carId);
      }

      if (status != null) {
        query = query.where('status', isEqualTo: status.name);
      }

      if (fromDate != null) {
        query = query.where(
          'pickupDate',
          isGreaterThanOrEqualTo: Timestamp.fromDate(fromDate),
        );
      }

      if (toDate != null) {
        query = query.where(
          'pickupDate',
          isLessThanOrEqualTo: Timestamp.fromDate(toDate),
        );
      }

      final QuerySnapshot snapshot = await query
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        return CarBooking.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error searching bookings: $e');
    }
  }
}
