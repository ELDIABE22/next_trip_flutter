import 'package:next_trip/features/hotels/domain/repositories/hotel_repository.dart';
import 'package:next_trip/features/hotels/infrastructure/models/hotel_model.dart';

class GetHotelByIdUsecase {
  final HotelRepository repository;

  GetHotelByIdUsecase(this.repository);

  Future<HotelModel?> execute({required String id}) {
    return repository.getHotelById(id: id);
  }
}
