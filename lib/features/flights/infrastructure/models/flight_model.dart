import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:next_trip/core/utils/helpers.dart';
import '../../domain/entities/flight.dart';

class FlightModel extends Flight {
  FlightModel({
    required super.id,
    super.airline,
    super.flightNumber,
    required super.originCity,
    required super.originIata,
    required super.destinationCity,
    required super.destinationIata,
    required super.departureDateTime,
    required super.arrivalDateTime,
    super.isDirect,
    required super.duration,
    required super.totalPriceCop,
    super.availableSeats,
    super.createdAt,
    super.updatedAt,
  });

  /// Duración formateada como "1h 33m"
  String get durationLabel {
    final h = duration.inHours;
    final m = duration.inMinutes.remainder(60);
    if (h > 0 && m > 0) return '${h}h ${m}m';
    if (h > 0) return '${h}h';
    return '${m}m';
  }

  Map<String, dynamic> toMap() {
    return {
      'airline': airline,
      'flightNumber': flightNumber,
      'originCity': originCity,
      'originIata': originIata,
      'destinationCity': destinationCity,
      'destinationIata': destinationIata,
      'departureDateTime': Timestamp.fromDate(departureDateTime),
      'arrivalDateTime': Timestamp.fromDate(arrivalDateTime),
      'isDirect': isDirect,
      'durationMinutes': duration.inMinutes,
      'totalPriceCop': totalPriceCop,
      'availableSeats': availableSeats,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory FlightModel.fromMap(String id, Map<String, dynamic> map) {
    return FlightModel(
      id: id,
      airline: map['airline'],
      flightNumber: map['flightNumber'],
      originCity: map['originCity'],
      originIata: map['originIata'],
      destinationCity: map['destinationCity'],
      destinationIata: map['destinationIata'],
      departureDateTime: parseDateTime(map['departureDateTime']),
      arrivalDateTime: parseDateTime(map['arrivalDateTime']),
      isDirect: map['isDirect'] ?? true,
      duration: Duration(minutes: map['durationMinutes']),
      totalPriceCop: map['totalPriceCop'],
      availableSeats: map['availableSeats'],
      createdAt: map['createdAt'] != null
          ? parseDateTime(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? parseDateTime(map['updatedAt'])
          : null,
    );
  }

  factory FlightModel.fromEntity(Flight flight) {
    return FlightModel(
      id: flight.id,
      airline: flight.airline,
      flightNumber: flight.flightNumber,
      originCity: flight.originCity,
      originIata: flight.originIata,
      destinationCity: flight.destinationCity,
      destinationIata: flight.destinationIata,
      departureDateTime: flight.departureDateTime,
      arrivalDateTime: flight.arrivalDateTime,
      isDirect: flight.isDirect,
      duration: flight.duration,
      totalPriceCop: flight.totalPriceCop,
      availableSeats: flight.availableSeats,
      createdAt: flight.createdAt,
      updatedAt: flight.updatedAt,
    );
  }
}
