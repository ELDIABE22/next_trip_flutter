import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/custom_button.dart';
import 'package:next_trip/features/destinations/presentation/pages/search_country_page.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/input_field.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/trip_type_buttont.dart';

class FlightSearchForm extends StatefulWidget {
  const FlightSearchForm({super.key});

  @override
  State<FlightSearchForm> createState() => _FlightSearchFormState();
}

class _FlightSearchFormState extends State<FlightSearchForm> {
  bool isOneWay = true;
  int passengers = 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFEFECEC),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trip Type Selector
          Row(
            children: [
              Expanded(
                child: TripTypeButtont(
                  text: 'Solo ida',
                  isSelected: isOneWay,
                  icon: Icons.arrow_forward,
                  onTap: () => setState(() => isOneWay = true),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: TripTypeButtont(
                  text: 'Ida y vuelta',
                  isSelected: !isOneWay,
                  icon: Icons.swap_horiz,
                  onTap: () => setState(() => isOneWay = false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          // Input Fields
          Row(
            children: [
              Expanded(
                child: InputField(
                  label: 'Origen',
                  value: 'Barranquilla',
                  icon: Icons.flight_takeoff,
                  enabled: true,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchCountryPage(),
                      ),
                    );
                  },
                  child: InputField(
                    label: 'Destino',
                    value: 'Bogotá',
                    icon: Icons.flight_land,
                    enabled: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          isOneWay
              ? InputField(
                  label: 'Ida',
                  value: '01/09/2025',
                  icon: Icons.calendar_today,
                  enabled: true,
                )
              : Row(
                  children: [
                    Expanded(
                      child: InputField(
                        label: 'Ida',
                        value: '01/09/2025',
                        icon: Icons.calendar_today,
                        enabled: true,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: InputField(
                        label: 'Vuelta',
                        value: '10/09/2025',
                        icon: Icons.calendar_today,
                        enabled: true,
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 5),

          InputField(
            label: 'Pasajeros',
            value: '$passengers',
            icon: Icons.person_add,
            enabled: true,
            onTap: () => showPassengerSelector(),
          ),
          const SizedBox(height: 10),

          // Search Button
          CustomButton(text: "Buscar vuelos", onPressed: () {}),
        ],
      ),
    );
  }

  void showPassengerSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Seleccionar pasajeros',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pasajeros'),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (passengers > 1) {
                          setState(() => passengers--);
                        }
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      '$passengers',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() => passengers++);
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Confirmar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
