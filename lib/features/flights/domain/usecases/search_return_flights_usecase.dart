import '../../domain/entities/flight.dart';
import '../../domain/repositories/flight_repository.dart';

class SearchReturnFlightsUseCase {
  final FlightRepository repository;

  SearchReturnFlightsUseCase(this.repository);

  Future<List<Flight>> execute({
    required String originCity,
    required String destinationCity,
    required DateTime returnDate,
  }) {
    return repository.searchReturnFlights(
      originCity: originCity,
      destinationCity: destinationCity,
      returnDate: returnDate,
    );
  }
}
