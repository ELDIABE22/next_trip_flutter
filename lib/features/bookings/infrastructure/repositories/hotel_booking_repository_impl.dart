import 'package:next_trip/features/bookings/domain/repositories/hotel_booking_repository.dart';
import 'package:next_trip/features/bookings/infrastructure/datasources/hotel_booking_remote_datasource.dart';
import 'package:next_trip/features/bookings/infrastructure/models/hotel_booking_model.dart';
import 'package:next_trip/features/hotels/infrastructure/models/hotel_model.dart';

class HotelBookingRepositoryImpl implements HotelBookingRepository {
  final HotelBookingRemoteDataSource remoteDataSource;

  HotelBookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<HotelBookingModel> createBooking({
    required HotelModel hotel,
    required String userId,
    required String guestName,
    required String guestEmail,
    required String guestPhone,
    required DateTime checkInDate,
    required DateTime checkOutDate,
  }) => remoteDataSource.createBooking(
    hotel: hotel,
    userId: userId,
    guestName: guestName,
    guestEmail: guestEmail,
    guestPhone: guestPhone,
    checkInDate: checkInDate,
    checkOutDate: checkOutDate,
  );

  @override
  Future<List<HotelBookingModel>> getBookingsByUser({required String userId}) =>
      remoteDataSource.getBookingsByUser(userId: userId);

  @override
  Stream<List<HotelBookingModel>> getUserBookingsStream({
    required String userId,
  }) => remoteDataSource.getUserBookingsStream(userId: userId);

  @override
  Future<void> cancelBooking({required String id}) =>
      remoteDataSource.cancelBooking(id: id);
}
