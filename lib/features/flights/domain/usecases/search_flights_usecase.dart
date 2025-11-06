import '../../domain/entities/flight.dart';
import '../../domain/repositories/flight_repository.dart';

class SearchFlightsUseCase {
  final FlightRepository repository;

  SearchFlightsUseCase(this.repository);

  Future<List<Flight>> execute({
    required String originCity,
    required String destinationCity,
    required DateTime departureDate,
  }) {
    return repository.searchFlights(
      originCity: originCity,
      destinationCity: destinationCity,
      departureDate: departureDate,
    );
  }
}
