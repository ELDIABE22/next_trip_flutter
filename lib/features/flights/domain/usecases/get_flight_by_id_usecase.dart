import '../../domain/entities/flight.dart';
import '../../domain/repositories/flight_repository.dart';

class GetFlightByIdUseCase {
  final FlightRepository repository;

  GetFlightByIdUseCase(this.repository);

  Future<Flight?> execute(String flightId) {
    return repository.getFlightById(flightId);
  }
}
