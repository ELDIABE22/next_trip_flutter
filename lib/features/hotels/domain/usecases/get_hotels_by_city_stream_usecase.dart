import 'package:next_trip/features/hotels/domain/repositories/hotel_repository.dart';
import 'package:next_trip/features/hotels/infrastructure/models/hotel_model.dart';

class GetHotelsByCityStreamUsecase {
  final HotelRepository repository;

  GetHotelsByCityStreamUsecase(this.repository);

  Stream<List<HotelModel>> execute({required String city, String? country}) {
    return repository.getHotelsByCityStream(city: city, country: country);
  }
}
