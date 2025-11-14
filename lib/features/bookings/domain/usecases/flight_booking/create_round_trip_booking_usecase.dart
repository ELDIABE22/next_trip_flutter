import 'package:next_trip/features/bookings/domain/repositories/flight_booking_repository.dart';

import 'package:next_trip/features/flights/domain/entities/flight.dart';
import 'package:next_trip/features/flights/infrastructure/models/passenger_model.dart';
import 'package:next_trip/features/flights/infrastructure/models/seat_model.dart';

class CreateRoundTripBookingUseCase {
  final FlightBookingRepository repository;

  CreateRoundTripBookingUseCase(this.repository);

  Future<void> execute({
    required String userId,
    required Flight outboundFlight,
    required Flight returnFlight,
    required List<SeatModel> outboundSeats,
    required List<SeatModel> returnSeats,
    required List<PassengerModel> passengers,
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
