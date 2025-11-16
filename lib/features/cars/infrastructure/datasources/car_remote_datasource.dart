import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:next_trip/features/cars/domain/entities/car.dart';
import 'package:next_trip/features/cars/domain/repositories/car_repository.dart';
import 'package:next_trip/features/cars/infrastructure/models/car_model.dart';

class CarRemoteDataSource implements CarRepository {
  final FirebaseFirestore firestore;

  CarRemoteDataSource({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<CarModel?> getCarById(String id) async {
    try {
      final DocumentSnapshot doc = await firestore
          .collection('cars')
          .doc(id)
          .get();

      if (!doc.exists) {
        return null;
      }

      return CarModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error fetching car by ID: $e');
    }
  }

  @override
  Future<List<CarModel>> getCarsByCity(String city, {String? country}) async {
    try {
      Query query = firestore.collection('cars').where('city', isEqualTo: city);

      if (country != null && country.isNotEmpty) {
        query = query.where('country', isEqualTo: country);
      }

      final QuerySnapshot snapshot = await query.get();

      List<CarModel> cars = snapshot.docs.map((doc) {
        return CarModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();

      cars.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return cars;
    } catch (e) {
      throw Exception('Error fetching cars by city: $e');
    }
  }

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
  }) async {
    try {
      Query query = firestore.collection('cars');

      if (city != null && city.isNotEmpty) {
        query = query.where('city', isEqualTo: city);
      }

      if (country != null && country.isNotEmpty) {
        query = query.where('country', isEqualTo: country);
      }

      if (isAvailable != null) {
        query = query.where('isAvailable', isEqualTo: isAvailable);
      }

      if (category != null) {
        query = query.where('carCategory', isEqualTo: category.name);
      }

      if (transmission != null) {
        query = query.where('transmission', isEqualTo: transmission.name);
      }

      if (fuelType != null) {
        query = query.where('fuelType', isEqualTo: fuelType.name);
      }

      final QuerySnapshot snapshot = await query.get();

      List<CarModel> cars = snapshot.docs.map((doc) {
        return CarModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();

      if (minPrice != null) {
        cars = cars.where((car) => car.pricePerDay >= minPrice).toList();
      }

      if (maxPrice != null) {
        cars = cars.where((car) => car.pricePerDay <= maxPrice).toList();
      }

      if (minPassengers != null) {
        cars = cars.where((car) => car.passengers >= minPassengers).toList();
      }

      cars.sort((a, b) => a.pricePerDay.compareTo(b.pricePerDay));

      return cars;
    } catch (e) {
      throw Exception('Error searching cars: $e');
    }
  }
}
