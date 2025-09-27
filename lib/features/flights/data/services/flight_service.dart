import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:next_trip/features/flights/data/models/flight_model.dart';

class FlightService {
  FlightService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  Future<List<Flight>> searchFlights({
    required String originCity,
    required String destinationCity,
  }) async {
    try {
      final query = _db
          .collection('flights')
          .where('originCity', isEqualTo: originCity)
          .where('destinationCity', isEqualTo: destinationCity);

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => Flight.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error al buscar vuelos: ${e.toString()}');
    }
  }
}
