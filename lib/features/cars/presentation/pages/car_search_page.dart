import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_trip/core/utils/flight_prefs.dart';
import 'package:next_trip/core/widgets/custom_button.dart';
import 'package:next_trip/core/widgets/page_layout.dart';
import 'package:next_trip/features/cars/application/bloc/car.state.dart';
import 'package:next_trip/features/cars/application/bloc/car_bloc.dart';
import 'package:next_trip/features/cars/application/bloc/car_event.dart';
import 'package:next_trip/features/cars/infrastructure/models/car_model.dart';
import 'package:next_trip/features/cars/presentation/pages/car_datails_page.dart';
import 'package:next_trip/features/cars/presentation/widgets/carSearchPage/car_card.dart';
import 'package:next_trip/features/cars/presentation/widgets/carSearchPage/car_search_form.dart';

class CarSearchPage extends StatefulWidget {
  const CarSearchPage({super.key});

  @override
  State<CarSearchPage> createState() => _CarSearchPageState();
}

class _CarSearchPageState extends State<CarSearchPage> {
  int selectedIndex = 2;
  String? destinationCity;
  bool _isInitialized = false;
  Map<String, dynamic>? _activeFilters;

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
    await _setupCarStream();
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

  Future<void> _setupCarStream() async {
    if (destinationCity != null && destinationCity!.isNotEmpty) {
      context.read<CarBloc>().add(
        LoadCarsByCityRequested(city: destinationCity!),
      );
    }
  }

  Future<void> _refreshCars() async {
    context.read<CarBloc>().add(
      LoadCarsByCityRequested(city: destinationCity!),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _handleSearch(Map<String, dynamic> filters) {
    setState(() {
      _activeFilters = filters;
    });

    context.read<CarBloc>().add(
      SearchCarsRequested(
        city: destinationCity,
        minPassengers: filters['minPassengers'],
        maxPrice: filters['maxPrice'],
        category: filters['category'],
        transmission: filters['transmission'],
        fuelType: filters['fuelType'],
        isAvailable: true,
      ),
    );
  }

  void _handleClearFilters() {
    setState(() {
      _activeFilters = null;
    });

    if (destinationCity != null && destinationCity!.isNotEmpty) {
      context.read<CarBloc>().add(
        LoadCarsByCityRequested(city: destinationCity!),
      );
    }
  }

  Future<void> _navigateToDetails(CarModel car) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CarDetailsPage(car: car)),
    );
    if (!mounted) return;
    context.read<CarBloc>().add(
      LoadCarsByCityRequested(city: destinationCity!),
    );
  }

  Widget _buildCarsList() {
    return BlocBuilder<CarBloc, CarState>(
      builder: (context, state) {
        if (state is CarLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Cargando carros...',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          );
        }

        if (state is CarError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Error al cargar carros',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      onPressed: () {
                        context.read<CarBloc>().add(
                          LoadCarsByCityRequested(city: destinationCity!),
                        );
                      },
                      text: 'Reintentar',
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        if (state is CarListLoaded) {
          if (state.cars.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.directions_car_outlined,
                    size: 64,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _activeFilters != null
                        ? 'No se encontraron carros con los filtros aplicados'
                        : destinationCity != null
                        ? 'No hay carros disponibles en $destinationCity'
                        : 'No se encontraron carros disponibles',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (_activeFilters != null)
                    CustomButton(
                      onPressed: _handleClearFilters,
                      text: 'Limpiar filtros',
                    )
                  else
                    CustomButton(
                      onPressed: () {
                        setState(() => destinationCity = null);
                        context.read<CarBloc>().add(
                          LoadCarsByCityRequested(city: destinationCity!),
                        );
                      },
                      text: 'Reintentar',
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshCars,
            child: Column(
              children: [
                if (_activeFilters != null) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.filter_list,
                          size: 16,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Filtros aplicados',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _handleClearFilters,
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.cars.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final car = state.cars[index];
                    return CarCard(
                      car: car,
                      onTap: () => _navigateToDetails(car),
                    );
                  },
                ),

                if (state.cars.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Mostrando ${state.cars.length} carros',
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
    if (_activeFilters != null) {
      return 'Resultados de búsqueda: encuentra tu carro ideal.';
    }
    if (destinationCity != null && destinationCity!.isNotEmpty) {
      return 'Carros en $destinationCity: tu aventura sobre ruedas comienza aquí.';
    }
    return 'Tu aventura sobre ruedas comienza aquí: elige y reserva tu carro ideal';
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      titleHeader: 'CARROS',
      title: _getPageTitle(),
      selectedIndex: selectedIndex,
      onItemTapped: onItemTapped,
      children: [
        CarSearchForm(
          onSearch: _handleSearch,
          onClearFilters: _handleClearFilters,
        ),
        const SizedBox(height: 20),
        _buildCarsList(),
      ],
    );
  }
}
