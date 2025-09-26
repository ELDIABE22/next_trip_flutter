import 'package:flutter/foundation.dart';
import 'package:next_trip/features/flights/data/models/flight_model.dart';
import 'package:next_trip/features/flights/data/services/flight_service.dart';

class FlightController extends ChangeNotifier {
  FlightController({FlightService? service})
    : _service = service ?? FlightService();

  final FlightService _service;

  final List<Flight> _flights = [];
  List<Flight> get flights => List.unmodifiable(_flights);

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Future<void> searchFlights({
    String? originIata,
    String? destinationIata,
    DateTime? date,
  }) async {
    _setLoading(true);
    _error = null;
    try {
      final result = await _service.searchFlights(
        originIata: originIata,
        destinationIata: destinationIata,
        date: date,
      );
      _flights
        ..clear()
        ..addAll(result);
    } catch (e) {
      _error = 'Error al cargar vuelos: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
