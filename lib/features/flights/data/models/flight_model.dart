import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:next_trip/core/utils/helpers.dart';

class Flight {
  final String id;
  final String? airline;
  final String? flightNumber;

  final String originCity;
  final String originIata;
  final String destinationCity;
  final String destinationIata;

  final DateTime departureDateTime;
  final DateTime arrivalDateTime;

  final bool? isDirect;
  final Duration duration;

  final int totalPriceCop;

  final int? availableSeats;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Flight({
    required this.id,
    this.airline,
    this.flightNumber,
    required this.originCity,
    required this.originIata,
    required this.destinationCity,
    required this.destinationIata,
    required this.departureDateTime,
    required this.arrivalDateTime,
    this.isDirect = true,
    required this.duration,
    required this.totalPriceCop,
    this.availableSeats,
    this.createdAt,
    this.updatedAt,
  });

  /// Texto para encabezado: "Bogotá a Barranquilla"
  String get routeTitle => '$originCity a $destinationCity';

  /// Hora de salida/llegada en formato HH:mm
  String get departureTimeStr =>
      formatTimeWithAmPm(departureDateTime.toLocal());
  String get arrivalTimeStr => formatTimeWithAmPm(arrivalDateTime.toLocal());

  /// Duración formateada como "1h 33m"
  String get durationLabel {
    final h = duration.inHours;
    final m = duration.inMinutes.remainder(60);
    if (h > 0 && m > 0) return '${h}h ${m}m';
    if (h > 0) return '${h}h';
    return '${m}m';
  }

  /// Precio formateado
  String get totalPriceLabelCop {
    final formatter = NumberFormat("#,###", "es_CO");
    return formatter.format(totalPriceCop);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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

  factory Flight.fromMap(String id, Map<String, dynamic> map) {
    return Flight(
      id: id,
      airline: map['airline'] as String?,
      flightNumber: map['flightNumber'] as String?,
      originCity: map['originCity'] as String,
      originIata: map['originIata'] as String,
      destinationCity: map['destinationCity'] as String,
      destinationIata: map['destinationIata'] as String,
      departureDateTime: (map['departureDateTime'] as Timestamp).toDate(),
      arrivalDateTime: (map['arrivalDateTime'] as Timestamp).toDate(),
      isDirect: map['isDirect'] as bool? ?? true,
      duration: Duration(minutes: (map['durationMinutes'] as num).toInt()),
      totalPriceCop: (map['totalPriceCop'] as num).toInt(),
      availableSeats: (map['availableSeats'] as num?)?.toInt(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Flight copyWith({
    String? airline,
    String? flightNumber,
    String? originCity,
    String? originIata,
    String? destinationCity,
    String? destinationIata,
    DateTime? departureDateTime,
    DateTime? arrivalDateTime,
    bool? isDirect,
    Duration? duration,
    int? totalPriceCop,
    int? availableSeats,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Flight(
      id: id,
      airline: airline ?? this.airline,
      flightNumber: flightNumber ?? this.flightNumber,
      originCity: originCity ?? this.originCity,
      originIata: originIata ?? this.originIata,
      destinationCity: destinationCity ?? this.destinationCity,
      destinationIata: destinationIata ?? this.destinationIata,
      departureDateTime: departureDateTime ?? this.departureDateTime,
      arrivalDateTime: arrivalDateTime ?? this.arrivalDateTime,
      isDirect: isDirect ?? this.isDirect,
      duration: duration ?? this.duration,
      totalPriceCop: totalPriceCop ?? this.totalPriceCop,
      availableSeats: availableSeats ?? this.availableSeats,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
