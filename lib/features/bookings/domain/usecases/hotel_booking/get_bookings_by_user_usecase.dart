import 'package:next_trip/features/bookings/domain/repositories/hotel_booking_repository.dart';
import 'package:next_trip/features/bookings/infrastructure/models/hotel_booking_model.dart';

class GetBookingsByUserUseCase {
  final HotelBookingRepository repository;

  GetBookingsByUserUseCase(this.repository);

  Future<List<HotelBookingModel>> execute({required String userId}) {
    return repository.getBookingsByUser(userId: userId);
  }
}
