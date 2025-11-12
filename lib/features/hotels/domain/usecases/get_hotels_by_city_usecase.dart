import 'package:next_trip/features/hotels/domain/repositories/hotel_repository.dart';
import 'package:next_trip/features/hotels/infrastructure/models/hotel_model.dart';

class GetHotelsByCityUsecase {
  final HotelRepository repository;

  GetHotelsByCityUsecase(this.repository);

  Future<List<HotelModel>> execute({required String city, String? country}) {
    return repository.getHotelsByCity(city: city, country: country);
  }
}
