import 'dart:async';
import 'package:next_trip/features/hotels/data/models/hotel_model.dart';

import '../models/hotel_booking_model.dart';
import '../services/hotel_booking_service.dart';

class HotelBookingController {
  final HotelBookingService _bookingService = HotelBookingService();

  // Estados privados
  List<HotelBooking> _bookings = [];
  List<HotelBooking> _userBookings = [];
  HotelBooking? _selectedBooking;
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<List<HotelBooking>>? _bookingsSubscription;

  // Estados específicos para el proceso de reserva
  bool _isCreatingBooking = false;
  DateTime? _selectedCheckInDate;
  DateTime? _selectedCheckOutDate;
  String _guestName = '';
  String _guestEmail = '';
  String _guestPhone = '';

  // Getters públicos
  List<HotelBooking> get bookings => List.unmodifiable(_bookings);
  List<HotelBooking> get userBookings => List.unmodifiable(_userBookings);
  HotelBooking? get selectedBooking => _selectedBooking;
  bool get isLoading => _isLoading;
  bool get isCreatingBooking => _isCreatingBooking;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasBookings => _bookings.isNotEmpty;
  bool get hasUserBookings => _userBookings.isNotEmpty;

  // Getters para fechas de reserva
  DateTime? get selectedCheckInDate => _selectedCheckInDate;
  DateTime? get selectedCheckOutDate => _selectedCheckOutDate;
  String get guestName => _guestName;
  String get guestEmail => _guestEmail;
  String get guestPhone => _guestPhone;

  // Getters útiles
  bool get hasValidDateRange =>
      _selectedCheckInDate != null &&
      _selectedCheckOutDate != null &&
      _selectedCheckOutDate!.isAfter(_selectedCheckInDate!);

  int get numberOfNights => hasValidDateRange
      ? _selectedCheckOutDate!.difference(_selectedCheckInDate!).inDays
      : 0;

  bool get canCreateBooking =>
      hasValidDateRange &&
      _guestName.isNotEmpty &&
      _guestEmail.isNotEmpty &&
      _guestPhone.isNotEmpty;

  // Callback para notificar cambios al UI
  void Function()? onStateChanged;

  // Constructor
  HotelBookingController({this.onStateChanged});

  // Dispose
  void dispose() {
    _bookingsSubscription?.cancel();
  }

  // === MÉTODOS PARA GESTIÓN DE FECHAS Y DATOS DE HUÉSPED ===

  // Establecer fecha de check-in
  void setCheckInDate(DateTime date) {
    _selectedCheckInDate = date;

    // Si la fecha de check-out es anterior o igual, limpiarla
    if (_selectedCheckOutDate != null &&
        !_selectedCheckOutDate!.isAfter(date)) {
      _selectedCheckOutDate = null;
    }

    _notifyStateChanged();
  }

  // Establecer fecha de check-out
  void setCheckOutDate(DateTime date) {
    if (_selectedCheckInDate != null && date.isAfter(_selectedCheckInDate!)) {
      _selectedCheckOutDate = date;
    }
    _notifyStateChanged();
  }

  // Limpiar fechas seleccionadas
  void clearDates() {
    _selectedCheckInDate = null;
    _selectedCheckOutDate = null;
    _notifyStateChanged();
  }

  // Establecer información del huésped
  void setGuestInfo({String? name, String? email, String? phone}) {
    if (name != null) _guestName = name;
    if (email != null) _guestEmail = email;
    if (phone != null) _guestPhone = phone;
    _notifyStateChanged();
  }

  // Limpiar información del huésped
  void clearGuestInfo() {
    _guestName = '';
    _guestEmail = '';
    _guestPhone = '';
    _notifyStateChanged();
  }

  // === MÉTODOS PARA CREAR RESERVAS ===

  // Crear una nueva reserva
  Future<bool> createBooking({
    required Hotel hotel,
    required String userId,
    String? specialRequests,
  }) async {
    if (!canCreateBooking) {
      _setError('Información incompleta para crear la reserva');
      return false;
    }

    _setCreatingBookingState(true);

    try {
      final booking = await _bookingService.createBooking(
        hotel: hotel,
        userId: userId,
        guestName: _guestName,
        guestEmail: _guestEmail,
        guestPhone: _guestPhone,
        checkInDate: _selectedCheckInDate!,
        checkOutDate: _selectedCheckOutDate!,
        specialRequests: specialRequests,
      );

      // Agregar la nueva reserva a las listas locales
      _bookings.insert(0, booking);
      if (userId == booking.userId) {
        _userBookings.insert(0, booking);
      }

      _selectedBooking = booking;
      _clearError();

      // Limpiar formulario después de crear exitosamente
      clearDates();
      clearGuestInfo();

      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setCreatingBookingState(false);
    }
  }

  // === MÉTODOS PARA CARGAR RESERVAS ===

  // Cargar reservas por usuario
  Future<void> loadUserBookings(String userId) async {
    _setLoadingState(true);
    try {
      _userBookings = await _bookingService.getBookingsByUser(userId);
      _clearError();
    } catch (e) {
      _setError(_getErrorMessage(e));
      _userBookings = [];
    } finally {
      _setLoadingState(false);
    }
  }

  // Cargar reservas por hotel
  Future<void> loadHotelBookings(String hotelId) async {
    _setLoadingState(true);
    try {
      _bookings = await _bookingService.getBookingsByHotel(hotelId);
      _clearError();
    } catch (e) {
      _setError(_getErrorMessage(e));
      _bookings = [];
    } finally {
      _setLoadingState(false);
    }
  }

  // Cargar reserva por ID
  Future<void> loadBookingById(String bookingId) async {
    _setLoadingState(true);
    try {
      _selectedBooking = await _bookingService.getBookingById(bookingId);
      _clearError();

      if (_selectedBooking == null) {
        _setError('Reserva no encontrada');
      }
    } catch (e) {
      _setError(_getErrorMessage(e));
      _selectedBooking = null;
    } finally {
      _setLoadingState(false);
    }
  }

  // Cancelar reserva
  Future<bool> cancelBooking(String bookingId) async {
    _setLoadingState(true);
    try {
      final updatedBooking = await _bookingService.cancelBooking(bookingId);
      _updateBookingInLists(updatedBooking);
      _clearError();
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoadingState(false);
    }
  }

  // Confirmar reserva
  Future<bool> confirmBooking(String bookingId) async {
    _setLoadingState(true);
    try {
      final updatedBooking = await _bookingService.confirmBooking(bookingId);
      _updateBookingInLists(updatedBooking);
      _clearError();
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoadingState(false);
    }
  }

  // // Completar reserva
  // Future<bool> completeBooking(String bookingId) async {
  //   _setLoadingState(true);
  //   try {
  //     final updatedBooking = await _bookingService.completeBooking(bookingId);
  //     _updateBookingInLists(updatedBooking);
  //     _clearError();
  //     return true;
  //   } catch (e) {
  //     _setError(_getErrorMessage(e));
  //     return false;
  //   } finally {
  //     _setLoadingState(false);
  //   }
  // }

  // Escuchar cambios en reservas de usuario
  void listenToUserBookingsStream(String userId) {
    _bookingsSubscription?.cancel();
    _setLoadingState(true);

    _bookingsSubscription = _bookingService
        .getUserBookingsStream(userId)
        .listen(
          (bookings) {
            _userBookings = bookings;
            _bookings = bookings;
            _clearError();
            _setLoadingState(false);
          },
          onError: (error) {
            _setError(_getErrorMessage(error));
            _userBookings = [];
            _bookings = [];
            _setLoadingState(false);
          },
        );
  }

  void stopListening() {
    _bookingsSubscription?.cancel();
  }

  // Obtener estadísticas de reservas
  Future<Map<String, dynamic>?> getBookingStatistics(String userId) async {
    try {
      return await _bookingService.getBookingStatistics(userId);
    } catch (e) {
      _setError(_getErrorMessage(e));
      return null;
    }
  }

  // Filtrar reservas por estado
  List<HotelBooking> getBookingsByStatus(BookingStatus status) {
    return _userBookings.where((booking) => booking.status == status).toList();
  }

  // Obtener reservas pendientes
  List<HotelBooking> get pendingBookings =>
      getBookingsByStatus(BookingStatus.pending);

  // Obtener reservas confirmadas
  List<HotelBooking> get confirmedBookings =>
      getBookingsByStatus(BookingStatus.confirmed);

  // Obtener reservas canceladas
  List<HotelBooking> get cancelledBookings =>
      getBookingsByStatus(BookingStatus.cancelled);

  // Obtener reservas completadas
  List<HotelBooking> get completedBookings =>
      getBookingsByStatus(BookingStatus.completed);

  // Buscar reservas por nombre de hotel
  List<HotelBooking> searchBookingsByHotelName(String query) {
    if (query.isEmpty) return _userBookings;

    return _userBookings.where((booking) {
      return booking.hotelName.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Calcular precio total para las fechas seleccionadas
  double calculateTotalPrice(Hotel hotel) {
    if (!hasValidDateRange) return 0.0;
    return hotel.price * numberOfNights;
  }

  // Formatear precio total
  String getFormattedTotalPrice(Hotel hotel) {
    final total = calculateTotalPrice(hotel);
    return '\$${total.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  // Seleccionar reserva
  void selectBooking(HotelBooking booking) {
    _selectedBooking = booking;
    _notifyStateChanged();
  }

  // Limpiar selección
  void clearSelection() {
    _selectedBooking = null;
    _notifyStateChanged();
  }

  // Limpiar errores
  void clearError() {
    _clearError();
  }

  // Refrescar datos
  Future<void> refresh(String userId) async {
    await loadUserBookings(userId);
  }

  // Actualizar una reserva en las listas locales
  void _updateBookingInLists(HotelBooking updatedBooking) {
    // Actualizar en la lista general
    final index = _bookings.indexWhere((b) => b.id == updatedBooking.id);
    if (index != -1) {
      _bookings[index] = updatedBooking;
    }

    // Actualizar en la lista de usuario
    final userIndex = _userBookings.indexWhere(
      (b) => b.id == updatedBooking.id,
    );
    if (userIndex != -1) {
      _userBookings[userIndex] = updatedBooking;
    }

    // Actualizar reserva seleccionada si es la misma
    if (_selectedBooking?.id == updatedBooking.id) {
      _selectedBooking = updatedBooking;
    }

    _notifyStateChanged();
  }

  // Establecer estado de carga
  void _setLoadingState(bool loading) {
    _isLoading = loading;
    _notifyStateChanged();
  }

  // Establecer estado de creación de reserva
  void _setCreatingBookingState(bool creating) {
    _isCreatingBooking = creating;
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
      return 'Reserva no encontrada.';
    } else if (error.toString().contains('invalid')) {
      return 'Datos de reserva no válidos.';
    } else {
      return 'Error inesperado: ${error.toString()}';
    }
  }

  // Validar email
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validar teléfono
  bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(phone);
  }

  // Validar datos del huésped
  Map<String, String> validateGuestInfo() {
    Map<String, String> errors = {};

    if (_guestName.trim().isEmpty) {
      errors['name'] = 'El nombre es requerido';
    } else if (_guestName.trim().length < 2) {
      errors['name'] = 'El nombre debe tener al menos 2 caracteres';
    }

    if (_guestEmail.trim().isEmpty) {
      errors['email'] = 'El email es requerido';
    } else if (!isValidEmail(_guestEmail.trim())) {
      errors['email'] = 'Formato de email inválido';
    }

    if (_guestPhone.trim().isEmpty) {
      errors['phone'] = 'El teléfono es requerido';
    } else if (!isValidPhone(_guestPhone.trim())) {
      errors['phone'] = 'Formato de teléfono inválido';
    }

    return errors;
  }

  // Validar fechas
  Map<String, String> validateDates() {
    Map<String, String> errors = {};

    if (_selectedCheckInDate == null) {
      errors['checkIn'] = 'Selecciona fecha de check-in';
    } else if (_selectedCheckInDate!.isBefore(
      DateTime.now().subtract(const Duration(days: 1)),
    )) {
      errors['checkIn'] = 'La fecha de check-in no puede ser en el pasado';
    }

    if (_selectedCheckOutDate == null) {
      errors['checkOut'] = 'Selecciona fecha de check-out';
    } else if (_selectedCheckInDate != null &&
        !_selectedCheckOutDate!.isAfter(_selectedCheckInDate!)) {
      errors['checkOut'] =
          'La fecha de check-out debe ser posterior al check-in';
    }

    return errors;
  }

  // Obtener todos los errores de validación
  Map<String, String> getAllValidationErrors() {
    Map<String, String> allErrors = {};
    allErrors.addAll(validateGuestInfo());
    allErrors.addAll(validateDates());
    return allErrors;
  }
}
