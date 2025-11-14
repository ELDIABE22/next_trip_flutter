import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:next_trip/features/bookings/domain/entities/hotel_booking.dart';
import 'package:next_trip/features/bookings/domain/repositories/hotel_booking_repository.dart';
import 'package:next_trip/features/bookings/infrastructure/models/hotel_booking_model.dart';
import 'package:next_trip/features/hotels/infrastructure/models/hotel_model.dart';

class HotelBookingRemoteDataSource implements HotelBookingRepository {
  final FirebaseFirestore firestore;

  HotelBookingRemoteDataSource({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<HotelBookingModel> createBooking({
    required HotelModel hotel,
    required String userId,
    required String guestName,
    required String guestEmail,
    required String guestPhone,
    required DateTime checkInDate,
    required DateTime checkOutDate,
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

      final docRef = await firestore
          .collection('hotel_bookings')
          .add(bookingData);

      final createdBooking = await docRef.get();

      return HotelBookingModel.fromMap(
        docRef.id,
        createdBooking.data() as Map<String, dynamic>,
      );
    } catch (e) {
      throw Exception('Error creating booking: $e');
    }
  }

  @override
  Future<List<HotelBookingModel>> getBookingsByUser({
    required String userId,
  }) async {
    try {
      final QuerySnapshot snapshot = await firestore
          .collection('hotel_bookings')
          .where('userId', isEqualTo: userId)
          .get();

      List<HotelBookingModel> bookings = snapshot.docs.map((doc) {
        return HotelBookingModel.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();

      bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return bookings;
    } catch (e) {
      throw Exception('Error fetching user bookings: $e');
    }
  }

  @override
  Stream<List<HotelBookingModel>> getUserBookingsStream({
    required String userId,
  }) {
    return firestore
        .collection('hotel_bookings')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          List<HotelBookingModel> bookings = snapshot.docs.map((doc) {
            return HotelBookingModel.fromMap(doc.id, doc.data());
          }).toList();

          bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return bookings;
        });
  }

  @override
  Future<void> cancelBooking({required String id}) async {
    try {
      await firestore.collection('hotel_bookings').doc(id).update({
        'status': BookingStatus.cancelled.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error cancelling booking: $e');
    }
  }
}
