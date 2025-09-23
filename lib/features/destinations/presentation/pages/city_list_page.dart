import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/core/widgets/input.dart';
import 'package:next_trip/features/destinations/presentation/widgets/city_card_widget.dart';
import 'package:next_trip/features/flights/presentation/pages/flight_search_page.dart';

class CityListPage extends StatelessWidget {
  const CityListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> cities = [
      "Barranquilla",
      "Bogotá",
      "Medellín",
      "Cali",
      "Cartagena",
      "Santa Marta",
      "Bucaramanga",
      "Pereira",
      "Manizales",
      "Villavicencio",
      "Ibagué",
      "Neiva",
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Appbar(title: "Seleccionar ciudad"),
      body: Stack(
        children: [
          Positioned(
            bottom: -5,
            right: -80,
            child: Image.asset("assets/images/logo-app-black.webp", width: 250),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: AppConstantsColors.radialBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "¿A qué ciudad te gustaría ir?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 10),

                Input(labelText: "Buscar ciudad"),

                const SizedBox(height: 20),

                // CONTENEDOR DE CARDS
                Expanded(
                  child: GridView.builder(
                    itemCount: cities.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.9,
                        ),
                    itemBuilder: (context, index) {
                      return CityCard(
                        city: cities[index],
                        image: "assets/images/barranquilla.webp",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FlightSearchPage(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
