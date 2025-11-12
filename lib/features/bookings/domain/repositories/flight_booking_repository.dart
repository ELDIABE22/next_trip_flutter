import 'package:next_trip/features/bookings/infrastructure/models/flight_booking_model.dart';
import 'package:next_trip/features/flights/domain/entities/flight.dart';
import 'package:next_trip/features/flights/infrastructure/models/passenger_model.dart';
import 'package:next_trip/features/flights/infrastructure/models/seat_model.dart';

abstract class FlightBookingRepository {
  Future<void> createBooking({
    required String userId,
    required Flight flight,
    required List<SeatModel> seats,
    required List<PassengerModel> passengers,
    required int totalPrice,
  });

  Future<void> createRoundTripBooking({
    required String userId,
    required Flight outboundFlight,
    required Flight returnFlight,
    required List<SeatModel> outboundSeats,
    required List<SeatModel> returnSeats,
    required List<PassengerModel> passengers,
    required double totalPrice,
  });

  Future<List<FlightBookingModel>> getUserBookings({required String userId});

  Future<List<Map<String, FlightBookingModel>>> getUserRoundTripBookings({
    required String userId,
  });

  Future<void> cancelBooking({required String bookingId});
}
