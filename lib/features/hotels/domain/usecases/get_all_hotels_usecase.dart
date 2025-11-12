import 'package:next_trip/features/hotels/domain/repositories/hotel_repository.dart';
import 'package:next_trip/features/hotels/infrastructure/models/hotel_model.dart';

class GetAllHotelsUsecase {
  final HotelRepository repository;

  GetAllHotelsUsecase(this.repository);

  Future<List<HotelModel>> execute() {
    return repository.getAllHotels();
  }
}
