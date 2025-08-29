import 'package:flutter/material.dart';
import 'package:next_trip/features/bookings/presentation/page/booking_details_hotel.dart';

class HotelBookingCard extends StatelessWidget {
  final String date;
  final String hotelName;
  final String status;
  final String duration;
  final String dateRange;

  const HotelBookingCard({
    super.key,
    required this.date,
    required this.hotelName,
    required this.status,
    required this.duration,
    required this.dateRange,
  });

  Map<String, String> _parseDate(String date) {
    final parts = date.split(' ');
    if (parts.length >= 3) {
      final day = parts[0];
      final month = parts[1].replaceAll(',', '');
      final year = parts[2];
      return {'day': day, 'monthYear': '$month, $year'};
    }
    return {'day': '01', 'monthYear': 'Enero, 2025'};
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'completado':
        statusColor = const Color(0xFF4CAF50);
        break;
      case 'cancelado':
        statusColor = const Color(0xFFF44336);
        break;
      case 'en curso':
        statusColor = const Color(0xFFFF9800);
        break;
      default:
        statusColor = Colors.grey;
    }

    final dateInfo = _parseDate(date);

    return Column(
      children: [
        // Date
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFDADADA),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black,
                ),
                child: SizedBox(
                  child: Text(
                    dateInfo['day']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10),

              Text(
                dateInfo['monthYear']!,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 10),

        // Card
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BookingDetailsHotel(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: Color(0XFF8F8F8F)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.hotel,
                          color: Colors.purple,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 17),
                      Expanded(
                        child: Text(
                          hotelName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        duration,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        dateRange,
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 10),
      ],
    );
  }
}
