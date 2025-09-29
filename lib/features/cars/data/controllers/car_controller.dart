import 'dart:async';
import '../models/car_model.dart';
import '../services/car_service.dart';

class CarController {
  final CarService _carService = CarService();

  List<Car> _cars = [];
  Car? _selectedCar;
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<List<Car>>? _carsSubscription;

  List<Car> get cars => List.unmodifiable(_cars);
  Car? get selectedCar => _selectedCar;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasCars => _cars.isNotEmpty;

  void Function()? onStateChanged;

  CarController({this.onStateChanged});

  void dispose() {
    _carsSubscription?.cancel();
  }

  // Cargar todos los carros
  Future<void> loadAllCars() async {
    _setLoadingState(true);
    try {
      _cars = await _carService.getAllCars();
      _clearError();
    } catch (e) {
      _setError(_getErrorMessage(e));
      _cars = [];
    } finally {
      _setLoadingState(false);
    }
  }

  // Cargar carros disponibles
  Future<void> loadAvailableCars() async {
    _setLoadingState(true);
    try {
      _cars = await _carService.getAvailableCars();
      _clearError();
    } catch (e) {
      _setError(_getErrorMessage(e));
      _cars = [];
    } finally {
      _setLoadingState(false);
    }
  }

  // Cargar carros por ciudad
  Future<void> loadCarsByCity(String city, {String? country}) async {
    _setLoadingState(true);
    try {
      _cars = await _carService.getCarsByCity(city, country: country);
      _clearError();
    } catch (e) {
      _setError(_getErrorMessage(e));
      _cars = [];
    } finally {
      _setLoadingState(false);
    }
  }

  // Cargar carros por país
  Future<void> loadCarsByCountry(String country) async {
    _setLoadingState(true);
    try {
      _cars = await _carService.getCarsByCountry(country);
      _clearError();
    } catch (e) {
      _setError(_getErrorMessage(e));
      _cars = [];
    } finally {
      _setLoadingState(false);
    }
  }

  // Cargar carro por ID
  Future<void> loadCarById(String id) async {
    _setLoadingState(true);
    try {
      _selectedCar = await _carService.getCarById(id);
      _clearError();

      if (_selectedCar == null) {
        _setError('Carro no encontrado');
      }
    } catch (e) {
      _setError(_getErrorMessage(e));
      _selectedCar = null;
    } finally {
      _setLoadingState(false);
    }
  }

  // Cargar carros por ubicación específica
  Future<void> loadCarsByLocation(String country, String city) async {
    _setLoadingState(true);
    try {
      _cars = await _carService.getCarsByLocation(country, city);
      _clearError();
    } catch (e) {
      _setError(_getErrorMessage(e));
      _cars = [];
    } finally {
      _setLoadingState(false);
    }
  }

  // Escuchar cambios en carros
  void listenToCarsStream() {
    _carsSubscription?.cancel();
    _setLoadingState(true);

    _carsSubscription = _carService.getCarsStream().listen(
      (cars) {
        _cars = cars;
        _clearError();
        _setLoadingState(false);
      },
      onError: (error) {
        _setError(_getErrorMessage(error));
        _cars = [];
        _setLoadingState(false);
      },
    );
  }

  // Escuchar cambios en carros por ciudad
  void listenToCarsByCityStream(String city, {String? country}) {
    _carsSubscription?.cancel();
    _setLoadingState(true);

    _carsSubscription = _carService
        .getCarsByCityStream(city, country: country)
        .listen(
          (cars) {
            _cars = cars;
            _clearError();
            _setLoadingState(false);
          },
          onError: (error) {
            _setError(_getErrorMessage(error));
            _cars = [];
            _setLoadingState(false);
          },
        );
  }

  void stopListening() {
    _carsSubscription?.cancel();
  }

  // Buscar carros con filtros
  Future<void> searchCars({
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
    _setLoadingState(true);
    try {
      _cars = await _carService.searchCars(
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
      _clearError();
    } catch (e) {
      _setError(_getErrorMessage(e));
      _cars = [];
    } finally {
      _setLoadingState(false);
    }
  }

  // Filtrar carros por categoría
  List<Car> getCarsByCategory(CarCategory category) {
    return _cars.where((car) => car.carCategory == category).toList();
  }

  // Filtrar carros por rango de precio
  List<Car> getCarsByPriceRange(double minPrice, double maxPrice) {
    return _cars
        .where(
          (car) => car.pricePerDay >= minPrice && car.pricePerDay <= maxPrice,
        )
        .toList();
  }

  // Filtrar carros por número de pasajeros
  List<Car> getCarsByPassengers(int minPassengers) {
    return _cars.where((car) => car.passengers >= minPassengers).toList();
  }

  // Filtrar carros por transmisión
  List<Car> getCarsByTransmission(TransmissionType transmission) {
    return _cars.where((car) => car.transmission == transmission).toList();
  }

  // Buscar carros por nombre
  List<Car> searchCarsByName(String query) {
    if (query.isEmpty) return _cars;

    return _cars.where((car) {
      return car.name.toLowerCase().contains(query.toLowerCase()) ||
          car.brand.toLowerCase().contains(query.toLowerCase()) ||
          car.model.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Obtener países disponibles
  Future<List<String>> getAvailableCountries() async {
    try {
      return await _carService.getAvailableCountries();
    } catch (e) {
      _setError(_getErrorMessage(e));
      return [];
    }
  }

  // Obtener ciudades por país
  Future<List<String>> getCitiesByCountry(String country) async {
    try {
      return await _carService.getCitiesByCountry(country);
    } catch (e) {
      _setError(_getErrorMessage(e));
      return [];
    }
  }

  // Seleccionar carro
  void selectCar(Car car) {
    _selectedCar = car;
    _notifyStateChanged();
  }

  // Limpiar selección
  void clearSelection() {
    _selectedCar = null;
    _notifyStateChanged();
  }

  // Limpiar errores
  void clearError() {
    _clearError();
  }

  // Refrescar datos
  Future<void> refresh() async {
    await loadAvailableCars();
  }

  // Establecer estado de carga
  void _setLoadingState(bool loading) {
    _isLoading = loading;
    _notifyStateChanged();
  }

  // Establecer error
  void _setError(String error) {
    _errorMessage = error;
    _notifyStateChanged();
  }

  // Limpiar error
  void _clearError() {
    _errorMessage = null;
    _notifyStateChanged();
  }

  // Notificar cambios
  void _notifyStateChanged() {
    onStateChanged?.call();
  }

  // Formatear mensajes de error
  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('network')) {
      return 'Error de conexión. Verifica tu internet.';
    } else if (error.toString().contains('permission')) {
      return 'Sin permisos para acceder a los datos.';
    } else if (error.toString().contains('not-found')) {
      return 'Datos no encontrados.';
    } else {
      return 'Error inesperado: ${error.toString()}';
    }
  }
}
