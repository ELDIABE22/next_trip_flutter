import '../../domain/entities/flight.dart';
import '../../domain/entities/seat.dart';
import '../../domain/entities/passenger.dart';
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

  @override
  Future<void> createBooking({
    required String userId,
    required Flight flight,
    required List<Seat> selectedSeats,
    required List<Passenger> passengers,
    required int totalPrice,
  }) => remoteDataSource.createBooking(
    userId: userId,
    flight: flight,
    seats: selectedSeats,
    passengers: passengers,
    totalPrice: totalPrice,
  );

  @override
  Future<void> createRoundTripBooking({
    required String userId,
    required Flight outboundFlight,
    required Flight returnFlight,
    required List<Seat> outboundSeats,
    required List<Seat> returnSeats,
    required List<Passenger> passengers,
    required double totalPrice,
  }) => remoteDataSource.createRoundTripBooking(
    userId: userId,
    outboundFlight: outboundFlight,
    returnFlight: returnFlight,
    outboundSeats: outboundSeats,
    returnSeats: returnSeats,
    passengers: passengers,
    totalPrice: totalPrice,
  );
}
