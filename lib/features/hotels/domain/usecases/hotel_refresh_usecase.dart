import 'package:next_trip/features/hotels/domain/repositories/hotel_repository.dart';

class HotelRefreshUsecase {
  final HotelRepository repository;

  HotelRefreshUsecase(this.repository);

  Future<void> execute() {
    return repository.hotelRefresh();
  }
}
