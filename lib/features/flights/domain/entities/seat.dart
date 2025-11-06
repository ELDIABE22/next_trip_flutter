enum SeatStatus { available, selected, unavailable }

class Seat {
  final String id;
  final int row;
  final String column;
  final SeatStatus status;
  final bool isAvailable;

  Seat({
    required this.id,
    required this.row,
    required this.column,
    this.status = SeatStatus.available,
    this.isAvailable = true,
  });

  Seat copyWith({
    int? row,
    String? column,
    SeatStatus? status,
    bool? isAvailable,
  }) {
    return Seat(
      id: id,
      row: row ?? this.row,
      column: column ?? this.column,
      status: status ?? this.status,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
