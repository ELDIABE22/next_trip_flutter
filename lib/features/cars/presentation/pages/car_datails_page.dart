import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/features/cars/data/controllers/car_controller.dart';
import 'package:next_trip/features/cars/data/models/car_model.dart';
import 'package:next_trip/features/cars/presentation/pages/car_booking_page.dart';
import 'package:next_trip/features/cars/presentation/widgets/carDetailsPage/car_attribute_card.dart';
import 'package:next_trip/core/widgets/bottom_reserve_panel.dart';

class CarDetailsPage extends StatefulWidget {
  final Car? car;
  final String? carId;

  const CarDetailsPage({super.key, this.car, this.carId});

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  late final CarController _carController;
  Car? _currentCar;

  @override
  void initState() {
    super.initState();
    _setupController();
    _initializeCar();
  }

  void _setupController() {
    _carController = CarController(
      onStateChanged: () {
        if (mounted) setState(() {});
      },
    );
  }

  void _initializeCar() {
    if (widget.car != null) {
      _currentCar = widget.car;
      _carController.selectCar(widget.car!);
    } else if (widget.carId != null) {
      _carController.loadCarById(widget.carId!);
    }
  }

  @override
  void dispose() {
    _carController.dispose();
    super.dispose();
  }

  Car? get _displayCar {
    return _currentCar ?? _carController.selectedCar ?? widget.car;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: _buildBody(),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(child: Appbar(isTransparent: true)),
      ),
    );
  }

  Widget _buildBody() {
    final car = _displayCar;

    // Loading state
    if (_carController.isLoading && car == null) {
      return Container(
        decoration: AppConstantsColors.radialBackground,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Cargando detalles del carro...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    // Error state
    if (car == null && _carController.hasError) {
      return Container(
        decoration: AppConstantsColors.radialBackground,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.white),
                const SizedBox(height: 16),
                const Text(
                  'Error al cargar el carro',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _carController.errorMessage ?? 'Error desconocido',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[300]),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.carId != null)
                      ElevatedButton(
                        onPressed: () {
                          _carController.clearError();
                          _carController.loadCarById(widget.carId!);
                        },
                        child: const Text('Reintentar'),
                      ),
                    if (widget.carId != null) const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Volver'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    // No car state
    if (car == null) {
      return Container(
        decoration: AppConstantsColors.radialBackground,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.directions_car_outlined,
                size: 64,
                color: Colors.white,
              ),
              SizedBox(height: 16),
              Text(
                'Carro no encontrado',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Success state - show car details
    return Stack(
      children: [
        Container(
          decoration: AppConstantsColors.radialBackground,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildCarImage(car)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildCarDetails(car),
                      const SizedBox(height: 20),
                      _buildCarAttributes(car),
                      const SizedBox(height: 20),
                      _buildDescription(car),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildBottomReservePanel(car),
      ],
    );
  }

  Widget _buildCarImage(Car car) {
    return SizedBox(
      height: 350,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: car.imageUrl.startsWith('http')
            ? Image.network(
                car.imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/carro.webp',
                    fit: BoxFit.contain,
                  );
                },
              )
            : Image.asset('assets/images/carro.webp', fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildCarDetails(Car car) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                car.name,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                car.category,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[900],
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${car.year} • ${car.color}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              car.formattedPrice,
              style: const TextStyle(
                fontSize: 26,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'por día',
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCarAttributes(Car car) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarAttributeCard(
          icon: Icons.person,
          value: car.passengers.toString(),
          label: car.passengersLabel,
        ),
        const SizedBox(width: 5),
        CarAttributeCard(
          icon: Icons.work,
          value: car.luggage.toString(),
          label: car.luggageLabel,
        ),
        const SizedBox(width: 5),
        CarAttributeCard(
          icon: Icons.meeting_room,
          value: car.doors.toString(),
          label: car.doorsLabel,
        ),
        const SizedBox(width: 5),
        CarAttributeCard(
          icon: Icons.settings_input_component,
          value: car.transmissionDisplay,
          label: car.transmissionFullName,
        ),
      ],
    );
  }

  Widget _buildDescription(Car car) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Descripción",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            car.description,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF686868),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 15),

          // Información adicional
          _buildAdditionalInfo(car),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(Car car) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Especificaciones",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        _buildInfoRow('Combustible', car.fuelTypeDisplay),
        _buildInfoRow('Motor', '${car.engineSize}L'),
        _buildInfoRow('Año', car.year),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF686868)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomReservePanel(Car car) {
    return BottomReservePanel(
      totalPrice: '${car.formattedPrice} COP',
      dateRange: 'por día de alquiler',
      buttonText: 'Reservar',
      onPressed: () => _handleReservation(car),
    );
  }

  void _handleReservation(Car car) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarBookingPage(
          car: car,
          userId: FirebaseAuth.instance.currentUser!.uid,
        ),
      ),
    );
  }
}
