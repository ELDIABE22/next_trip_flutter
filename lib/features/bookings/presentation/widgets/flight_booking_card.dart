import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:next_trip/core/utils/helpers.dart';
import 'package:next_trip/features/bookings/domain/entities/flight_booking.dart';
import 'package:next_trip/features/bookings/infrastructure/models/flight_booking_model.dart';
import 'package:next_trip/features/bookings/presentation/page/booking_details_flight.dart';

class FlightBookingCard extends StatelessWidget {
  final FlightBookingModel booking;

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

    final isRoundTripBooking = booking.isRoundTrip == true;
    final tripTypeLabel = booking.tripTypeLabel;

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
          border: isRoundTripBooking
              ? Border.all(color: Colors.blue.withValues(alpha: 0.5), width: 2)
              : null,
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
            // Header con indicador de tipo de viaje
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: Color(0XFF8F8F8F)),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isRoundTripBooking
                              ? Colors.blue.withValues(alpha: 0.2)
                              : Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          isRoundTripBooking ? Icons.swap_horiz : Icons.flight,
                          color: const Color(0xFF2196F3),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 17),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${booking.flight.originIata} - ${booking.flight.destinationIata}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            if (isRoundTripBooking)
                              Text(
                                tripTypeLabel,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
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

                  if (isRoundTripBooking && booking.totalRoundTripPrice != null)
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Total ida y vuelta: ${NumberFormat("#,###", "es_CO").format(booking.totalRoundTripPrice)} COP',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Body
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatDateWithDayMonthYear(
                          booking.flight.departureDateTime,
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      if (isRoundTripBooking &&
                          booking.relatedBookingId != null)
                        Text(
                          'Ver reserva completa',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue[300],
                          ),
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
