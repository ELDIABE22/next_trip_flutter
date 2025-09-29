import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car_model.dart';

class CarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'cars';

  // Obtener todos los carros
  Future<List<Car>> getAllCars() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .get();

      List<Car> cars = snapshot.docs.map((doc) {
        return Car.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      cars.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return cars;
    } catch (e) {
      throw Exception('Error fetching cars: $e');
    }
  }

  // Obtener carros disponibles
  Future<List<Car>> getAvailableCars() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('isAvailable', isEqualTo: true)
          .get();

      List<Car> cars = snapshot.docs.map((doc) {
        return Car.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      cars.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return cars;
    } catch (e) {
      throw Exception('Error fetching available cars: $e');
    }
  }

  // Obtener carros por ciudad
  Future<List<Car>> getCarsByCity(String city, {String? country}) async {
    try {
      Query query = _firestore
          .collection(_collection)
          .where('city', isEqualTo: city);

      if (country != null && country.isNotEmpty) {
        query = query.where('country', isEqualTo: country);
      }

      final QuerySnapshot snapshot = await query.get();

      List<Car> cars = snapshot.docs.map((doc) {
        return Car.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      cars.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return cars;
    } catch (e) {
      throw Exception('Error fetching cars by city: $e');
    }
  }

  // Obtener carros por país
  Future<List<Car>> getCarsByCountry(String country) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('country', isEqualTo: country)
          .get();

      List<Car> cars = snapshot.docs.map((doc) {
        return Car.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      cars.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return cars;
    } catch (e) {
      throw Exception('Error fetching cars by country: $e');
    }
  }

  // Obtener carro por ID
  Future<Car?> getCarById(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(id)
          .get();

      if (!doc.exists) {
        return null;
      }

      return Car.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw Exception('Error fetching car by ID: $e');
    }
  }

  // Obtener carros por ubicación específica (país y ciudad)
  Future<List<Car>> getCarsByLocation(String country, String city) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('country', isEqualTo: country)
          .where('city', isEqualTo: city)
          .where('isAvailable', isEqualTo: true)
          .get();

      List<Car> cars = snapshot.docs.map((doc) {
        return Car.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      cars.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return cars;
    } catch (e) {
      throw Exception('Error fetching cars by location: $e');
    }
  }

  // Obtener países disponibles
  Future<List<String>> getAvailableCountries() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .get();

      final Set<String> countries = {};
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['country'] != null) {
          countries.add(data['country'].toString());
        }
      }

      final List<String> countryList = countries.toList();
      countryList.sort();
      return countryList;
    } catch (e) {
      throw Exception('Error fetching available countries: $e');
    }
  }

  // Obtener ciudades por país
  Future<List<String>> getCitiesByCountry(String country) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('country', isEqualTo: country)
          .get();

      final Set<String> cities = {};
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['city'] != null) {
          cities.add(data['city'].toString());
        }
      }

      final List<String> cityList = cities.toList();
      cityList.sort();
      return cityList;
    } catch (e) {
      throw Exception('Error fetching cities by country: $e');
    }
  }

  // Stream para obtener carros en tiempo real
  Stream<List<Car>> getCarsStream() {
    return _firestore
        .collection(_collection)
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          List<Car> cars = snapshot.docs.map((doc) {
            return Car.fromMap(doc.data(), doc.id);
          }).toList();

          cars.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return cars;
        });
  }

  // Stream para obtener carros por ciudad en tiempo real
  Stream<List<Car>> getCarsByCityStream(String city, {String? country}) {
    Query query = _firestore
        .collection(_collection)
        .where('city', isEqualTo: city)
        .where('isAvailable', isEqualTo: true);

    if (country != null && country.isNotEmpty) {
      query = query.where('country', isEqualTo: country);
    }

    return query.snapshots().map((snapshot) {
      List<Car> cars = snapshot.docs.map((doc) {
        return Car.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      cars.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return cars;
    });
  }

  // Buscar carros por filtros múltiples
  Future<List<Car>> searchCars({
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
      Query query = _firestore.collection(_collection);

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

      List<Car> cars = snapshot.docs.map((doc) {
        return Car.fromMap(doc.data() as Map<String, dynamic>, doc.id);
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

      // Ordenar por precio
      cars.sort((a, b) => a.pricePerDay.compareTo(b.pricePerDay));

      return cars;
    } catch (e) {
      throw Exception('Error searching cars: $e');
    }
  }
}
