import '../../domain/entities/flight.dart';
import '../../domain/entities/passenger.dart';
import '../../domain/entities/seat.dart';
import '../../domain/repositories/flight_repository.dart';

class CreateRoundTripBookingUseCase {
  final FlightRepository repository;

  CreateRoundTripBookingUseCase(this.repository);

  Future<void> execute({
    required String userId,
    required Flight outboundFlight,
    required Flight returnFlight,
    required List<Seat> outboundSeats,
    required List<Seat> returnSeats,
    required List<Passenger> passengers,
    required double totalPrice,
  }) {
    return repository.createRoundTripBooking(
      userId: userId,
      outboundFlight: outboundFlight,
      returnFlight: returnFlight,
      outboundSeats: outboundSeats,
      returnSeats: returnSeats,
      passengers: passengers,
      totalPrice: totalPrice,
    );
  }
}
