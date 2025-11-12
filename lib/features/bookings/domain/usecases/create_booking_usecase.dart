import 'package:next_trip/features/bookings/domain/repositories/flight_booking_repository.dart';

import 'package:next_trip/features/flights/domain/entities/flight.dart';
import 'package:next_trip/features/flights/infrastructure/models/passenger_model.dart';
import 'package:next_trip/features/flights/infrastructure/models/seat_model.dart';

class CreateBookingUseCase {
  final FlightBookingRepository repository;

  CreateBookingUseCase(this.repository);

  Future<void> execute({
    required String userId,
    required Flight flight,
    required List<SeatModel> seats,
    required List<PassengerModel> passengers,
    required int totalPrice,
  }) {
    return repository.createBooking(
      userId: userId,
      flight: flight,
      seats: seats,
      passengers: passengers,
      totalPrice: totalPrice,
    );
  }
}
