import 'package:flutter/material.dart';
import 'package:next_trip/routes/app_routes.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildNavItem(context, Icons.flight, 0),
              buildNavItem(context, Icons.hotel, 1),
              buildNavItem(context, Icons.directions_car, 2),
              buildNavItem(context, Icons.event, 3),
              // buildNavItem(context, Icons.person, 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavItem(BuildContext context, IconData icon, int index) {
    final isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () {
        onItemTapped(index);
        navigateToPage(context, index);
      },
      child: Icon(
        icon,
        size: 28,
        color: isSelected ? Colors.white : Colors.grey[700],
      ),
    );
  }

  void navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0: // Flights
        if (ModalRoute.of(context)?.settings.name != AppRoutes.flights) {
          Navigator.pushReplacementNamed(context, AppRoutes.flights);
        }
        break;
      case 1: // Hotels
        if (ModalRoute.of(context)?.settings.name != AppRoutes.hotels) {
          Navigator.pushReplacementNamed(context, AppRoutes.hotels);
        }
        break;
      case 2: // Cars
        if (ModalRoute.of(context)?.settings.name != AppRoutes.cars) {
          Navigator.pushReplacementNamed(context, AppRoutes.cars);
        }
        break;
      case 3: // Bookings
        if (ModalRoute.of(context)?.settings.name != AppRoutes.bookings) {
          Navigator.pushReplacementNamed(context, AppRoutes.bookings);
        }
        break;
      case 4: // Profile
        if (ModalRoute.of(context)?.settings.name != AppRoutes.profile) {
          Navigator.pushReplacementNamed(context, AppRoutes.profile);
        }
        break;
    }
  }
}
