import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/features/cars/application/bloc/car.state.dart';
import 'package:next_trip/features/cars/application/bloc/car_bloc.dart';
import 'package:next_trip/features/cars/application/bloc/car_event.dart';
import 'package:next_trip/features/cars/infrastructure/models/car_model.dart';
import 'package:next_trip/features/cars/presentation/pages/car_booking_page.dart';
import 'package:next_trip/features/cars/presentation/widgets/carDetailsPage/car_attribute_card.dart';
import 'package:next_trip/core/widgets/bottom_reserve_panel.dart';

class CarDetailsPage extends StatefulWidget {
  final CarModel? car;

  const CarDetailsPage({super.key, this.car});

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<CarBloc>().add(LoadCarByIdRequested(widget.car!.id));
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
    return BlocBuilder<CarBloc, CarState>(
      builder: (context, state) {
        if (state is CarLoading) {
          return Container(
            decoration: AppConstantsColors.radialBackground,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.black),
                  SizedBox(height: 16),
                  Text(
                    'Cargando detalles del carro...',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is CarError) {
          return Container(
            decoration: AppConstantsColors.radialBackground,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Error al cargar el carro',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.car != null)
                          ElevatedButton(
                            onPressed: () {
                              context.read<CarBloc>().add(
                                LoadCarByIdRequested(widget.car!.id),
                              );
                            },
                            child: const Text('Reintentar'),
                          ),
                        if (widget.car != null) const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is CarLoaded) {
          if (state.car == null) {
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

          return Stack(
            children: [
              Container(
                decoration: AppConstantsColors.radialBackground,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildCarImage(state.car!)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildCarDetails(state.car!),
                            const SizedBox(height: 20),
                            _buildCarAttributes(state.car!),
                            const SizedBox(height: 20),
                            _buildDescription(state.car!),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildBottomReservePanel(state.car!),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCarImage(CarModel car) {
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

  Widget _buildCarDetails(CarModel car) {
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

  Widget _buildCarAttributes(CarModel car) {
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

  Widget _buildDescription(CarModel car) {
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

  Widget _buildAdditionalInfo(CarModel car) {
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

  Widget _buildBottomReservePanel(CarModel car) {
    return BottomReservePanel(
      totalPrice: '${car.formattedPrice} COP',
      dateRange: 'por día de alquiler',
      buttonText: 'Reservar',
      onPressed: () => _handleReservation(car),
    );
  }

  void _handleReservation(CarModel car) {
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
