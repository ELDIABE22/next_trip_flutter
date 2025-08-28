import 'package:flutter/material.dart';
import 'package:next_trip/features/auth/presentation/page/login_page.dart';
import 'package:next_trip/features/auth/presentation/page/register_page.dart';
import 'package:next_trip/features/bookings/presentation/page/bookings_page.dart';
import 'package:next_trip/features/cars/presentation/pages/car_search_page.dart';
import 'package:next_trip/features/flights/presentation/pages/flight_search_page.dart';
import 'package:next_trip/features/home/presentation/page/home_page.dart';
import 'package:next_trip/features/hotels/presentation/page/hotel_search_page.dart';
import 'package:next_trip/routes/app_routes.dart';

class AppPages {
  static Map<String, WidgetBuilder> routes = {
    AppRoutes.home: (context) => const HomePage(),
    AppRoutes.login: (context) => const LoginPage(),
    AppRoutes.register: (context) => const RegisterPage(),
    AppRoutes.flights: (context) => const FlightSearchPage(),
    AppRoutes.hotels: (context) => const HotelSearchPage(),
    AppRoutes.cars: (context) => const CarSearchPage(),
    AppRoutes.bookings: (context) => const BookingsPage(),
    // AppRoutes.profile: (context) => const ProfilePage(),
  };
}
