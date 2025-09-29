import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:next_trip/features/hotels/data/models/hotel_model.dart';
import '../models/hotel_booking_model.dart';

class HotelBookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'hotel_bookings';

  Future<HotelBooking> createBooking({
    required Hotel hotel,
    required String userId,
    required String guestName,
    required String guestEmail,
    required String guestPhone,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    String? specialRequests,
  }) async {
    try {
      // Calcular número de noches
      final numberOfNights = checkOutDate.difference(checkInDate).inDays;

      if (numberOfNights <= 0) {
        throw Exception('Las fechas de check-in y check-out no son válidas');
      }

      // Calcular precio total
      final totalPrice = hotel.price * numberOfNights;

      final now = DateTime.now();

      // Crear el objeto de reserva
      final bookingData = {
        'hotelId': hotel.id,
        'userId': userId,
        'guestName': guestName,
        'guestEmail': guestEmail,
        'guestPhone': guestPhone,
        'checkInDate': Timestamp.fromDate(checkInDate),
        'checkOutDate': Timestamp.fromDate(checkOutDate),
        'totalPrice': totalPrice,
        'numberOfNights': numberOfNights,
        'status': BookingStatus.confirmed.name,
        'bookingDate': Timestamp.fromDate(now),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'hotel_details': hotel.toMap(),
      };

      // Guardar en Firestore
      final docRef = await _firestore.collection(_collection).add(bookingData);

      final createdBooking = await docRef.get();
      return HotelBooking.fromMap(
        createdBooking.data() as Map<String, dynamic>,
        docRef.id,
      );
    } catch (e) {
      throw Exception('Error creating booking: $e');
    }
  }

  // Obtener reservas por usuario
  Future<List<HotelBooking>> getBookingsByUser(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();

      List<HotelBooking> bookings = snapshot.docs.map((doc) {
        return HotelBooking.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return bookings;
    } catch (e) {
      throw Exception('Error fetching user bookings: $e');
    }
  }

  // Obtener reservas por hotel
  Future<List<HotelBooking>> getBookingsByHotel(String hotelId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('hotelId', isEqualTo: hotelId)
          .get();

      List<HotelBooking> bookings = snapshot.docs.map((doc) {
        return HotelBooking.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return bookings;
    } catch (e) {
      throw Exception('Error fetching hotel bookings: $e');
    }
  }

  // Obtener reserva por ID
  Future<HotelBooking?> getBookingById(String bookingId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(bookingId)
          .get();

      if (!doc.exists) {
        return null;
      }

      return HotelBooking.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw Exception('Error fetching booking: $e');
    }
  }

  // Actualizar estado de reserva
  Future<HotelBooking> updateBookingStatus(
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
  Future<HotelBooking> cancelBooking(String bookingId) async {
    try {
      return await updateBookingStatus(bookingId, BookingStatus.cancelled);
    } catch (e) {
      throw Exception('Error cancelling booking: $e');
    }
  }

  // Confirmar reserva
  Future<HotelBooking> confirmBooking(String bookingId) async {
    try {
      return await updateBookingStatus(bookingId, BookingStatus.confirmed);
    } catch (e) {
      throw Exception('Error confirming booking: $e');
    }
  }

  // Stream para escuchar cambios en reservas de un usuario
  Stream<List<HotelBooking>> getUserBookingsStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          List<HotelBooking> bookings = snapshot.docs.map((doc) {
            return HotelBooking.fromMap(doc.data(), doc.id);
          }).toList();

          bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return bookings;
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

      double totalSpent = bookings.fold(
        0.0,
        (total, booking) => total + booking.totalPrice,
      );

      return {
        'totalBookings': totalBookings,
        'confirmedBookings': confirmedBookings,
        'cancelledBookings': cancelledBookings,
        'completedBookings': completedBookings,
        'totalSpent': totalSpent,
      };
    } catch (e) {
      throw Exception('Error getting booking statistics: $e');
    }
  }
}
