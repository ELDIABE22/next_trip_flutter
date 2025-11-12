import 'package:next_trip/features/bookings/domain/repositories/flight_booking_repository.dart';

class CancelBookingUseCase {
  final FlightBookingRepository repository;

  CancelBookingUseCase(this.repository);

  Future<void> execute({required String bookingId}) {
    return repository.cancelBooking(bookingId: bookingId);
  }
}
