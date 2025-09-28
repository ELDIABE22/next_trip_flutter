import 'package:flutter/material.dart';
import 'package:next_trip/features/bookings/data/models/flight_booking_model.dart';
import 'package:next_trip/features/bookings/data/services/flight_booking_service.dart';
import 'package:next_trip/features/flights/data/models/flight_model.dart';
import 'package:next_trip/features/flights/data/models/passenger_model.dart';
import 'package:next_trip/features/flights/data/models/seat_model.dart';

class FlightBookingController with ChangeNotifier {
  final FlightBookingService _service = FlightBookingService();

  bool _isLoading = false;
  String? _error;
  List<FlightBooking> _bookings = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<FlightBooking> get bookings => _bookings;

  Future<void> createBooking({
    required String userId,
    required Flight flight,
    required List<Passenger> passengers,
    required List<Seat> selectedSeats,
    required int totalPrice,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.createBooking(
        userId: userId,
        flight: flight,
        passengers: passengers,
        selectedSeats: selectedSeats,
        totalPrice: totalPrice,
      );
    } catch (e) {
      _error = 'Error al crear la reserva: $e';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserBookings(String userId) async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _bookings = await _service.getUserBookings(userId);
      _error = _bookings.isEmpty ? 'No se encontraron reservas' : null;
    } catch (e) {
      _error = 'Error al cargar las reservas';
      _bookings = [];
      debugPrint('Error fetching bookings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
