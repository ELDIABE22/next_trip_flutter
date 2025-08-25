import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:next_trip/features/auth/presentation/page/login_page.dart';
import 'package:next_trip/features/auth/presentation/page/register_page.dart';
import 'package:next_trip/features/flights/presentation/pages/flight_search_page.dart';
import 'package:next_trip/features/hotels/presentation/page/hotel_search_page.dart';
import 'package:next_trip/features/cars/presentation/pages/car_search_page.dart';
import 'package:next_trip/features/home/presentation/page/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.promptTextTheme()),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/flights': (context) => const FlightSearchPage(),
        '/hotels': (context) => const HotelSearchPage(),
        '/cars': (context) => const CarSearchPage(),
        // '/reservations': (context) => const ActivitiesPage(),
        // '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
