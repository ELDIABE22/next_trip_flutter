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

  Future<void> createRoundTripBooking({
    required String userId,
    required Flight outboundFlight,
    required Flight returnFlight,
    required List<Passenger> passengers,
    required List<Seat> outboundSeats,
    required List<Seat> returnSeats,
    required double totalPrice,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.createRoundTripBooking(
        userId: userId,
        outboundFlight: outboundFlight,
        returnFlight: returnFlight,
        passengers: passengers,
        outboundSeats: outboundSeats,
        returnSeats: returnSeats,
        totalPrice: totalPrice.toInt(),
      );
    } catch (e) {
      _error = 'Error al crear la reserva de ida y vuelta: $e';
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

  Map<String, dynamic> getBookingStats() {
    final now = DateTime.now();
    final upcomingBookings = _bookings
        .where(
          (b) =>
              b.flight.departureDateTime.isAfter(now) &&
              b.status != BookingStatus.cancelled,
        )
        .length;

    final completedBookings = _bookings
        .where((b) => b.status == BookingStatus.completed)
        .length;

    final roundTripBookings = _bookings
        .where((b) => b.isRoundTrip == true)
        .length;

    return {
      'total': _bookings.length,
      'upcoming': upcomingBookings,
      'completed': completedBookings,
      'roundTrip': roundTripBookings,
    };
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
