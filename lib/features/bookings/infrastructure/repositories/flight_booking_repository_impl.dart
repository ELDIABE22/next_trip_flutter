import 'package:next_trip/features/bookings/domain/repositories/flight_booking_repository.dart';
import 'package:next_trip/features/bookings/infrastructure/datasources/flight_booking_remote_datasource.dart';
import 'package:next_trip/features/bookings/infrastructure/models/flight_booking_model.dart';
import 'package:next_trip/features/flights/domain/entities/flight.dart';
import 'package:next_trip/features/flights/infrastructure/models/passenger_model.dart';
import 'package:next_trip/features/flights/infrastructure/models/seat_model.dart';

class FlightBookingRepositoryImpl implements FlightBookingRepository {
  final FlightBookingRemoteDataSource remoteDataSource;

  FlightBookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createBooking({
    required String userId,
    required Flight flight,
    required List<SeatModel> seats,
    required List<PassengerModel> passengers,
    required int totalPrice,
  }) => remoteDataSource.createBooking(
    userId: userId,
    flight: flight,
    seats: seats,
    passengers: passengers,
    totalPrice: totalPrice,
  );

  @override
  Future<void> createRoundTripBooking({
    required String userId,
    required Flight outboundFlight,
    required Flight returnFlight,
    required List<SeatModel> outboundSeats,
    required List<SeatModel> returnSeats,
    required List<PassengerModel> passengers,
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

  @override
  Future<List<FlightBookingModel>> getUserBookings({required String userId}) =>
      remoteDataSource.getUserBookings(userId: userId);

  @override
  Future<List<Map<String, FlightBookingModel>>> getUserRoundTripBookings({
    required String userId,
  }) => remoteDataSource.getUserRoundTripBookings(userId: userId);

  @override
  Future<void> cancelBooking({required String bookingId}) =>
      remoteDataSource.cancelBooking(bookingId: bookingId);
}
