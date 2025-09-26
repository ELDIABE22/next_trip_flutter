import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:next_trip/features/flights/data/models/flight_model.dart';

class FlightService {
  FlightService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  /// Busca vuelos en la colección 'flights'.
  /// Puedes filtrar por IATA de origen/destino y por fecha (solo día).
  Future<List<Flight>> searchFlights({
    String? originIata,
    String? destinationIata,
    DateTime? date,
  }) async {
    Query<Map<String, dynamic>> query = _db.collection('flights');

    if (originIata != null && originIata.isNotEmpty) {
      query = query.where('originIata', isEqualTo: originIata);
    }
    if (destinationIata != null && destinationIata.isNotEmpty) {
      query = query.where('destinationIata', isEqualTo: destinationIata);
    }

    // Si se pasa fecha, filtramos por el rango del día [00:00, 23:59]
    if (date != null) {
      final start = DateTime(date.year, date.month, date.day);
      final end = start.add(const Duration(days: 1));
      query = query
          .where('departureDateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('departureDateTime', isLessThan: Timestamp.fromDate(end));
    }

    // Orden sugerido por fecha de salida
    query = query.orderBy('departureDateTime');

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => Flight.fromMap(doc.id, doc.data()))
        .toList();
  }
}
