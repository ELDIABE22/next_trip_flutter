import 'package:next_trip/features/bookings/domain/repositories/hotel_booking_repository.dart';

class CancelBookingUseCase {
  final HotelBookingRepository repository;

  CancelBookingUseCase(this.repository);

  Future<void> execute({required String id}) {
    return repository.cancelBooking(id: id);
  }
}
