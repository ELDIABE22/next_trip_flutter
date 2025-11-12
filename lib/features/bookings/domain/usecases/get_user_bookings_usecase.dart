import 'package:next_trip/features/bookings/domain/repositories/flight_booking_repository.dart';
import 'package:next_trip/features/bookings/infrastructure/models/flight_booking_model.dart';

class GetUserBookingsUseCase {
  final FlightBookingRepository repository;

  GetUserBookingsUseCase(this.repository);

  Future<List<FlightBookingModel>> execute({required String userId}) {
    return repository.getUserBookings(userId: userId);
  }
}
