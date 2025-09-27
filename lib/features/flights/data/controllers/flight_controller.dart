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
    required String originCity,
    required String destinationCity,
    required DateTime departureDate,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _service.searchFlights(
        originCity: originCity,
        destinationCity: destinationCity,
      );

      final filtered = result.where((f) {
        final flightDate = DateTime(
          f.departureDateTime.year,
          f.departureDateTime.month,
          f.departureDateTime.day,
        );
        final searchDate = DateTime(
          departureDate.year,
          departureDate.month,
          departureDate.day,
        );
        return flightDate == searchDate;
      }).toList();

      _updateFlights(filtered);
    } catch (e) {
      _setError('Error al cargar vuelos: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void _updateFlights(List<Flight> newFlights) {
    _flights.clear();
    _flights.addAll(newFlights);
    notifyListeners();
  }
}
