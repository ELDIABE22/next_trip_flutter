import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Seleccionar ciudad",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: -5,
            right: -80,
            child: Image.asset("assets/images/logo-app.webp", width: 250),
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

                const TextField(
                  decoration: InputDecoration(
                    labelText: "Buscar ciudad",
                    labelStyle: TextStyle(color: Color(0xFF9C9C9C)),
                    filled: true,
                    fillColor: Color(0xFFF4F4F4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Icon(Icons.search),
                  ),
                ),

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
                      return _CityCard(
                        city: cities[index],
                        image: "assets/images/barranquilla.webp",
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

class _CityCard extends StatelessWidget {
  final String city;
  final String image;

  const _CityCard({required this.city, required this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Seleccionaste $city")));
      },
      borderRadius: BorderRadius.circular(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(image, fit: BoxFit.cover),

            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
            ),

            Center(
              child: Text(
                city,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      color: Colors.black54,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
