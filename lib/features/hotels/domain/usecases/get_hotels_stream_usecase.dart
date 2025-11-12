import 'package:next_trip/features/hotels/domain/repositories/hotel_repository.dart';
import 'package:next_trip/features/hotels/infrastructure/models/hotel_model.dart';

class GetHotelsStreamUsecase {
  final HotelRepository repository;

  GetHotelsStreamUsecase(this.repository);

  Stream<List<HotelModel>> execute() {
    return repository.getHotelsStream();
  }
}
