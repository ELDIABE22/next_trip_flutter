import '../entities/flight.dart';
import '../entities/seat.dart';
import '../entities/passenger.dart';

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

  Future<void> createBooking({
    required String userId,
    required Flight flight,
    required List<Seat> selectedSeats,
    required List<Passenger> passengers,
    required int totalPrice,
  });

  Future<void> createRoundTripBooking({
    required String userId,
    required Flight outboundFlight,
    required Flight returnFlight,
    required List<Seat> outboundSeats,
    required List<Seat> returnSeats,
    required List<Passenger> passengers,
    required double totalPrice,
  });
}
