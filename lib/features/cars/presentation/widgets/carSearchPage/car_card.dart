import 'package:flutter/material.dart';
import 'package:next_trip/features/cars/data/controllers/car_controller.dart';
import 'package:next_trip/features/cars/data/models/car_model.dart';
import 'package:next_trip/features/cars/presentation/pages/car_datails_page.dart';
import 'package:next_trip/features/cars/presentation/widgets/carSearchPage/car_attribute_tag.dart';

class CarCard extends StatelessWidget {
  final Car car;
  final CarController? controller;

  const CarCard({super.key, required this.car, this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller?.selectCar(car);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CarDetailsPage(car: car)),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(children: [_buildImageSection(), _buildContentSection()]),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        ClipRRect(child: _buildCarImage()),

        // Badges container
        Positioned(
          top: 15,
          left: 15,
          right: 15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Badge de categoría
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  car.categoryDisplay,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Badge de disponibilidad
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: car.isAvailable ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  car.isAvailable ? 'Disponible' : 'No disponible',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCarImage() {
    return car.imageUrl.startsWith('http')
        ? Image.network(
            car.imageUrl,
            width: double.infinity,
            height: 210,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: double.infinity,
                height: 210,
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return _buildFallbackImage();
            },
          )
        : _buildAssetImage();
  }

  Widget _buildAssetImage() {
    return Image.asset(
      'assets/images/carro.webp',
      width: double.infinity,
      height: 210,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildFallbackImage();
      },
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      width: double.infinity,
      height: 210,
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car, size: 50, color: Colors.grey[600]),
          const SizedBox(height: 8),
          Text(
            'Imagen no disponible',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Container(
      padding: const EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 20),
      decoration: const BoxDecoration(color: Color(0xFFF6F3F3)),
      child: Column(
        children: [
          _buildCarInfo(),
          const SizedBox(height: 15),
          _buildCarAttributes(),
        ],
      ),
    );
  }

  Widget _buildCarInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                car.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: 5),
              Text(
                car.category,
                style: const TextStyle(
                  color: Color(0xFF8F8F8F),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              car.formattedPrice,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'por día',
              style: TextStyle(
                color: Color(0xFF8F8F8F),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCarAttributes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CarAttributeTag(title: car.passengers.toString(), icon: Icons.person),
        const SizedBox(width: 10),
        CarAttributeTag(title: car.luggage.toString(), icon: Icons.work),
        const SizedBox(width: 10),
        CarAttributeTag(title: car.doors.toString(), icon: Icons.meeting_room),
        const SizedBox(width: 10),
        CarAttributeTag(
          title: car.transmissionDisplay,
          icon: Icons.settings_input_component,
        ),
      ],
    );
  }
}
