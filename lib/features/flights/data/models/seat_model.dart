import 'package:cloud_firestore/cloud_firestore.dart';

enum SeatStatus { available, selected, unavailable }

class Seat {
  final String id;
  final int row;
  final String column;
  SeatStatus status;
  bool isAvailable;

  Seat({
    required this.id,
    required this.row,
    required this.column,
    this.status = SeatStatus.available,
    this.isAvailable = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'row': row,
      'column': column,
      'status': status.name,
      'isAvailable': isAvailable,
    };
  }

  factory Seat.fromMap(Map<String, dynamic> map) {
    return Seat(
      id: map['id'] ?? '',
      row: map['row'] ?? 0,
      column: map['column'] ?? '',
      status: SeatStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => SeatStatus.available,
      ),
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  static List<Seat> generateSeats({int rows = 5, List<String>? columns}) {
    final cols = columns ?? ['A', 'B', 'C', 'D'];
    List<Seat> seats = [];

    for (int row = 1; row <= rows; row++) {
      for (String col in cols) {
        seats.add(Seat(id: '$row$col', row: row, column: col));
      }
    }

    return seats;
  }

  static Future<void> createFlightWithSeats(String flightId) async {
    final db = FirebaseFirestore.instance;

    await db.collection('flights').doc(flightId).set({
      'idFlight': flightId,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    List<Seat> seats = Seat.generateSeats();

    await db.collection('seats').doc(flightId).set({
      'idFlight': flightId,
      'seats': seats.map((s) => s.toMap()).toList(),
    });
  }
}
