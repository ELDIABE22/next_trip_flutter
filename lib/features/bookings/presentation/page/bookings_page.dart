import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/page_layout.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  int selectedIndex = 3;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      titleHeader: 'MIS RESERVAS',
      title:
          'Revive tus experiencias: encuentra todas tus reservas en un solo lugar.',
      selectedIndex: selectedIndex,
      onItemTapped: onItemTapped,
      children: [Text("Historial de Reservas - Vuelos")],
    );
  }
}
