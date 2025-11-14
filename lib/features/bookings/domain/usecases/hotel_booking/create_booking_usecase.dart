import 'package:next_trip/features/bookings/domain/repositories/hotel_booking_repository.dart';
import 'package:next_trip/features/bookings/infrastructure/models/hotel_booking_model.dart';
import 'package:next_trip/features/hotels/infrastructure/models/hotel_model.dart';

class CreateBookingUseCase {
  final HotelBookingRepository repository;

  CreateBookingUseCase(this.repository);

  Future<HotelBookingModel> execute({
    required HotelModel hotel,
    required String userId,
    required String guestName,
    required String guestEmail,
    required String guestPhone,
    required DateTime checkInDate,
    required DateTime checkOutDate,
  }) async {
    return await repository.createBooking(
      hotel: hotel,
      userId: userId,
      guestName: guestName,
      guestEmail: guestEmail,
      guestPhone: guestPhone,
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
    );
  }
}
