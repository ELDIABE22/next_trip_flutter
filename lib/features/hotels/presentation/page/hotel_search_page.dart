import 'package:flutter/material.dart';
import 'package:next_trip/core/utils/flight_prefs.dart';
import 'package:next_trip/core/widgets/page_layout.dart';
import 'package:next_trip/features/hotels/data/controllers/hotel_controller.dart';
import 'package:next_trip/features/hotels/presentation/widgets/hotelSearchPage/hotel_card.dart';

class HotelSearchPage extends StatefulWidget {
  const HotelSearchPage({super.key});

  @override
  State<HotelSearchPage> createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage> {
  late final HotelController _hotelController;

  int selectedIndex = 1;
  String? destinationCity;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _hotelController = HotelController(
      onStateChanged: () {
        if (mounted) setState(() {});
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  @override
  void dispose() {
    _hotelController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    if (_isInitialized) return;
    _isInitialized = true;

    await _loadDestination();
    await _setupHotelStream();
  }

  Future<void> _loadDestination() async {
    try {
      final data = await FlightPrefs.loadSelection();
      if (mounted) {
        setState(() {
          destinationCity = data['destinationCity'];
        });
      }
    } catch (e) {
      debugPrint('Error loading destination: $e');
    }
  }

  Future<void> _setupHotelStream() async {
    if (destinationCity != null && destinationCity!.isNotEmpty) {
      _hotelController.loadHotelsByCity(destinationCity!);
    } else {
      _hotelController.loadAllHotels();
    }
  }

  Future<void> _refreshHotels() async {
    await _hotelController.refresh();
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget _buildHotelsList() {
    if (_hotelController.isLoading && _hotelController.hotels.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Cargando hoteles...',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      );
    }

    if (_hotelController.hasError && _hotelController.hotels.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Error al cargar hoteles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _hotelController.errorMessage ?? 'Error desconocido',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _hotelController.clearError();
                    _hotelController.loadAllHotels();
                  },
                  child: const Text('Reintentar'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    _hotelController.clearError();
                    setState(() => destinationCity = null);
                    _hotelController.listenToHotelsStream();
                  },
                  child: const Text('Ver todos'),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (_hotelController.hotels.isEmpty && !_hotelController.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.hotel_outlined, size: 64, color: Colors.black),
            const SizedBox(height: 16),
            Text(
              destinationCity != null
                  ? 'No hay hoteles disponibles en $destinationCity'
                  : 'No se encontraron hoteles disponibles',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() => destinationCity = null);
                _hotelController.loadAllHotels();
              },
              child: const Text('Ver todos los hoteles'),
            ),
          ],
        ),
      );
    }

    // Success state
    return RefreshIndicator(
      onRefresh: _refreshHotels,
      child: Column(
        children: [
          if (_hotelController.isLoading && _hotelController.hasHotels)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _hotelController.hotels.length,
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              final hotel = _hotelController.hotels[index];
              return HotelCard(hotel: hotel, controller: _hotelController);
            },
          ),

          if (_hotelController.hasHotels)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Mostrando ${_hotelController.hotels.length} hoteles',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }

  String _getPageTitle() {
    if (destinationCity != null && destinationCity!.isNotEmpty) {
      return 'Hoteles en $destinationCity: encuentra y reserva el hospedaje perfecto para tu viaje.';
    }
    return 'Tu descanso ideal comienza aquí: encuentra y reserva el hospedaje perfecto para tu viaje.';
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      titleHeader: 'HOSPEDAJE',
      title: _getPageTitle(),
      selectedIndex: selectedIndex,
      onItemTapped: onItemTapped,
      children: [
        Column(children: [_buildHotelsList()]),
      ],
    );
  }
}
