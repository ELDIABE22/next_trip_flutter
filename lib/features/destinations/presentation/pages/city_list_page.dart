import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/core/widgets/input.dart';
import 'package:next_trip/features/destinations/data/services/destination_service.dart';
import 'package:next_trip/features/destinations/presentation/widgets/city_card_widget.dart';

class CityListPage extends StatefulWidget {
  final String country;
  final bool isOrigin;

  const CityListPage({
    super.key,
    required this.country,
    required this.isOrigin,
  });

  @override
  State<CityListPage> createState() => _CityListPageState();
}

class _CityListPageState extends State<CityListPage> {
  final DestinationService _service = DestinationService();
  final TextEditingController _searchCtrl = TextEditingController();
  List<String> _cities = [];
  List<String> _filtered = [];
  bool _loading = true;
  String? _error;
  final Map<String, List<String>> _cache = {};

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearch);
    _loadCities();
  }

  void _onSearch() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = _cities.where((c) => c.toLowerCase().contains(q)).toList();
    });
  }

  Future<void> _loadCities() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (_cache.containsKey(widget.country)) {
        _cities = _cache[widget.country]!;
      } else {
        final list = await _service.fetchCities(widget.country);
        _cities = list;
        _cache[widget.country] = list;
      }
      _filtered = _cities;
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Appbar(
        title: widget.isOrigin ? "Ciudad de origen" : "Ciudad de destino",
      ),
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
                Text(
                  widget.isOrigin
                      ? "¿Desde qué ciudad sales? — ${widget.country}"
                      : "¿A qué ciudad quieres ir? — ${widget.country}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),

                Input(
                  labelText: "Buscar ciudad",
                  controller: _searchCtrl,
                  prefixIcon: Icons.search,
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Error: $_error',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _loadCities,
                                child: const Text('Reintentar'),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          itemCount: _filtered.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.9,
                              ),
                          itemBuilder: (context, index) {
                            final city = _filtered[index];
                            return CityCard(
                              city: city,
                              image: "assets/images/barranquilla.webp",
                              onTap: () {
                                Navigator.pop(context, city);
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
