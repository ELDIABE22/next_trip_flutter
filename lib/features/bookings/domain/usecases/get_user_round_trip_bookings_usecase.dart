import 'package:next_trip/features/bookings/domain/entities/flight_booking.dart';
import 'package:next_trip/features/bookings/domain/repositories/flight_booking_repository.dart';

class GetUserRoundTripBookingsUseCase {
  final FlightBookingRepository repository;

  GetUserRoundTripBookingsUseCase(this.repository);

  Future<List<Map<String, FlightBooking>>> execute({required String userId}) {
    return repository.getUserRoundTripBookings(userId: userId);
  }
}
