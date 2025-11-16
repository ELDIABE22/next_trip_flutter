import 'package:next_trip/features/cars/domain/entities/car.dart';
import 'package:next_trip/features/cars/domain/repositories/car_repository.dart';
import 'package:next_trip/features/cars/infrastructure/datasources/car_remote_datasource.dart';
import 'package:next_trip/features/cars/infrastructure/models/car_model.dart';

class CarRepositoryImpl implements CarRepository {
  final CarRemoteDataSource remoteDataSource;

  CarRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CarModel?> getCarById(String id) => remoteDataSource.getCarById(id);

  @override
  Future<List<CarModel>> getCarsByCity(String city, {String? country}) =>
      remoteDataSource.getCarsByCity(city, country: country);

  @override
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
  }) => remoteDataSource.searchCars(
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
