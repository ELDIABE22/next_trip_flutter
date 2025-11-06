import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:next_trip/features/flights/domain/entities/seat.dart';
import 'package:next_trip/features/flights/infrastructure/models/seat_model.dart';

class SeatGrid extends StatefulWidget {
  final String flightId;
  final void Function(List<Seat>) onSelectionChanged;

  const SeatGrid({
    super.key,
    required this.flightId,
    required this.onSelectionChanged,
  });

  @override
  State<SeatGrid> createState() => _SeatGridState();
}

class _SeatGridState extends State<SeatGrid> {
  List<SeatModel> seats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSeats();
  }

  Future<void> _loadSeats() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("flights")
          .doc(widget.flightId)
          .collection("seats")
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          seats = snapshot.docs
              .map((doc) => SeatModel.fromMap(doc.id, doc.data()))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar asientos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _toggleSeat(Seat seat) {
    final selectedSeats = seats
        .where((s) => s.status == SeatStatus.selected)
        .length;

    if (seat.status == SeatStatus.available) {
      if (selectedSeats >= 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Solo puedes seleccionar hasta 5 asientos por reserva',
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      setState(() {
        int index = seats.indexWhere((s) => s.id == seat.id);
        if (index != -1) {
          seats[index] = SeatModel(
            id: seat.id,
            row: seat.row,
            column: seat.column,
            status: SeatStatus.selected,
          );
        }
      });
    } else if (seat.status == SeatStatus.selected) {
      setState(() {
        int index = seats.indexWhere((s) => s.id == seat.id);
        if (index != -1) {
          seats[index] = SeatModel(
            id: seat.id,
            row: seat.row,
            column: seat.column,
            status: SeatStatus.available,
          );
        }
      });
    }

    widget.onSelectionChanged(
      seats.where((s) => s.status == SeatStatus.selected).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (seats.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.airline_seat_recline_normal,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No hay asientos disponibles',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    final groupedSeats = <int, List<Seat>>{};
    for (var seat in seats) {
      groupedSeats.putIfAbsent(seat.row, () => []).add(seat);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 100),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 40),
              ...['A', 'B', 'C', 'D'].map(
                (letter) => SizedBox(
                  width: 40,
                  child: Text(
                    letter,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...groupedSeats.entries.map((entry) {
            int row = entry.key;
            List<Seat> rowSeats = entry.value;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Text(
                      "$row",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: rowSeats.map((seat) {
                        return GestureDetector(
                          onTap: () {
                            if (seat.status != SeatStatus.unavailable) {
                              _toggleSeat(seat);
                            }
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: seat.status == SeatStatus.selected
                                  ? Colors.black
                                  : seat.status == SeatStatus.unavailable
                                  ? Colors.red.shade300
                                  : Colors.green.shade50,
                              border: Border.all(
                                color: seat.status == SeatStatus.selected
                                    ? Colors.black
                                    : seat.status == SeatStatus.unavailable
                                    ? Colors.red.shade600
                                    : Colors.green,
                                width: 2,
                              ),
                            ),
                            child: seat.status == SeatStatus.selected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : seat.status == SeatStatus.unavailable
                                ? const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 18,
                                  )
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
