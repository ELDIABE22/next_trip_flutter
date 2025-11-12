import 'package:next_trip/features/hotels/domain/repositories/hotel_repository.dart';
import 'package:next_trip/features/hotels/infrastructure/datasources/hotel_remote_datasource.dart';
import 'package:next_trip/features/hotels/infrastructure/models/hotel_model.dart';

class HotelRepositoryImpl implements HotelRepository {
  final HotelRemoteDataSource remoteDataSource;

  HotelRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<HotelModel>> getAllHotels() => remoteDataSource.getAllHotels();

  @override
  Future<HotelModel?> getHotelById({required String id}) =>
      remoteDataSource.getHotelById(id: id);

  @override
  Future<List<HotelModel>> getHotelsByCity({
    required String city,
    String? country,
  }) => remoteDataSource.getHotelsByCity(city: city, country: country);

  @override
  Stream<List<HotelModel>> getHotelsByCityStream({
    required String city,
    String? country,
  }) => remoteDataSource.getHotelsByCityStream(city: city, country: country);

  @override
  Stream<List<HotelModel>> getHotelsStream() =>
      remoteDataSource.getHotelsStream();

  @override
  Future<void> hotelRefresh() => remoteDataSource.hotelRefresh();
}
