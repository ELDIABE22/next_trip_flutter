import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/custom_navbar.dart';
import 'package:next_trip/core/widgets/header.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/flight_result.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/flight_search_form.dart';

class FlightSearchPage extends StatefulWidget {
  const FlightSearchPage({super.key});

  @override
  State<FlightSearchPage> createState() => _FlightSearchPageState();
}

class _FlightSearchPageState extends State<FlightSearchPage> {
  bool isOneWay = true;
  int passengers = 2;
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Header(),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Tu viaje comienza aquí: elige y reserva tu vuelo',
                        style: TextStyle(
                          color: const Color(0x99000000),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      FlightSearchForm(),

                      const SizedBox(height: 20),

                      FlightResult(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: CustomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}
