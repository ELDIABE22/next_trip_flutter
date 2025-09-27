import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:next_trip/features/auth/presentation/page/login_page.dart';
import 'package:next_trip/features/auth/presentation/page/register_page.dart';
import 'package:next_trip/features/bookings/presentation/page/bookings_page.dart';
import 'package:next_trip/features/cars/presentation/pages/car_search_page.dart';
import 'package:next_trip/features/destinations/presentation/pages/search_country_page.dart';
import 'package:next_trip/features/flights/presentation/pages/flight_search_page.dart';
import 'package:next_trip/features/home/presentation/page/home_page.dart';
import 'package:next_trip/features/hotels/presentation/page/hotel_search_page.dart';
import 'package:next_trip/routes/app_routes.dart';

class AppPages {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case AppRoutes.login:
        if (isLoggedIn) {
          return MaterialPageRoute(builder: (_) => const SearchCountryPage());
        }
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.register:
        if (isLoggedIn) {
          return MaterialPageRoute(builder: (_) => const SearchCountryPage());
        }
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case AppRoutes.flights:
        return MaterialPageRoute(builder: (_) => const FlightSearchPage());

      case AppRoutes.hotels:
        return MaterialPageRoute(builder: (_) => const HotelSearchPage());

      case AppRoutes.cars:
        return MaterialPageRoute(builder: (_) => const CarSearchPage());

      case AppRoutes.bookings:
        if (!isLoggedIn) {
          return MaterialPageRoute(builder: (_) => const LoginPage());
        }
        return MaterialPageRoute(builder: (_) => const BookingsPage());

      case AppRoutes.profile:
        if (!isLoggedIn) {
          return MaterialPageRoute(builder: (_) => const LoginPage());
        }
        return MaterialPageRoute(builder: (_) => const SearchCountryPage());

      case AppRoutes.searchCountry:
        return MaterialPageRoute(builder: (_) => const SearchCountryPage());

      default:
        return MaterialPageRoute(builder: (_) => const SearchCountryPage());
    }
  }
}
