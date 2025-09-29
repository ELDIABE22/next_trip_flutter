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

  /// Duración en horas (para filtros)
  double get durationInHours => duration.inMinutes / 60.0;

  /// Precio formateado
  String get totalPriceLabelCop {
    final formatter = NumberFormat("#,###", "es_CO");
    return formatter.format(totalPriceCop);
  }

  /// Fecha formateada
  String get departureDateFormatted {
    return DateFormat('dd/MM/yyyy').format(departureDateTime);
  }

  /// Día de la semana
  String get departureWeekday {
    final weekdays = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    return weekdays[departureDateTime.weekday - 1];
  }

  /// Status del vuelo basado en la hora actual
  String get flightStatus {
    final now = DateTime.now();
    if (now.isBefore(departureDateTime)) {
      return 'Programado';
    } else if (now.isAfter(departureDateTime) &&
        now.isBefore(arrivalDateTime)) {
      return 'En vuelo';
    } else {
      return 'Aterrizado';
    }
  }

  /// Tiempo hasta la salida
  String get timeUntilDeparture {
    final now = DateTime.now();
    final difference = departureDateTime.difference(now);

    if (difference.isNegative) return 'Ya partió';

    final days = difference.inDays;
    final hours = difference.inHours.remainder(24);
    final minutes = difference.inMinutes.remainder(60);

    if (days > 0) return 'En ${days}d ${hours}h';
    if (hours > 0) return 'En ${hours}h ${minutes}m';
    return 'En ${minutes}m';
  }

  /// Información de escalas
  String get connectionInfo {
    return (isDirect ?? true) ? 'Vuelo directo' : 'Con escalas';
  }

  /// Verifica si es un vuelo de madrugada
  bool get isEarlyMorningFlight {
    final hour = departureDateTime.hour;
    return hour >= 0 && hour < 6;
  }

  /// Verifica si es un vuelo nocturno
  bool get isNightFlight {
    final hour = departureDateTime.hour;
    return hour >= 22 || hour < 6;
  }

  /// Categoría de precio (económico, medio, caro)
  String get priceCategory {
    if (totalPriceCop < 150000) return 'Económico';
    if (totalPriceCop < 500000) return 'Medio';
    return 'Premium';
  }

  /// Disponibilidad de asientos como texto
  String get availabilityText {
    if (availableSeats == null) return 'Disponibilidad no especificada';
    if (availableSeats! <= 0) return 'Sin disponibilidad';
    if (availableSeats! <= 5) return 'Pocos asientos disponibles';
    return 'Disponible';
  }

  /// Color para mostrar disponibilidad
  String get availabilityColor {
    if (availableSeats == null || availableSeats! <= 0) return 'red';
    if (availableSeats! <= 5) return 'orange';
    return 'green';
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Flight && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Flight{id: $id, airline: $airline, route: $routeTitle, departure: $departureTimeStr, price: $totalPriceLabelCop}';
  }
}
