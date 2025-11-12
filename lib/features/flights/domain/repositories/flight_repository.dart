import '../entities/flight.dart';

abstract class FlightRepository {
  Future<List<Flight>> searchFlights({
    required String originCity,
    required String destinationCity,
    required DateTime departureDate,
  });

  Future<List<Flight>> searchReturnFlights({
    required String originCity,
    required String destinationCity,
    required DateTime returnDate,
  });

  Future<Flight?> getFlightById(String id);

  Future<bool> checkSeatAvailability(String flightId, int requiredSeats);
}
