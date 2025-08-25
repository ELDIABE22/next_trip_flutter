import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/core/widgets/input.dart';
import 'package:next_trip/features/destinations/presentation/widgets/country_item_widget.dart';

class CountryListPage extends StatelessWidget {
  const CountryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> countries = [
      {"name": "Colombia", "image": "assets/images/mundo.webp"},
      {"name": "México", "image": "assets/images/mundo.webp"},
      {"name": "Argentina", "image": "assets/images/mundo.webp"},
      {"name": "Brasil", "image": "assets/images/mundo.webp"},
      {"name": "Chile", "image": "assets/images/mundo.webp"},
      {"name": "Perú", "image": "assets/images/mundo.webp"},
      {"name": "Ecuador", "image": "assets/images/mundo.webp"},
      {"name": "Venezuela", "image": "assets/images/mundo.webp"},
      {"name": "Uruguay", "image": "assets/images/mundo.webp"},
      {"name": "Paraguay", "image": "assets/images/mundo.webp"},
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Appbar(title: "Seleccionar país",),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: AppConstantsColors.radialBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "¿A qué país te gustaría ir?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 10),

                Input(labelText: "Buscar país", icon: Icon(Icons.search)),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: countries.length,
                    itemBuilder: (context, index) {
                      final country = countries[index];
                      return CountryItemWidget(
                        countryName: country["name"]!,
                        imagePath: country["image"]!,
                        onTap: () {
                          Navigator.pop(context, country["name"]);
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
