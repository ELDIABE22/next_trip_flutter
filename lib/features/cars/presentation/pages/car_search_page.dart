import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/page_layout.dart';

class CarSearchPage extends StatefulWidget {
  const CarSearchPage({super.key});

  @override
  State<CarSearchPage> createState() => _CarSearchPageState();
}

class _CarSearchPageState extends State<CarSearchPage> {
  int selectedIndex = 2;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Tu movilidad comienza aquí: encuentra y reserva el vehículo perfecto para tu viaje.',
      selectedIndex: selectedIndex,
      onItemTapped: onItemTapped,
      child: Text("Carros"),
    );
  }
}
