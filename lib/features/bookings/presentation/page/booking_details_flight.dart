import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/utils/helpers.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/features/bookings/data/models/flight_booking_model.dart';

class BookingDetailsFlight extends StatelessWidget {
  final FlightBooking booking;

  const BookingDetailsFlight({super.key, required this.booking});

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

    return Scaffold(
      appBar: Appbar(title: 'Detalles del ticket'),
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        decoration: AppConstantsColors.radialBackground,
        child: Column(
          children: [
            // Logo y nombre de la APP
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFFF6F3F3),
                borderRadius: BorderRadius.circular(15),
                border: Border(bottom: BorderSide(width: 1)),
              ),
              width: double.infinity,
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo-app-black.webp',
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                      ),

                      SizedBox(height: 5),

                      Text(
                        "NEXTRIP",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(
                                  Icons.airline_seat_recline_normal,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Pasajero${booking.passengers.length > 1 ? 's' : ''}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10),

                          ...booking.passengers.map(
                            (passenger) => Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                passenger.fullName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 7,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: statusColor.withValues(alpha: 0.2),
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
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFFF6F3F3),
                borderRadius: BorderRadius.circular(15),
                border: Border(bottom: BorderSide(width: 1)),
              ),
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatTimeWithAmPm(
                              booking.flight.departureDateTime.toLocal(),
                            ),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            booking.flight.originCity,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatTimeWithAmPm(
                              booking.flight.arrivalDateTime.toLocal(),
                            ),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            booking.flight.destinationCity,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo-app-black.webp',
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                      ),

                      SizedBox(height: 5),

                      Text(
                        booking.flight.durationLabel,
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "FECHA",
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                          Text(
                            formatDateTimeWithMonthDayTime(
                              booking.flight.departureDateTime,
                            ),
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "FECHA",
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                          Text(
                            formatDateTimeWithMonthDayTime(
                              booking.flight.arrivalDateTime,
                            ),
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFFF6F3F3),
                borderRadius: BorderRadius.circular(15),
              ),
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFF8F8F8F)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Vuelo",
                              style: TextStyle(
                                color: Color(0xFF8F8F8F),
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              booking.flight.flightNumber ?? 'N/A',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Puesto${booking.seats.length > 1 ? 's' : ''}",
                              style: TextStyle(
                                color: Color(0xFF8F8F8F),
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              booking.seats
                                  .map((seat) => '${seat.row}${seat.column}')
                                  .join(', '),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total:",
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          booking.totalPriceLabel,
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
