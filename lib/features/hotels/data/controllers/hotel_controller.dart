import 'dart:async';
import 'package:next_trip/features/hotels/data/models/hotel_model.dart';
import '../services/hotel_service.dart';

class HotelController {
  final HotelService _hotelService = HotelService();

  List<Hotel> _hotels = [];
  Hotel? _selectedHotel;
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<List<Hotel>>? _hotelsSubscription;

  List<Hotel> get hotels => List.unmodifiable(_hotels);
  Hotel? get selectedHotel => _selectedHotel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasHotels => _hotels.isNotEmpty;

  void Function()? onStateChanged;

  HotelController({this.onStateChanged});

  void dispose() {
    _hotelsSubscription?.cancel();
  }

  Future<void> loadAllHotels() async {
    _setLoadingState(true);
    try {
      _hotels = await _hotelService.getAllHotels();
      _clearError();
    } catch (e) {
      _setError(_getErrorMessage(e));
      _hotels = [];
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> loadHotelsByCity(String city, {String? country}) async {
    _setLoadingState(true);
    try {
      _hotels = await _hotelService.getHotelsByCity(city, country: country);
      _clearError();
    } catch (e) {
      _setError(_getErrorMessage(e));
      _hotels = [];
    } finally {
      _setLoadingState(false);
    }
  }

  void listenToHotelsStream() {
    _hotelsSubscription?.cancel();
    _setLoadingState(true);

    _hotelsSubscription = _hotelService.getHotelsStream().listen(
      (hotels) {
        _hotels = hotels;
        _clearError();
        _setLoadingState(false);
      },
      onError: (error) {
        _setError(_getErrorMessage(error));
        _hotels = [];
        _setLoadingState(false);
      },
    );
  }

  void listenToHotelsByCityStream(String city, {String? country}) {
    _hotelsSubscription?.cancel();
    _setLoadingState(true);

    _hotelsSubscription = _hotelService
        .getHotelsByCityStream(city, country: country)
        .listen(
          (hotels) {
            _hotels = hotels;
            _clearError();
            _setLoadingState(false);
          },
          onError: (error) {
            _setError(_getErrorMessage(error));
            _hotels = [];
            _setLoadingState(false);
          },
        );
  }

  Future<void> loadHotelById(String id) async {
    _setLoadingState(true);
    try {
      _selectedHotel = await _hotelService.getHotelById(id);
      _clearError();

      if (_selectedHotel == null) {
        _setError('Hotel no encontrado');
      }
    } catch (e) {
      _setError(_getErrorMessage(e));
      _selectedHotel = null;
    } finally {
      _setLoadingState(false);
    }
  }

  void selectHotel(Hotel hotel) {
    _selectedHotel = hotel;
    _notifyStateChanged();
  }

  void clearSelection() {
    _selectedHotel = null;
    _notifyStateChanged();
  }

  void clearError() {
    _clearError();
  }

  Future<void> refresh() async {
    await loadAllHotels();
  }

  void stopListening() {
    _hotelsSubscription?.cancel();
  }

  void _setLoadingState(bool loading) {
    _isLoading = loading;
    _notifyStateChanged();
  }

  void _setError(String error) {
    _errorMessage = error;
    _notifyStateChanged();
  }

  void _clearError() {
    _errorMessage = null;
    _notifyStateChanged();
  }

  void _notifyStateChanged() {
    onStateChanged?.call();
  }

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
