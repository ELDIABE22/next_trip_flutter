import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/page_layout.dart';
import 'package:next_trip/features/hotels/presentation/widgets/hotelSearchPage/hotel_card.dart';

class HotelSearchPage extends StatefulWidget {
  const HotelSearchPage({super.key});

  @override
  State<HotelSearchPage> createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage> {
  int selectedIndex = 1;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      titleHeader: 'HOSPEDAJE',
      title:
          'Tu descanso ideal comienza aquí: encuentra y reserva el hospedaje perfecto para tu viaje.',
      selectedIndex: selectedIndex,
      onItemTapped: onItemTapped,
      children: [
        Column(
          children: [
            HotelCard(),
            SizedBox(height: 20),
            HotelCard(),
            SizedBox(height: 20),
            HotelCard(),
            SizedBox(height: 20),
          ],
        ),
      ],
    );
  }
}
