import 'package:next_trip/features/cars/domain/entities/car.dart';
import 'package:next_trip/features/cars/domain/repositories/car_repository.dart';
import 'package:next_trip/features/cars/infrastructure/models/car_model.dart';

class SearchCarsUseCase {
  final CarRepository repository;

  SearchCarsUseCase(this.repository);

  Future<List<CarModel>> execute({
    String? city,
    String? country,
    double? minPrice,
    double? maxPrice,
    int? minPassengers,
    CarCategory? category,
    TransmissionType? transmission,
    FuelType? fuelType,
    bool? isAvailable,
  }) {
    return repository.searchCars(
      city: city,
      country: country,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minPassengers: minPassengers,
      category: category,
      transmission: transmission,
      fuelType: fuelType,
      isAvailable: isAvailable,
    );
  }
}
