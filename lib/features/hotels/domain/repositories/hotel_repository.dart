import 'package:next_trip/features/hotels/infrastructure/models/hotel_model.dart';

abstract class HotelRepository {
  Future<List<HotelModel>> getAllHotels();

  Future<List<HotelModel>> getHotelsByCity({
    required String city,
    String? country,
  });

  Future<HotelModel?> getHotelById({required String id});

  Stream<List<HotelModel>> getHotelsStream();

  Stream<List<HotelModel>> getHotelsByCityStream({
    required String city,
    String? country,
  });

  Future<void> hotelRefresh();
}
