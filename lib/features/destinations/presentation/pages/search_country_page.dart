import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/utils/flight_prefs.dart';
import 'package:next_trip/core/widgets/custom_button.dart';
import 'package:next_trip/features/destinations/presentation/pages/country_list_page.dart';
import 'package:next_trip/features/destinations/presentation/pages/city_list_page.dart';
import 'package:next_trip/features/destinations/presentation/widgets/country_selector_widget.dart';
import 'package:next_trip/features/flights/presentation/pages/flight_search_page.dart';

class SearchCountryPage extends StatefulWidget {
  const SearchCountryPage({super.key});

  @override
  State<SearchCountryPage> createState() => _SearchCountryPageState();
}

class _SearchCountryPageState extends State<SearchCountryPage> {
  String originCountry = "Seleccionar";
  String destinationCountry = "Seleccionar";
  String? originCity;
  String? destinationCity;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final data = await FlightPrefs.loadSelection();
    if (!mounted) return;
    setState(() {
      originCountry = data['originCountry'] ?? "Seleccionar";
      originCity = data['originCity'];
      destinationCountry = data['destinationCountry'] ?? "Seleccionar";
      destinationCity = data['destinationCity'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Imagen Mundo
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            decoration: const BoxDecoration(
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
                padding: const EdgeInsets.all(35),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "BUSCAR VUELO",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Seleccione el país de origen y destino",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppConstantsColors.textColor1,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Origen
                      CountrySelector(
                        text: originCountry,
                        icon: Icons.flight_takeoff,
                        onPressed: () async {
                          setState(() => originCity = null);

                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CountryListPage(),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              originCountry = result;
                            });

                            await FlightPrefs.saveSelection(
                              originCountry: originCountry,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      // Destino
                      CountrySelector(
                        text: destinationCountry,
                        icon: Icons.flight_land,
                        onPressed: () async {
                          setState(() => destinationCity = null);

                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CountryListPage(),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              destinationCountry = result;
                            });

                            await FlightPrefs.saveSelection(
                              destinationCountry: destinationCountry,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 30),

                      CustomButton(
                        text: "Continuar",
                        onPressed:
                            (originCountry != "Seleccionar" &&
                                destinationCountry != "Seleccionar")
                            ? () async {
                                // Selección origen
                                if (originCity == null) {
                                  final oc = await Navigator.push<String>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CityListPage(
                                        country: originCountry,
                                        isOrigin: true,
                                      ),
                                    ),
                                  );
                                  if (oc == null || !mounted) return;
                                  setState(() => originCity = oc);

                                  await FlightPrefs.saveSelection(
                                    originCountry: originCountry,
                                    originCity: originCity,
                                  );
                                }

                                // Selección destino
                                if (destinationCity == null) {
                                  final dc = await Navigator.push<String>(
                                    // ignore: use_build_context_synchronously
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CityListPage(
                                        country: destinationCountry,
                                        isOrigin: false,
                                      ),
                                    ),
                                  );
                                  if (dc == null || !mounted) return;
                                  setState(() => destinationCity = dc);

                                  await FlightPrefs.saveSelection(
                                    destinationCountry: destinationCountry,
                                    destinationCity: destinationCity,
                                  );
                                }

                                // Ir a resultados
                                if (!mounted) return;
                                Navigator.push(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FlightSearchPage(
                                      originCountry: originCountry,
                                      originCity: originCity!,
                                      destinationCountry: destinationCountry,
                                      destinationCity: destinationCity!,
                                    ),
                                  ),
                                );
                              }
                            : null,
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
