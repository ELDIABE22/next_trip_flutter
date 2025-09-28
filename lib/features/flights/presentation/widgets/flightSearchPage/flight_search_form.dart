import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:next_trip/core/utils/flight_prefs.dart';
import 'package:next_trip/core/widgets/custom_button.dart';
import 'package:next_trip/features/destinations/presentation/pages/search_country_page.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/input_field.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/trip_type_buttont.dart';

class FlightSearchForm extends StatefulWidget {
  final String? originCountry;
  final String? originCity;
  final String? destinationCountry;
  final String? destinationCity;
  final Function({
    required String originCity,
    required String destinationCity,
    required DateTime departureDate,
  })
  onSearch;

  const FlightSearchForm({
    super.key,
    this.originCountry,
    this.originCity,
    this.destinationCountry,
    this.destinationCity,
    required this.onSearch,
  });

  @override
  State<FlightSearchForm> createState() => _FlightSearchFormState();
}

class _FlightSearchFormState extends State<FlightSearchForm> {
  bool isOneWay = true;
  int passengers = 2;
  DateTime departureDate = DateTime.now().add(const Duration(days: 1));
  DateTime returnDate = DateTime.now().add(const Duration(days: 1));

  String? originCity;
  String? originCountry;
  String? destinationCity;
  String? destinationCountry;

  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    originCountry = widget.originCountry;
    originCity = widget.originCity;
    destinationCountry = widget.destinationCountry;
    destinationCity = widget.destinationCity;

    originController.text = originCity ?? '';
    destinationController.text = destinationCity ?? '';

    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final data = await FlightPrefs.loadSelection();
    if (!mounted) return;
    setState(() {
      originCountry = data['originCountry'] ?? originCountry;
      originCity = data['originCity'] ?? originCity;
      destinationCountry = data['destinationCountry'] ?? destinationCountry;
      destinationCity = data['destinationCity'] ?? destinationCity;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDeparture ? departureDate : returnDate,
      firstDate: isDeparture ? DateTime.now() : departureDate,
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      setState(() {
        if (isDeparture) {
          departureDate = picked;
          if (returnDate.isBefore(departureDate)) {
            returnDate = departureDate.add(const Duration(days: 1));
          }
        } else {
          returnDate = picked;
        }
      });
    }
  }

  void _handleSearch() {
    if (originController.text.isEmpty || destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona origen y destino')),
      );
      return;
    }

    if (departureDate.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La fecha de ida no puede ser pasada')),
      );
      return;
    }

    widget.onSearch(
      originCity: originController.text,
      destinationCity: destinationController.text,
      departureDate: departureDate,
    );
  }

  @override
  void dispose() {
    originController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
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

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchCountryPage(),
                      ),
                    );

                    await _loadPrefs();
                  },
                  child: InputField(
                    label: 'Origen',
                    value: originController.text.isNotEmpty
                        ? originController.text
                        : "Seleccionar",
                    icon: Icons.flight_takeoff,
                    enabled: true,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchCountryPage(),
                        ),
                      );
                      await _loadPrefs();
                      setState(() => originController.text = originCity ?? '');
                    },
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchCountryPage(),
                      ),
                    );

                    await _loadPrefs();
                  },
                  child: InputField(
                    label: 'Destino',
                    value: destinationController.text.isNotEmpty
                        ? destinationController.text
                        : "Seleccionar",
                    icon: Icons.flight_land,
                    enabled: true,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchCountryPage(),
                        ),
                      );
                      await _loadPrefs();
                      setState(
                        () =>
                            destinationController.text = destinationCity ?? '',
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          isOneWay
              ? InputField(
                  label: 'Fecha',
                  value: DateFormat('dd/MM/yyyy').format(departureDate),
                  icon: Icons.calendar_today,
                  enabled: true,
                  onTap: () => _selectDate(context, true),
                )
              : Row(
                  children: [
                    Expanded(
                      child: InputField(
                        label: 'Fecha de ida',
                        value: DateFormat('dd/MM/yyyy').format(departureDate),
                        icon: Icons.calendar_today,
                        enabled: true,
                        onTap: () => _selectDate(context, true),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: InputField(
                        label: 'Fecha de vuelta',
                        value: DateFormat('dd/MM/yyyy').format(returnDate),
                        icon: Icons.calendar_today,
                        enabled: true,
                        onTap: () => _selectDate(context, false),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 10),

          CustomButton(text: "Buscar vuelos", onPressed: _handleSearch),
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
