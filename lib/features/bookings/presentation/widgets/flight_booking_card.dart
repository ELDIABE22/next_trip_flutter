import 'package:flutter/material.dart';
import 'package:next_trip/core/utils/helpers.dart';
import 'package:next_trip/features/bookings/data/models/flight_booking_model.dart';
import 'package:next_trip/features/bookings/presentation/page/booking_details_flight.dart';

class FlightBookingCard extends StatelessWidget {
  final FlightBooking booking;

  const FlightBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (booking.status) {
      case BookingStatus.completed:
        statusColor = const Color(0xFF4CAF50);
        break;
      case BookingStatus.cancelled:
        statusColor = const Color(0xFFF44336);
        break;
      case BookingStatus.pending:
        statusColor = const Color(0xFFFF9800);
        break;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingDetailsFlight(booking: booking),
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
            // header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: Color(0XFF8F8F8F)),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.flight,
                      color: Color(0xFF2196F3),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 17),
                  Expanded(
                    child: Text(
                      '${booking.flight.originIata} - ${booking.flight.destinationIata}',
                      style: const TextStyle(
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
                      getStatusTextFlightBooking(booking.status.name),
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
            // body
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    booking.flight.flightNumber ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    formatDateWithDayMonthYear(
                      booking.flight.departureDateTime,
                    ),
                    style: const TextStyle(fontSize: 15, color: Colors.white),
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
