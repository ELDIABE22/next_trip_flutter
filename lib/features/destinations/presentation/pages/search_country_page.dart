import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/custom_button.dart';
import 'package:next_trip/features/destinations/presentation/pages/country_list_page.dart';
import 'package:next_trip/features/destinations/presentation/pages/city_list_page.dart';
import 'package:next_trip/features/destinations/presentation/widgets/country_selector_widget.dart';

class SearchCountryPage extends StatefulWidget {
  const SearchCountryPage({super.key});

  @override
  State<SearchCountryPage> createState() => _SearchCountryPageState();
}

class _SearchCountryPageState extends State<SearchCountryPage> {
  String selectedCountry = "Seleccionar";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Imagen Mundo
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mundo.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Select país
          Expanded(
            flex: 1,
            child: Container(
              decoration: AppConstantsColors.radialBackground,
              child: Padding(
                padding: EdgeInsets.all(35),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "ELIJA EL PAÍS",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      SizedBox(height: 20),

                      Text(
                        "Seleccione el país al que desea viajar",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppConstantsColors.textColor1,
                        ),
                      ),

                      SizedBox(height: 20),

                      CountrySelector(
                        text: selectedCountry,
                        icon: Icons.language,
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CountryListPage(),
                            ),
                          );
                          
                          if (result != null) {
                            setState(() {
                              selectedCountry = result;
                            });
                          }
                        },
                      ),

                      SizedBox(height: 20),

                      CustomButton(
                        text: "Continuar",
                        onPressed: selectedCountry != "Seleccionar" ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CityListPage(),
                            ),
                          );
                        } : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
