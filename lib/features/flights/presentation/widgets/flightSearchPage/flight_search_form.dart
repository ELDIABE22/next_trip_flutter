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
  final DateTime? returnDate;
  final Function({
    required String originCity,
    required String destinationCity,
    required DateTime departureDate,
    DateTime? returnDate,
    required bool isOneWay,
  })
  onSearch;

  const FlightSearchForm({
    super.key,
    this.originCountry,
    this.originCity,
    this.destinationCountry,
    this.destinationCity,
    this.returnDate,
    required this.onSearch,
  });

  @override
  State<FlightSearchForm> createState() => _FlightSearchFormState();
}

class _FlightSearchFormState extends State<FlightSearchForm> {
  bool isOneWay = true;
  int passengers = 2;
  DateTime departureDate = DateTime.now().add(const Duration(days: 1));
  DateTime returnDate = DateTime.now().add(const Duration(days: 4));

  String? originCity;
  String? originCountry;
  String? destinationCity;
  String? destinationCountry;

  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    originCountry = widget.originCountry;
    originCity = widget.originCity;
    destinationCountry = widget.destinationCountry;
    destinationCity = widget.destinationCity;

    originController.text = originCity ?? '';
    destinationController.text = destinationCity ?? '';

    if (widget.returnDate != null) {
      returnDate = widget.returnDate!;
    }

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

      originController.text = originCity ?? '';
      destinationController.text = destinationCity ?? '';
    });
  }

  Future<void> _selectDate(BuildContext context, bool isDeparture) async {
    final DateTime initialDate;
    final DateTime firstDate;
    final DateTime lastDate = DateTime.now().add(const Duration(days: 365));

    if (isDeparture) {
      initialDate = departureDate;
      firstDate = DateTime.now();
    } else {
      initialDate =
          returnDate.isBefore(departureDate.add(const Duration(days: 1)))
          ? departureDate.add(const Duration(days: 1))
          : returnDate;
      firstDate = departureDate;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: isDeparture
          ? 'Selecciona fecha de ida'
          : 'Selecciona fecha de regreso',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );

    if (picked != null) {
      setState(() {
        if (isDeparture) {
          departureDate = picked;

          if (returnDate.isBefore(departureDate.add(const Duration(days: 1)))) {
            returnDate = departureDate.add(const Duration(days: 1));
          }
        } else {
          returnDate = picked;
        }
      });
    }
  }

  Future<void> _handleSearch() async {
    if (originController.text.isEmpty || destinationController.text.isEmpty) {
      _showErrorSnackBar('Por favor selecciona origen y destino');
      return;
    }

    if (originController.text.trim() == destinationController.text.trim()) {
      _showErrorSnackBar('El origen y destino no pueden ser iguales');
      return;
    }

    if (departureDate.isBefore(
      DateTime.now().subtract(const Duration(hours: 1)),
    )) {
      _showErrorSnackBar('La fecha de ida no puede ser pasada');
      return;
    }

    if (!isOneWay && returnDate.isBefore(departureDate)) {
      _showErrorSnackBar('La fecha de regreso debe ser posterior a la de ida');
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      await widget.onSearch(
        originCity: originController.text.trim(),
        destinationCity: destinationController.text.trim(),
        departureDate: departureDate,
        returnDate: isOneWay ? null : returnDate,
        isOneWay: isOneWay,
      );
    } catch (e) {
      _showErrorSnackBar('Error al buscar vuelos: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
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
                child: _buildLocationField(
                  label: 'Origen',
                  controller: originController,
                  icon: Icons.flight_takeoff,
                  onUpdate: () =>
                      setState(() => originController.text = originCity ?? ''),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: IconButton(
                  onPressed: _swapLocations,
                  icon: const Icon(Icons.swap_horiz, color: Colors.black),
                  tooltip: 'Intercambiar origen y destino',
                ),
              ),
              Expanded(
                child: _buildLocationField(
                  label: 'Destino',
                  controller: destinationController,
                  icon: Icons.flight_land,
                  onUpdate: () => setState(
                    () => destinationController.text = destinationCity ?? '',
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

          if (!isOneWay) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Duración del viaje: ${returnDate.difference(departureDate).inDays} días',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 10),

          CustomButton(
            text: _isSearching ? "Buscando..." : "Buscar vuelos",
            onPressed: _isSearching ? null : _handleSearch,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required VoidCallback onUpdate,
  }) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchCountryPage()),
        );
        await _loadPrefs();
        onUpdate();
      },
      child: InputField(
        label: label,
        value: controller.text.isNotEmpty ? controller.text : "Seleccionar",
        icon: icon,
        enabled: true,
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchCountryPage()),
          );
          await _loadPrefs();
          onUpdate();
        },
      ),
    );
  }

  void _swapLocations() {
    setState(() {
      final tempCity = originCity;
      originCity = destinationCity;
      destinationCity = tempCity;

      final tempCountry = originCountry;
      originCountry = destinationCountry;
      destinationCountry = tempCountry;

      originController.text = originCity ?? '';
      destinationController.text = destinationCity ?? '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.swap_horiz, color: Colors.white),
            SizedBox(width: 8),
            Text('Origen y destino intercambiados'),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void showPassengerSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Seleccionar pasajeros',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pasajeros',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Adultos y niños',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: passengers > 1
                          ? () => setState(() => passengers--)
                          : null,
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: passengers > 1 ? Colors.blue : Colors.grey,
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '$passengers',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: passengers < 9
                          ? () => setState(() => passengers++)
                          : null,
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: passengers < 9 ? Colors.blue : Colors.grey,
                      ),
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
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Confirmar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
