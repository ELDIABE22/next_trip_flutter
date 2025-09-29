import 'package:flutter/material.dart';
import 'package:next_trip/features/flights/data/models/flight_model.dart';
import 'package:next_trip/features/flights/data/services/flight_service.dart';

// Enum para opciones de ordenamiento
enum SortOption {
  priceAsc,
  priceDesc,
  durationAsc,
  durationDesc,
  departureAsc,
  departureDesc,
}

class FlightController extends ChangeNotifier {
  FlightController({FlightService? service})
    : _service = service ?? FlightService();

  final FlightService _service;

  final List<Flight> _flights = [];
  final List<Flight> _allFlights = [];
  final List<Flight> _returnFlights = [];
  final List<Flight> _allReturnFlights = [];

  Flight? _selectedOutboundFlight;
  Flight? _selectedReturnFlight;

  bool _loading = false;
  bool _returnLoading = false;
  String? _error;
  bool _isRoundTrip = false;

  List<Flight> get flights => List.unmodifiable(_flights);
  List<Flight> get allFlights => List.unmodifiable(_allFlights);
  List<Flight> get returnFlights => List.unmodifiable(_returnFlights);
  List<Flight> get allReturnFlights => List.unmodifiable(_allReturnFlights);

  Flight? get selectedOutboundFlight => _selectedOutboundFlight;
  Flight? get selectedReturnFlight => _selectedReturnFlight;

  bool get loading => _loading;
  bool get returnLoading => _returnLoading;
  String? get error => _error;
  bool get isRoundTrip => _isRoundTrip;

  bool get hasOutboundFlight => _selectedOutboundFlight != null;
  bool get hasReturnFlight => _selectedReturnFlight != null;
  bool get hasCompleteRoundTrip => hasOutboundFlight && hasReturnFlight;

  Future<void> searchFlights({
    required String originCity,
    required String destinationCity,
    required DateTime departureDate,
    bool isRoundTrip = false,
  }) async {
    _isRoundTrip = isRoundTrip;
    _setLoading(true);
    _clearError();

    try {
      final result = await _service.searchFlights(
        originCity: originCity,
        destinationCity: destinationCity,
        departureDate: departureDate,
      );

      _allFlights.clear();
      _allFlights.addAll(result);
      _updateFlights(result);
    } catch (e) {
      _setError('Error al cargar vuelos: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Búsqueda de vuelos de regreso
  Future<void> searchReturnFlights({
    required String originCity,
    required String destinationCity,
    required DateTime returnDate,
  }) async {
    if (!_isRoundTrip) return;

    _returnLoading = true;
    _clearError();
    notifyListeners();

    try {
      final result = await _service.searchFlights(
        originCity: originCity,
        destinationCity: destinationCity,
        departureDate: returnDate,
      );

      _allReturnFlights.clear();
      _allReturnFlights.addAll(result);
      _returnFlights.clear();
      _returnFlights.addAll(result);
    } catch (e) {
      _setError('Error al cargar vuelos de regreso: ${e.toString()}');
    } finally {
      _returnLoading = false;
      notifyListeners();
    }
  }

  // Seleccionar vuelo de ida
  void selectOutboundFlight(Flight flight) {
    _selectedOutboundFlight = flight;
    notifyListeners();
  }

  // Seleccionar vuelo de regreso
  void selectReturnFlight(Flight flight) {
    _selectedReturnFlight = flight;
    notifyListeners();
  }

  // Limpiar selecciones
  void clearSelections() {
    _selectedOutboundFlight = null;
    _selectedReturnFlight = null;
    notifyListeners();
  }

  // Aplicar filtros avanzados
  void applyFilters({
    double? minPrice,
    double? maxPrice,
    double? minDuration,
    double? maxDuration,
    bool directFlightsOnly = false,
    Set<String> airlines = const {},
    TimeOfDay? minDepartureTime,
    TimeOfDay? maxDepartureTime,
    SortOption sortOption = SortOption.priceAsc,
    bool isReturnFlight = false,
  }) {
    final sourceFlights = isReturnFlight ? _allReturnFlights : _allFlights;
    List<Flight> filteredFlights = List.from(sourceFlights);

    // Filtrar por precio
    if (minPrice != null && maxPrice != null) {
      filteredFlights = filteredFlights.where((flight) {
        return flight.totalPriceCop >= minPrice &&
            flight.totalPriceCop <= maxPrice;
      }).toList();
    }

    // Filtrar por duración
    if (minDuration != null && maxDuration != null) {
      filteredFlights = filteredFlights.where((flight) {
        final hours = flight.duration.inMinutes / 60.0;
        return hours >= minDuration && hours <= maxDuration;
      }).toList();
    }

    // Filtrar por vuelos directos
    if (directFlightsOnly) {
      filteredFlights = filteredFlights
          .where((flight) => flight.isDirect ?? true)
          .toList();
    }

    // Filtrar por aerolíneas
    if (airlines.isNotEmpty) {
      filteredFlights = filteredFlights.where((flight) {
        return airlines.contains(flight.airline ?? 'Sin aerolínea');
      }).toList();
    }

    // Filtrar por horarios
    if (minDepartureTime != null || maxDepartureTime != null) {
      filteredFlights = filteredFlights.where((flight) {
        final departureHour = flight.departureDateTime.hour;
        final departureMinute = flight.departureDateTime.minute;
        final flightTime = TimeOfDay(
          hour: departureHour,
          minute: departureMinute,
        );

        bool passesMinTime =
            minDepartureTime == null ||
            _timeOfDayToMinutes(flightTime) >=
                _timeOfDayToMinutes(minDepartureTime);
        bool passesMaxTime =
            maxDepartureTime == null ||
            _timeOfDayToMinutes(flightTime) <=
                _timeOfDayToMinutes(maxDepartureTime);

        return passesMinTime && passesMaxTime;
      }).toList();
    }

    // Ordenar según la opción seleccionada
    _sortFlights(filteredFlights, sortOption);

    // Actualizar la lista correspondiente
    if (isReturnFlight) {
      _returnFlights.clear();
      _returnFlights.addAll(filteredFlights);
    } else {
      _updateFlights(filteredFlights);
    }
  }

  // Limpiar filtros
  void clearFilters({bool isReturnFlight = false}) {
    if (isReturnFlight) {
      _returnFlights.clear();
      _returnFlights.addAll(_allReturnFlights);
    } else {
      _updateFlights(List.from(_allFlights));
    }
  }

  // Ordenar vuelos
  void _sortFlights(List<Flight> flightsToSort, SortOption sortOption) {
    switch (sortOption) {
      case SortOption.priceAsc:
        flightsToSort.sort(
          (a, b) => a.totalPriceCop.compareTo(b.totalPriceCop),
        );
        break;
      case SortOption.priceDesc:
        flightsToSort.sort(
          (a, b) => b.totalPriceCop.compareTo(a.totalPriceCop),
        );
        break;
      case SortOption.durationAsc:
        flightsToSort.sort((a, b) => a.duration.compareTo(b.duration));
        break;
      case SortOption.durationDesc:
        flightsToSort.sort((a, b) => b.duration.compareTo(a.duration));
        break;
      case SortOption.departureAsc:
        flightsToSort.sort(
          (a, b) => a.departureDateTime.compareTo(b.departureDateTime),
        );
        break;
      case SortOption.departureDesc:
        flightsToSort.sort(
          (a, b) => b.departureDateTime.compareTo(a.departureDateTime),
        );
        break;
    }
  }

  // Obtener aerolíneas disponibles
  List<String> getAvailableAirlines({bool isReturnFlight = false}) {
    final sourceFlights = isReturnFlight ? _allReturnFlights : _allFlights;
    final airlines = sourceFlights
        .map((f) => f.airline ?? 'Sin aerolínea')
        .toSet()
        .toList();
    airlines.sort();
    return airlines;
  }

  // Obtener rangos de precio
  Map<String, double> getPriceRange({bool isReturnFlight = false}) {
    final sourceFlights = isReturnFlight ? _allReturnFlights : _allFlights;
    if (sourceFlights.isEmpty) return {'min': 0, 'max': 1000000};

    final prices = sourceFlights
        .map((f) => f.totalPriceCop.toDouble())
        .toList();
    return {
      'min': prices.reduce((a, b) => a < b ? a : b),
      'max': prices.reduce((a, b) => a > b ? a : b),
    };
  }

  // Obtener rangos de duración
  Map<String, double> getDurationRange({bool isReturnFlight = false}) {
    final sourceFlights = isReturnFlight ? _allReturnFlights : _allFlights;
    if (sourceFlights.isEmpty) return {'min': 1, 'max': 12};

    final durations = sourceFlights
        .map((f) => f.duration.inMinutes / 60.0)
        .toList();
    return {
      'min': durations.reduce((a, b) => a < b ? a : b),
      'max': durations.reduce((a, b) => a > b ? a : b),
    };
  }

  // Calcular precio total para ida y vuelta
  double get totalRoundTripPrice {
    if (!hasCompleteRoundTrip) return 0.0;
    return (_selectedOutboundFlight!.totalPriceCop +
            _selectedReturnFlight!.totalPriceCop)
        .toDouble();
  }

  // Formatear precio total de ida y vuelta
  String get formattedTotalRoundTripPrice {
    if (!hasCompleteRoundTrip) return '\$0';
    final total = totalRoundTripPrice.toInt();
    return '\$${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  // Obtener resumen de selecciones
  Map<String, dynamic> getSelectionSummary() {
    return {
      'hasOutbound': hasOutboundFlight,
      'hasReturn': hasReturnFlight,
      'isComplete': hasCompleteRoundTrip,
      'outboundFlight': _selectedOutboundFlight?.toMap(),
      'returnFlight': _selectedReturnFlight?.toMap(),
      'totalPrice': totalRoundTripPrice,
      'formattedTotalPrice': formattedTotalRoundTripPrice,
    };
  }

  // Convertir TimeOfDay a minutos
  int _timeOfDayToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  // Métodos privados para gestión de estado
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

  // Reiniciar controlador
  void reset() {
    _flights.clear();
    _allFlights.clear();
    _returnFlights.clear();
    _allReturnFlights.clear();
    _selectedOutboundFlight = null;
    _selectedReturnFlight = null;
    _loading = false;
    _returnLoading = false;
    _error = null;
    _isRoundTrip = false;
    notifyListeners();
  }

  // Estadísticas
  Map<String, dynamic> getSearchStatistics({bool isReturnFlight = false}) {
    final sourceFlights = isReturnFlight ? _returnFlights : _flights;
    if (sourceFlights.isEmpty) return {};

    final prices = sourceFlights.map((f) => f.totalPriceCop).toList();
    final durations = sourceFlights.map((f) => f.duration.inMinutes).toList();
    final directFlights = sourceFlights.where((f) => f.isDirect ?? true).length;

    return {
      'totalFlights': sourceFlights.length,
      'averagePrice': prices.reduce((a, b) => a + b) / prices.length,
      'minPrice': prices.reduce((a, b) => a < b ? a : b),
      'maxPrice': prices.reduce((a, b) => a > b ? a : b),
      'averageDuration': durations.reduce((a, b) => a + b) / durations.length,
      'directFlights': directFlights,
      'connectingFlights': sourceFlights.length - directFlights,
      'airlines': getAvailableAirlines(isReturnFlight: isReturnFlight).length,
    };
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}
