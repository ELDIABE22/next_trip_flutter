import '../../domain/entities/seat.dart';

class SeatModel extends Seat {
  SeatModel({
    required super.id,
    required super.row,
    required super.column,
    super.status = SeatStatus.available,
    super.isAvailable = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'row': row,
      'column': column,
      'status': status.name,
      'isAvailable': isAvailable,
    };
  }

  factory SeatModel.fromMap(String id, Map<String, dynamic> map) {
    return SeatModel(
      id: id,
      row: map['row'],
      column: map['column'],
      status: SeatStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => SeatStatus.available,
      ),
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  factory SeatModel.fromEntity(Seat seat) {
    return SeatModel(
      id: seat.id,
      row: seat.row,
      column: seat.column,
      status: seat.status,
      isAvailable: seat.isAvailable,
    );
  }
}

