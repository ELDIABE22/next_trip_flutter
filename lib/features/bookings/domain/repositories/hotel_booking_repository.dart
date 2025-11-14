import 'package:next_trip/features/bookings/infrastructure/models/hotel_booking_model.dart';
import 'package:next_trip/features/hotels/infrastructure/models/hotel_model.dart';

abstract class HotelBookingRepository {
  Future<HotelBookingModel> createBooking({
    required HotelModel hotel,
    required String userId,
    required String guestName,
    required String guestEmail,
    required String guestPhone,
    required DateTime checkInDate,
    required DateTime checkOutDate,
  });

  Future<List<HotelBookingModel>> getBookingsByUser({required String userId});

  Stream<List<HotelBookingModel>> getUserBookingsStream({
    required String userId,
  });

  Future<void> cancelBooking({required String id});
}
