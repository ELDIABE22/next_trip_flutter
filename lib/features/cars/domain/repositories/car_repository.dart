import 'package:next_trip/features/cars/domain/entities/car.dart';
import 'package:next_trip/features/cars/infrastructure/models/car_model.dart';

abstract class CarRepository {
  Future<List<CarModel>> getCarsByCity(String city, {String? country});

  Future<CarModel?> getCarById(String id);

  Future<List<CarModel>> searchCars({
    String? city,
    String? country,
    double? minPrice,
    double? maxPrice,
    int? minPassengers,
    CarCategory? category,
    TransmissionType? transmission,
    FuelType? fuelType,
    bool? isAvailable,
  });
}
