import 'package:flutter/material.dart';
import 'package:next_trip/features/flights/presentation/pages/flight_seats_page.dart';

class FlightCard extends StatelessWidget {
  final String total;
  final String? passengersText;
  final String? flightDate;

  const FlightCard({
    super.key,
    this.passengersText,
    this.flightDate,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (passengersText == null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FlightSeatsPage()),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  // Departure
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          '04:41',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'BAQ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Flight Info
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 45,
                              height: 1,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                            const Icon(
                              Icons.flight,
                              color: Colors.green,
                              size: 16,
                            ),
                            Container(
                              width: 45,
                              height: 1,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Directo',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text('1h 33m', style: TextStyle(fontSize: 12)),
                        if (flightDate != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            flightDate!,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Arrival
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          '06:14',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'BOG',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 25),
              decoration: BoxDecoration(
                color: const Color(0xFFEFECEC),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        passengersText ?? 'Desde',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey[600],
                        ),
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  'COP',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                total,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          if (passengersText == null) ...[
                            SizedBox(width: 10),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
