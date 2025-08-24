import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:next_trip/features/flights/presentation/pages/flight_search_page.dart';
import 'package:next_trip/features/hotels/presentation/page/hotel_search_page.dart';
import 'package:next_trip/features/cars/presentation/pages/car_search_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.promptTextTheme()),
      initialRoute: '/flights',
      routes: {
        '/flights': (context) => const FlightSearchPage(),
        '/hotels': (context) => const HotelSearchPage(),
        '/cars': (context) => const CarSearchPage(),
        // '/reservations': (context) => const ActivitiesPage(),
        // '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
