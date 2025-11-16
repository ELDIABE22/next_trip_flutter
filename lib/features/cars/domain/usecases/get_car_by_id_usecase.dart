import 'package:next_trip/features/cars/domain/repositories/car_repository.dart';
import 'package:next_trip/features/cars/infrastructure/models/car_model.dart';

class GetCarByIdUseCase {
  final CarRepository repository;

  GetCarByIdUseCase(this.repository);

  Future<CarModel?> execute(String id) {
    return repository.getCarById(id);
  }
}
