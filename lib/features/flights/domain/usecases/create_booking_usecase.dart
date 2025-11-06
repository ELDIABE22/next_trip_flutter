import '../../domain/entities/flight.dart';
import '../../domain/entities/passenger.dart';
import '../../domain/entities/seat.dart';
import '../../domain/repositories/flight_repository.dart';

class CreateBookingUseCase {
  final FlightRepository repository;

  CreateBookingUseCase(this.repository);

  Future<void> execute({
    required String userId,
    required Flight flight,
    required List<Seat> selectedSeats,
    required List<Passenger> passengers,
    required int totalPrice,
  }) {
    return repository.createBooking(
      userId: userId,
      flight: flight,
      selectedSeats: selectedSeats,
      passengers: passengers,
      totalPrice: totalPrice,
    );
  }
}
