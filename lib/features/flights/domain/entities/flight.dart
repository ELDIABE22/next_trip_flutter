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
