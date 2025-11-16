import 'dart:async';
import 'package:flutter/material.dart';
import 'package:next_trip/features/cars/domain/entities/car.dart';
import 'package:next_trip/features/cars/infrastructure/models/car_model.dart';
import '../models/car_booking_model.dart';
import '../services/car_booking_service.dart';

class CarBookingController {
  final CarBookingService _bookingService = CarBookingService();

  List<CarBooking> _bookings = [];
  List<CarBooking> _userBookings = [];
  CarBooking? _selectedBooking;
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<List<CarBooking>>? _bookingsSubscription;

  bool _isCreatingBooking = false;
  DateTime? _selectedPickupDate;
  DateTime? _selectedReturnDate;
  TimeOfDay? _selectedPickupTime;
  TimeOfDay? _selectedReturnTime;
  String _pickupLocation = '';
  String _returnLocation = '';
  String _guestName = '';
  String _guestEmail = '';
  String _guestPhone = '';
  String _guestLicenseNumber = '';

  List<CarBooking> get bookings => List.unmodifiable(_bookings);
  List<CarBooking> get userBookings => List.unmodifiable(_userBookings);
  CarBooking? get selectedBooking => _selectedBooking;
  bool get isLoading => _isLoading;
  bool get isCreatingBooking => _isCreatingBooking;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasBookings => _bookings.isNotEmpty;
  bool get hasUserBookings => _userBookings.isNotEmpty;

  DateTime? get selectedPickupDate => _selectedPickupDate;
  DateTime? get selectedReturnDate => _selectedReturnDate;
  TimeOfDay? get selectedPickupTime => _selectedPickupTime;
  TimeOfDay? get selectedReturnTime => _selectedReturnTime;
  String get pickupLocation => _pickupLocation;
  String get returnLocation => _returnLocation;
  String get guestName => _guestName;
  String get guestEmail => _guestEmail;
  String get guestPhone => _guestPhone;
  String get guestLicenseNumber => _guestLicenseNumber;

  bool get hasValidDateRange =>
      _selectedPickupDate != null &&
      _selectedReturnDate != null &&
      _selectedReturnDate!.isAfter(_selectedPickupDate!);

  bool get hasValidTimes =>
      _selectedPickupTime != null && _selectedReturnTime != null;

  int get numberOfDays => hasValidDateRange
      ? _selectedReturnDate!.difference(_selectedPickupDate!).inDays
      : 0;

  bool get canCreateBooking =>
      hasValidDateRange &&
      hasValidTimes &&
      _pickupLocation.isNotEmpty &&
      _returnLocation.isNotEmpty &&
      _guestName.isNotEmpty &&
      _guestEmail.isNotEmpty &&
      _guestPhone.isNotEmpty &&
      _guestLicenseNumber.isNotEmpty;

  void Function()? onStateChanged;

  CarBookingController({this.onStateChanged});

  void dispose() {
    _bookingsSubscription?.cancel();
  }

  // Establecer fecha de recogida
  void setPickupDate(DateTime date) {
    _selectedPickupDate = date;

    if (_selectedReturnDate != null && !_selectedReturnDate!.isAfter(date)) {
      _selectedReturnDate = date.add(const Duration(days: 1));
    }

    _notifyStateChanged();
  }

  // Establecer fecha de devolución
  void setReturnDate(DateTime date) {
    if (_selectedPickupDate != null && date.isAfter(_selectedPickupDate!)) {
      _selectedReturnDate = date;
    }
    _notifyStateChanged();
  }

  // Establecer hora de recogida
  void setPickupTime(TimeOfDay time) {
    _selectedPickupTime = time;
    _notifyStateChanged();
  }

  // Establecer hora de devolución
  void setReturnTime(TimeOfDay time) {
    _selectedReturnTime = time;
    _notifyStateChanged();
  }

  // Establecer ubicaciones
  void setPickupLocation(String location) {
    _pickupLocation = location;
    _notifyStateChanged();
  }

  void setReturnLocation(String location) {
    _returnLocation = location;
    _notifyStateChanged();
  }

  // Establecer información del huésped
  void setGuestInfo({
    String? name,
    String? email,
    String? phone,
    String? licenseNumber,
  }) {
    if (name != null) _guestName = name;
    if (email != null) _guestEmail = email;
    if (phone != null) _guestPhone = phone;
    if (licenseNumber != null) _guestLicenseNumber = licenseNumber;
    _notifyStateChanged();
  }

  // Limpiar fechas seleccionadas
  void clearDates() {
    _selectedPickupDate = null;
    _selectedReturnDate = null;
    _selectedPickupTime = null;
    _selectedReturnTime = null;
    _notifyStateChanged();
  }

  // Limpiar información del huésped
  void clearGuestInfo() {
    _guestName = '';
    _guestEmail = '';
    _guestPhone = '';
    _guestLicenseNumber = '';
    _notifyStateChanged();
  }

  // Limpiar ubicaciones
  void clearLocations() {
    _pickupLocation = '';
    _returnLocation = '';
    _notifyStateChanged();
  }

  // Crear una nueva reserva
  Future<bool> createBooking({
    required CarModel car,
    required String userId,
  }) async {
    if (!canCreateBooking) {
      _setError('Información incompleta para crear la reserva');
      return false;
    }

    _setCreatingBookingState(true);

    try {
      final booking = await _bookingService.createBooking(
        car: car,
        userId: userId,
        guestName: _guestName,
        guestEmail: _guestEmail,
        guestPhone: _guestPhone,
        guestLicenseNumber: _guestLicenseNumber,
        pickupDate: _selectedPickupDate!,
        returnDate: _selectedReturnDate!,
        pickupTime: _selectedPickupTime!,
        returnTime: _selectedReturnTime!,
        pickupLocation: _pickupLocation,
        returnLocation: _returnLocation,
      );

      _bookings.insert(0, booking);
      if (userId == booking.userId) {
        _userBookings.insert(0, booking);
      }

      _selectedBooking = booking;
      _clearError();

      clearDates();
      clearGuestInfo();
      clearLocations();

      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setCreatingBookingState(false);
    }
  }

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

  // Iniciar reserva (marcar como en progreso)
  Future<bool> startBooking(String bookingId) async {
    _setLoadingState(true);
    try {
      final updatedBooking = await _bookingService.startBooking(bookingId);
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

  // Completar reserva
  Future<bool> completeBooking(String bookingId) async {
    _setLoadingState(true);
    try {
      final updatedBooking = await _bookingService.completeBooking(bookingId);
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
  List<CarBooking> getBookingsByStatus(BookingStatus status) {
    return _userBookings.where((booking) => booking.status == status).toList();
  }

  // Obtener reservas confirmadas
  List<CarBooking> get confirmedBookings =>
      getBookingsByStatus(BookingStatus.confirmed);

  // Obtener reservas canceladas
  List<CarBooking> get cancelledBookings =>
      getBookingsByStatus(BookingStatus.cancelled);

  // Obtener reservas completadas
  List<CarBooking> get completedBookings =>
      getBookingsByStatus(BookingStatus.completed);

  // Obtener reservas en progreso
  List<CarBooking> get inProgressBookings =>
      getBookingsByStatus(BookingStatus.inProgress);

  // Buscar reservas por nombre de carro
  List<CarBooking> searchBookingsByCarName(String query) {
    if (query.isEmpty) return _userBookings;

    return _userBookings.where((booking) {
      return booking.carName.toLowerCase().contains(query.toLowerCase()) ||
          booking.carBrand.toLowerCase().contains(query.toLowerCase()) ||
          booking.carModel.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Filtrar reservas próximas (próximos 7 días)
  List<CarBooking> get upcomingBookings {
    final now = DateTime.now();
    final sevenDaysFromNow = now.add(const Duration(days: 7));

    return _userBookings.where((booking) {
      return booking.pickupDate.isAfter(now) &&
          booking.pickupDate.isBefore(sevenDaysFromNow) &&
          (booking.isConfirmed || booking.isInProgress);
    }).toList();
  }

  // Calcular precio total para las fechas seleccionadas
  double calculateTotalPrice(Car car) {
    if (!hasValidDateRange) return 0.0;

    final subtotal = car.pricePerDay * numberOfDays;
    final taxes = subtotal * 0.19; // IVA del 19%
    final insurance = subtotal * 0.10; // Seguro del 10%

    return subtotal + taxes + insurance;
  }

  // Calcular subtotal
  double calculateSubtotal(Car car) {
    if (!hasValidDateRange) return 0.0;
    return car.pricePerDay * numberOfDays;
  }

  // Calcular impuestos
  double calculateTaxes(Car car) {
    return calculateSubtotal(car) * 0.19;
  }

  // Calcular seguro
  double calculateInsurance(Car car) {
    return calculateSubtotal(car) * 0.10;
  }

  // Formatear precio total
  String getFormattedTotalPrice(Car car) {
    final total = calculateTotalPrice(car);
    return '\$${total.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  // Seleccionar reserva
  void selectBooking(CarBooking booking) {
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

  // Validar email
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validar teléfono
  bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(phone);
  }

  // Validar número de licencia
  bool isValidLicenseNumber(String licenseNumber) {
    return licenseNumber.trim().length >= 5;
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

    if (_guestLicenseNumber.trim().isEmpty) {
      errors['license'] = 'El número de licencia es requerido';
    } else if (!isValidLicenseNumber(_guestLicenseNumber.trim())) {
      errors['license'] = 'Número de licencia inválido (mínimo 5 caracteres)';
    }

    return errors;
  }

  // Validar fechas
  Map<String, String> validateDates() {
    Map<String, String> errors = {};

    if (_selectedPickupDate == null) {
      errors['pickupDate'] = 'Selecciona fecha de recogida';
    } else if (_selectedPickupDate!.isBefore(
      DateTime.now().subtract(const Duration(days: 1)),
    )) {
      errors['pickupDate'] = 'La fecha de recogida no puede ser en el pasado';
    }

    if (_selectedReturnDate == null) {
      errors['returnDate'] = 'Selecciona fecha de devolución';
    } else if (_selectedPickupDate != null &&
        !_selectedReturnDate!.isAfter(_selectedPickupDate!)) {
      errors['returnDate'] =
          'La fecha de devolución debe ser posterior a la de recogida';
    }

    if (_selectedPickupTime == null) {
      errors['pickupTime'] = 'Selecciona hora de recogida';
    }

    if (_selectedReturnTime == null) {
      errors['returnTime'] = 'Selecciona hora de devolución';
    }

    return errors;
  }

  // Validar ubicaciones
  Map<String, String> validateLocations() {
    Map<String, String> errors = {};

    if (_pickupLocation.trim().isEmpty) {
      errors['pickupLocation'] = 'Selecciona lugar de recogida';
    }

    if (_returnLocation.trim().isEmpty) {
      errors['returnLocation'] = 'Selecciona lugar de devolución';
    }

    return errors;
  }

  // Obtener todos los errores de validación
  Map<String, String> getAllValidationErrors() {
    Map<String, String> allErrors = {};
    allErrors.addAll(validateGuestInfo());
    allErrors.addAll(validateDates());
    allErrors.addAll(validateLocations());
    return allErrors;
  }

  // Actualizar una reserva en las listas locales
  void _updateBookingInLists(CarBooking updatedBooking) {
    final index = _bookings.indexWhere((b) => b.id == updatedBooking.id);
    if (index != -1) {
      _bookings[index] = updatedBooking;
    }

    final userIndex = _userBookings.indexWhere(
      (b) => b.id == updatedBooking.id,
    );
    if (userIndex != -1) {
      _userBookings[userIndex] = updatedBooking;
    }

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
    } else if (error.toString().contains('available')) {
      return 'El vehículo no está disponible en las fechas seleccionadas.';
    } else {
      return 'Error inesperado: ${error.toString()}';
    }
  }
}
