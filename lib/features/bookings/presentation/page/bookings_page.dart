import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:next_trip/core/utils/helpers.dart';
import 'package:next_trip/core/widgets/page_layout.dart';
import 'package:next_trip/features/bookings/data/controllers/flight_booking_controller.dart';
import 'package:next_trip/features/bookings/data/models/flight_booking_model.dart';
import 'package:next_trip/features/bookings/presentation/widgets/booking_tabs.dart';
import 'package:next_trip/features/bookings/presentation/widgets/flight_booking_card.dart';
import 'package:next_trip/features/bookings/presentation/widgets/hotel_booking_card.dart';
import 'package:next_trip/features/bookings/presentation/widgets/car_booking_card.dart';
import 'package:next_trip/routes/app_routes.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  int selectedIndex = 3;
  int selectedTabIndex = 0;

  final FlightBookingController _controller = FlightBookingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (FirebaseAuth.instance.currentUser == null && mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      } else {
        final userId = FirebaseAuth.instance.currentUser!.uid;
        await _controller.fetchUserBookings(userId);
      }
    });
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void onTabChanged(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  Widget content() {
    switch (selectedTabIndex) {
      case 0:
        return flightBookings();
      case 1:
        return hotelBookings();
      case 2:
        return carBookings();
      default:
        return flightBookings();
    }
  }

  Map<String, List<FlightBooking>> _groupBookingsByDate(
    List<FlightBooking> bookings,
  ) {
    final grouped = <String, List<FlightBooking>>{};
    final dateMap = <String, DateTime>{};

    for (var booking in bookings) {
      final dateTime = booking.flight.departureDateTime;

      final dateKey = formatDateFullMonth(dateTime);

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
        dateMap[dateKey] = dateTime;
      }
      grouped[dateKey]!.add(booking);
    }

    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => dateMap[b]!.compareTo(dateMap[a]!));

    return Map.fromEntries(
      sortedKeys.map((key) => MapEntry(key, grouped[key]!)),
    );
  }

  Widget flightBookings() {
    if (_controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.error != null) {
      return Center(child: Text(_controller.error!));
    }

    if (_controller.bookings.isEmpty) {
      return const Center(child: Text('No tienes reservas de vuelos.'));
    }

    final groupedBookings = _groupBookingsByDate(_controller.bookings);

    return Column(
      children: groupedBookings.entries.map((entry) {
        final date = entry.key;
        final bookings = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 218, 218),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black,
                    ),
                    child: Text(
                      date.split(' ')[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${date.split(' ')[1]} ${date.split(' ')[2]}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            ...bookings.map((booking) {
              return FlightBookingCard(booking: booking);
            }),

            const SizedBox(height: 10),
          ],
        );
      }).toList(),
    );
  }

  Widget hotelBookings() {
    return Column(
      children: [
        HotelBookingCard(
          date: '10 Noviembre, 2025',
          hotelName: 'Hotel Dann Carlton',
          status: 'Cancelado',
          duration: '6 DÍAS',
          dateRange: '10 Nov. 2025 - 16 Nov. 2025',
        ),
        HotelBookingCard(
          date: '25 Diciembre, 2025',
          hotelName: 'Hotel Intercontinental',
          status: 'Completado',
          duration: '3 DÍAS',
          dateRange: '25 Dic. 2025 - 28 Dic. 2025',
        ),
        HotelBookingCard(
          date: '15 Enero, 2026',
          hotelName: 'Hotel Hilton',
          status: 'En curso',
          duration: '5 DÍAS',
          dateRange: '15 Ene. 2026 - 20 Ene. 2026',
        ),
      ],
    );
  }

  Widget carBookings() {
    return Column(
      children: [
        CarBookingCard(
          date: '01 Octubre, 2025',
          carModel: 'Hyundai Tucson',
          status: 'En curso',
          duration: '10 DÍAS',
          dateRange: '01 Oct. 2025 - 10 Oct. 2025',
        ),
        CarBookingCard(
          date: '20 Noviembre, 2025',
          carModel: 'Toyota Corolla',
          status: 'Completado',
          duration: '7 DÍAS',
          dateRange: '20 Nov. 2025 - 27 Nov. 2025',
        ),
        CarBookingCard(
          date: '05 Diciembre, 2025',
          carModel: 'Nissan Sentra',
          status: 'Cancelado',
          duration: '4 DÍAS',
          dateRange: '05 Dic. 2025 - 09 Dic. 2025',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      titleHeader: 'MIS RESERVAS',
      title:
          'Revive tus experiencias: encuentra todas tus reservas en un solo lugar.',
      selectedIndex: selectedIndex,
      onItemTapped: onItemTapped,
      children: [
        BookingTabs(
          selectedTabIndex: selectedTabIndex,
          onTabChanged: onTabChanged,
        ),
        const SizedBox(height: 20),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return content();
          },
        ),
      ],
    );
  }
}
