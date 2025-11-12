import '../../domain/entities/flight.dart';
import '../../domain/repositories/flight_repository.dart';
import '../datasources/flight_remote_datasource.dart';

class FlightRepositoryImpl implements FlightRepository {
  final FlightRemoteDataSource remoteDataSource;

  FlightRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Flight>> searchFlights({
    required String originCity,
    required String destinationCity,
    required DateTime departureDate,
  }) => remoteDataSource.searchFlights(
    originCity: originCity,
    destinationCity: destinationCity,
    departureDate: departureDate,
  );

  @override
  Future<List<Flight>> searchReturnFlights({
    required String originCity,
    required String destinationCity,
    required DateTime returnDate,
  }) => remoteDataSource.searchReturnFlights(
    originCity: originCity,
    destinationCity: destinationCity,
    returnDate: returnDate,
  );

  @override
  Future<Flight?> getFlightById(String flightId) =>
      remoteDataSource.getFlightById(flightId);

  @override
  Future<bool> checkSeatAvailability(String flightId, int requiredSeats) =>
      remoteDataSource.checkSeatAvailability(flightId, requiredSeats);
}
