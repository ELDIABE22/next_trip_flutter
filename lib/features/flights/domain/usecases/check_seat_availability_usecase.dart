import '../../domain/repositories/flight_repository.dart';

class CheckSeatAvailabilityUseCase {
  final FlightRepository repository;

  CheckSeatAvailabilityUseCase(this.repository);

  Future<bool> execute(String flightId, int requiredSeats) {
    return repository.checkSeatAvailability(flightId, requiredSeats);
  }
}
