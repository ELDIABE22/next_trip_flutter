import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:next_trip/features/hotels/data/models/hotel_model.dart';

class HotelService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'hotels';

  // Obtener todos los hoteles
  Future<List<Hotel>> getAllHotels() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return Hotel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching hotels: $e');
    }
  }

  // Obtener hoteles disponibles
  Future<List<Hotel>> getAvailableHotels() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('isAvailable', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return Hotel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching available hotels: $e');
    }
  }

  // Obtener hoteles por ciudad
  Future<List<Hotel>> getHotelsByCity(String city, {String? country}) async {
    try {
      Query query = _firestore
          .collection(_collection)
          .where('city', isEqualTo: city);

      if (country != null && country.isNotEmpty) {
        query = query.where('country', isEqualTo: country);
      }

      final QuerySnapshot snapshot = await query
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return Hotel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching hotels by city: $e');
    }
  }

  // Obtener hoteles por país
  Future<List<Hotel>> getHotelsByCountry(String country) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('country', isEqualTo: country)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return Hotel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching hotels by country: $e');
    }
  }

  // Obtener hotel por ID
  Future<Hotel?> getHotelById(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(id)
          .get();

      if (!doc.exists) {
        return null;
      }

      return Hotel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw Exception('Error fetching hotel by ID: $e');
    }
  }

  // Obtener hoteles por ubicación específica (país y ciudad)
  Future<List<Hotel>> getHotelsByLocation(String country, String city) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('country', isEqualTo: country)
          .where('city', isEqualTo: city)
          .where('isAvailable', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return Hotel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching hotels by location: $e');
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

  // Stream para obtener hoteles en tiempo real
  Stream<List<Hotel>> getHotelsStream() {
    return _firestore
        .collection(_collection)
        .where('isAvailable', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Hotel.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  // Stream para obtener hoteles por ciudad en tiempo real
  Stream<List<Hotel>> getHotelsByCityStream(String city, {String? country}) {
    Query query = _firestore
        .collection(_collection)
        .where('city', isEqualTo: city)
        .where('isAvailable', isEqualTo: true);

    if (country != null && country.isNotEmpty) {
      query = query.where('country', isEqualTo: country);
    }

    return query.orderBy('createdAt', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return Hotel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Buscar hoteles por filtros múltiples
  Future<List<Hotel>> searchHotels({
    String? city,
    String? country,
    double? minPrice,
    double? maxPrice,
    int? minGuests,
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

      if (minPrice != null) {
        query = query.where('price', isGreaterThanOrEqualTo: minPrice);
      }

      if (maxPrice != null) {
        query = query.where('price', isLessThanOrEqualTo: maxPrice);
      }

      if (minGuests != null) {
        query = query.where('maxGuests', isGreaterThanOrEqualTo: minGuests);
      }

      final QuerySnapshot snapshot = await query
          .orderBy('price', descending: false)
          .get();

      return snapshot.docs.map((doc) {
        return Hotel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error searching hotels: $e');
    }
  }
}
