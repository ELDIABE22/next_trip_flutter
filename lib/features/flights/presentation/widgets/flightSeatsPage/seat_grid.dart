import 'package:flutter/material.dart';
import 'package:next_trip/features/flights/data/models/seat.dart';

class SeatGrid extends StatefulWidget {
  const SeatGrid({super.key});

  @override
  State<SeatGrid> createState() => _SeatGridState();
}

class _SeatGridState extends State<SeatGrid> {
  List<List<Seat>> seatGrid = [
    [
      'A',
      'B',
      'C',
      'D',
    ].map((col) => Seat(id: '${col}1', status: SeatStatus.available)).toList(),
    [
      'A',
      'B',
      'C',
      'D',
    ].map((col) => Seat(id: '${col}2', status: SeatStatus.available)).toList(),
    ['A', 'B', 'C', 'D']
        .map((col) => Seat(id: '${col}3', status: SeatStatus.unavailable))
        .toList(),
    [
      'A',
      'B',
      'C',
      'D',
    ].map((col) => Seat(id: '${col}4', status: SeatStatus.available)).toList(),
    [
      'A',
      'B',
      'C',
      'D',
    ].map((col) => Seat(id: '${col}5', status: SeatStatus.available)).toList(),
    ['A', 'B', 'C', 'D']
        .map((col) => Seat(id: '${col}6', status: SeatStatus.unavailable))
        .toList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
                    textAlign: TextAlign.start,
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

          // Grid de asientos
          ...seatGrid.asMap().entries.map((entry) {
            int rowIndex = entry.key;
            List<Seat> row = entry.value;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  // Número de fila
                  SizedBox(
                    width: 40,
                    child: Text(
                      '${rowIndex + 1}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  // Asientos
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: row.map((seat) {
                        return GestureDetector(
                          onTap: () {
                            if (seat.status == SeatStatus.available) {
                              setState(() {
                                seat.status = SeatStatus.selected;
                              });
                            } else if (seat.status == SeatStatus.selected) {
                              setState(() {
                                seat.status = SeatStatus.available;
                              });
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
                              boxShadow: seat.status == SeatStatus.selected
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.2,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: seat.status == SeatStatus.selected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : seat.status == SeatStatus.unavailable
                                ? Icon(
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
