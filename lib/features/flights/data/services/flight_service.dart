import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:next_trip/features/flights/data/models/flight_model.dart';

class FlightService {
  FlightService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  // Búsqueda principal de vuelos
  Future<List<Flight>> searchFlights({
    required String originCity,
    required String destinationCity,
    required DateTime departureDate,
  }) async {
    try {
      // Consulta base por ciudades
      final query = _db
          .collection('flights')
          .where('originCity', isEqualTo: originCity)
          .where('destinationCity', isEqualTo: destinationCity);

      final snapshot = await query.get();

      // Mapear documentos a objetos Flight
      final allFlights = snapshot.docs
          .map((doc) => Flight.fromMap(doc.id, doc.data()))
          .toList();

      // Filtrar por fecha exacta
      final filteredFlights = _filterFlightsByDate(allFlights, departureDate);

      // Ordenar por hora de salida por defecto
      filteredFlights.sort(
        (a, b) => a.departureDateTime.compareTo(b.departureDateTime),
      );

      return filteredFlights;
    } catch (e) {
      throw Exception('Error al buscar vuelos: ${e.toString()}');
    }
  }

  // Buscar vuelos por rango de fechas (útil para flexibilidad)
  Future<List<Flight>> searchFlightsByDateRange({
    required String originCity,
    required String destinationCity,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final startTimestamp = Timestamp.fromDate(
        DateTime(startDate.year, startDate.month, startDate.day),
      );
      final endTimestamp = Timestamp.fromDate(
        DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59),
      );

      final query = _db
          .collection('flights')
          .where('originCity', isEqualTo: originCity)
          .where('destinationCity', isEqualTo: destinationCity)
          .where('departureDateTime', isGreaterThanOrEqualTo: startTimestamp)
          .where('departureDateTime', isLessThanOrEqualTo: endTimestamp);

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => Flight.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error al buscar vuelos por rango: ${e.toString()}');
    }
  }

  // Obtener vuelos populares/recomendados
  Future<List<Flight>> getPopularFlights({
    String? originCity,
    int limit = 10,
  }) async {
    try {
      Query query = _db.collection('flights');

      if (originCity != null) {
        query = query.where('originCity', isEqualTo: originCity);
      }

      // Ordenar por asientos disponibles (popularidad) y precio
      query = query.orderBy('availableSeats', descending: true).limit(limit);

      final snapshot = await query.get();

      return snapshot.docs
          .map(
            (doc) => Flight.fromMap(doc.id, doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Error al obtener vuelos populares: ${e.toString()}');
    }
  }

  // Buscar vuelos por aerolínea
  Future<List<Flight>> searchFlightsByAirline({
    required String airline,
    String? originCity,
    String? destinationCity,
  }) async {
    try {
      Query query = _db
          .collection('flights')
          .where('airline', isEqualTo: airline);

      if (originCity != null) {
        query = query.where('originCity', isEqualTo: originCity);
      }

      if (destinationCity != null) {
        query = query.where('destinationCity', isEqualTo: destinationCity);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map(
            (doc) => Flight.fromMap(doc.id, doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Error al buscar vuelos por aerolínea: ${e.toString()}');
    }
  }

  // Obtener detalles de un vuelo específico
  Future<Flight?> getFlightById(String flightId) async {
    try {
      final doc = await _db.collection('flights').doc(flightId).get();

      if (!doc.exists) return null;

      return Flight.fromMap(doc.id, doc.data()!);
    } catch (e) {
      throw Exception('Error al obtener vuelo: ${e.toString()}');
    }
  }

  // Verificar disponibilidad de asientos
  Future<bool> checkSeatAvailability(String flightId, int requiredSeats) async {
    try {
      final flight = await getFlightById(flightId);
      if (flight == null) return false;

      return (flight.availableSeats ?? 0) >= requiredSeats;
    } catch (e) {
      throw Exception('Error al verificar disponibilidad: ${e.toString()}');
    }
  }

  // Obtener ciudades de origen únicas
  Future<List<String>> getOriginCities() async {
    try {
      final snapshot = await _db.collection('flights').get();
      final cities = snapshot.docs
          .map((doc) => doc.data()['originCity'] as String?)
          .where((city) => city != null)
          .cast<String>()
          .toSet()
          .toList();
      cities.sort();
      return cities;
    } catch (e) {
      throw Exception('Error al obtener ciudades de origen: ${e.toString()}');
    }
  }

  // Obtener ciudades de destino únicas
  Future<List<String>> getDestinationCities({String? fromOrigin}) async {
    try {
      Query query = _db.collection('flights');

      if (fromOrigin != null) {
        query = query.where('originCity', isEqualTo: fromOrigin);
      }

      final snapshot = await query.get();
      final cities = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>?;
            return data?['destinationCity'] as String?;
          })
          .where((city) => city != null)
          .cast<String>()
          .toSet()
          .toList();
      cities.sort();
      return cities;
    } catch (e) {
      throw Exception('Error al obtener ciudades de destino: ${e.toString()}');
    }
  }

  // Obtener aerolíneas únicas
  Future<List<String>> getAirlines() async {
    try {
      final snapshot = await _db.collection('flights').get();
      final airlines = snapshot.docs
          .map((doc) => doc.data()['airline'] as String?)
          .where((airline) => airline != null)
          .cast<String>()
          .toSet()
          .toList();
      airlines.sort();
      return airlines;
    } catch (e) {
      throw Exception('Error al obtener aerolíneas: ${e.toString()}');
    }
  }

  // Obtener estadísticas de ruta
  Future<Map<String, dynamic>> getRouteStatistics({
    required String originCity,
    required String destinationCity,
  }) async {
    try {
      final query = _db
          .collection('flights')
          .where('originCity', isEqualTo: originCity)
          .where('destinationCity', isEqualTo: destinationCity);

      final snapshot = await query.get();
      final flights = snapshot.docs
          .map((doc) => Flight.fromMap(doc.id, doc.data()))
          .toList();

      if (flights.isEmpty) {
        return {'totalFlights': 0};
      }

      final prices = flights.map((f) => f.totalPriceCop).toList();
      final durations = flights.map((f) => f.duration.inMinutes).toList();
      final airlines = flights.map((f) => f.airline).toSet().length;

      return {
        'totalFlights': flights.length,
        'averagePrice': prices.reduce((a, b) => a + b) / prices.length,
        'minPrice': prices.reduce((a, b) => a < b ? a : b),
        'maxPrice': prices.reduce((a, b) => a > b ? a : b),
        'averageDuration': durations.reduce((a, b) => a + b) / durations.length,
        'minDuration': durations.reduce((a, b) => a < b ? a : b),
        'maxDuration': durations.reduce((a, b) => a > b ? a : b),
        'totalAirlines': airlines,
      };
    } catch (e) {
      throw Exception('Error al obtener estadísticas: ${e.toString()}');
    }
  }

  // Método privado para filtrar vuelos por fecha
  List<Flight> _filterFlightsByDate(List<Flight> flights, DateTime targetDate) {
    return flights.where((flight) {
      final flightDate = DateTime(
        flight.departureDateTime.year,
        flight.departureDateTime.month,
        flight.departureDateTime.day,
      );
      final searchDate = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
      );
      return flightDate.isAtSameMomentAs(searchDate);
    }).toList();
  }

  // Stream para actualizaciones en tiempo real (opcional)
  Stream<List<Flight>> getFlightsStream({
    required String originCity,
    required String destinationCity,
  }) {
    return _db
        .collection('flights')
        .where('originCity', isEqualTo: originCity)
        .where('destinationCity', isEqualTo: destinationCity)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Flight.fromMap(doc.id, doc.data()))
              .toList();
        });
  }
}
