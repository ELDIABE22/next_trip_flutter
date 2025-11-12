import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:next_trip/features/flights/domain/entities/flight.dart';
import 'package:next_trip/features/flights/infrastructure/models/flight_model.dart';

abstract class FlightRemoteDataSource {
  Future<List<Flight>> searchFlights({
    required String originCity,
    required String destinationCity,
    required DateTime departureDate,
  });

  Future<List<Flight>> searchReturnFlights({
    required String originCity,
    required String destinationCity,
    required DateTime returnDate,
  });

  Future<Flight?> getFlightById(String flightId);

  Future<bool> checkSeatAvailability(String flightId, int requiredSeats);
}

class FlightRemoteDataSourceImpl implements FlightRemoteDataSource {
  final FirebaseFirestore firestore;

  FlightRemoteDataSourceImpl({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Flight>> searchFlights({
    required String originCity,
    required String destinationCity,
    required DateTime departureDate,
  }) async {
    final querySnapshot = await firestore
        .collection('flights')
        .where('originCity', isEqualTo: originCity)
        .where('destinationCity', isEqualTo: destinationCity)
        .get();

    final flights = querySnapshot.docs
        .map((doc) {
          return FlightModel.fromMap(doc.id, doc.data());
        })
        .where((flight) {
          final flightDate = DateTime(
            flight.departureDateTime.year,
            flight.departureDateTime.month,
            flight.departureDateTime.day,
          );
          final searchDate = DateTime(
            departureDate.year,
            departureDate.month,
            departureDate.day,
          );
          return flightDate.isAtSameMomentAs(searchDate);
        })
        .toList();

    flights.sort((a, b) => a.departureDateTime.compareTo(b.departureDateTime));

    return flights;
  }

  @override
  Future<List<Flight>> searchReturnFlights({
    required String originCity,
    required String destinationCity,
    required DateTime returnDate,
  }) async {
    final querySnapshot = await firestore
        .collection('flights')
        .where('originCity', isEqualTo: originCity)
        .where('destinationCity', isEqualTo: destinationCity)
        .get();

    final flights = querySnapshot.docs
        .map((doc) {
          return FlightModel.fromMap(doc.id, doc.data());
        })
        .where((flight) {
          final flightDate = DateTime(
            flight.departureDateTime.year,
            flight.departureDateTime.month,
            flight.departureDateTime.day,
          );
          final searchDate = DateTime(
            returnDate.year,
            returnDate.month,
            returnDate.day,
          );
          return flightDate.isAtSameMomentAs(searchDate);
        })
        .toList();

    flights.sort((a, b) => a.departureDateTime.compareTo(b.departureDateTime));

    return flights;
  }

  @override
  Future<Flight?> getFlightById(String flightId) async {
    final doc = await firestore.collection('flights').doc(flightId).get();

    if (!doc.exists) return null;

    return FlightModel.fromMap(doc.id, doc.data()!);
  }

  @override
  Future<bool> checkSeatAvailability(String flightId, int requiredSeats) async {
    final flight = await getFlightById(flightId);
    if (flight == null) return false;

    return (flight.availableSeats ?? 0) >= requiredSeats;
  }
}
