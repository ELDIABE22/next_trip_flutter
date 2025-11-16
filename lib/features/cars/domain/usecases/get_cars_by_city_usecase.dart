import 'package:next_trip/features/cars/domain/repositories/car_repository.dart';
import 'package:next_trip/features/cars/infrastructure/models/car_model.dart';

class GetCarsByCityUseCase {
  final CarRepository repository;

  GetCarsByCityUseCase(this.repository);

  Future<List<CarModel>> execute(String city, {String? country}) {
    return repository.getCarsByCity(city, country: country);
  }
}
