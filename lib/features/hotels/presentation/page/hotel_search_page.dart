import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_trip/core/utils/flight_prefs.dart';
import 'package:next_trip/core/widgets/page_layout.dart';
import 'package:next_trip/features/hotels/application/bloc/hotel_bloc.dart';
import 'package:next_trip/features/hotels/application/bloc/hotel_event.dart';
import 'package:next_trip/features/hotels/application/bloc/hotel_state.dart';
import 'package:next_trip/features/hotels/infrastructure/models/hotel_model.dart';
import 'package:next_trip/features/hotels/presentation/page/hotel_details_page.dart';
import 'package:next_trip/features/hotels/presentation/widgets/hotelSearchPage/hotel_card.dart';

class HotelSearchPage extends StatefulWidget {
  const HotelSearchPage({super.key});

  @override
  State<HotelSearchPage> createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage> {
  int selectedIndex = 1;
  String? destinationCity;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
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
      context.read<HotelBloc>().add(
        GetHotelsByCityRequested(city: destinationCity!),
      );
    } else {
      context.read<HotelBloc>().add(GetAllHotelsRequested());
    }
  }

  Future<void> _refreshHotels() async {
    context.read<HotelBloc>().add(HotelRefreshRequested());
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> _navigateToDetails(HotelModel hotel) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HotelDetailsPage(hotel: hotel)),
    );
    if (!mounted) return;
    context.read<HotelBloc>().add(
      destinationCity != null
          ? GetHotelsByCityRequested(city: destinationCity!)
          : GetAllHotelsRequested(),
    );
  }

  Widget _buildHotelsList() {
    return BlocBuilder<HotelBloc, HotelState>(
      builder: (context, state) {
        if (state is HotelLoading) {
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
        } else if (state is HotelError) {
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<HotelBloc>().add(
                          GetHotelsByCityRequested(city: destinationCity!),
                        );
                      },
                      child: const Text('Reintentar'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        setState(() => destinationCity = null);
                        context.read<HotelBloc>().add(
                          GetHotelsStreamRequested(),
                        );
                      },
                      child: const Text('Ver todos'),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (state is HotelListLoaded) {
          if (state.hotels.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.hotel_outlined,
                    size: 64,
                    color: Colors.black,
                  ),
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
                      context.read<HotelBloc>().add(
                        GetHotelsByCityRequested(city: destinationCity!),
                      );
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _refreshHotels,
            child: Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.hotels.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final hotel = state.hotels[index];
                    return HotelCard(
                      hotel: hotel,
                      onTap: () => _navigateToDetails(hotel),
                    );
                  },
                ),

                if (state.hotels.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Mostrando ${state.hotels.length} hoteles',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
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
