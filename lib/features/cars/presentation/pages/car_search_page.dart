import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/page_layout.dart';
import 'package:next_trip/features/cars/presentation/widgets/carSearchPage/car_card.dart';
import 'package:next_trip/features/cars/presentation/widgets/carSearchPage/car_search_form.dart';

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
      title:
          'Tu aventura sobre ruedas comienza aquí: elige y reserva tu carro ideal',
      selectedIndex: selectedIndex,
      onItemTapped: onItemTapped,
      children: [
        CarSearchForm(),
        const SizedBox(height: 20),
        Column(
          children: List.generate(
            5,
            (index) => Column(children: [CarCard(), SizedBox(height: 20)]),
          ),
        ),
      ],
    );
  }
}
