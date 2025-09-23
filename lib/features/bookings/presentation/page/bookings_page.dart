import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:next_trip/core/widgets/page_layout.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (FirebaseAuth.instance.currentUser == null && mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
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

  Widget flightBookings() {
    return Column(
      children: [
        FlightBookingCard(
          date: '01 Octubre, 2025',
          fromTo: 'BAQ - BOG',
          status: 'Completado',
          flightNumber: 'DL401',
          flightDate: '01 Oct. 2025',
        ),
        FlightBookingCard(
          date: '15 Noviembre, 2025',
          fromTo: 'BOG - MDE',
          status: 'En curso',
          flightNumber: 'AV123',
          flightDate: '15 Nov. 2025',
        ),
        FlightBookingCard(
          date: '20 Diciembre, 2025',
          fromTo: 'MDE - BAQ',
          status: 'Cancelado',
          flightNumber: 'LA456',
          flightDate: '20 Dic. 2025',
        ),
      ],
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
        content(),
      ],
    );
  }
}
