import 'package:flutter/material.dart';
import 'package:next_trip/features/hotels/infrastructure/models/hotel_model.dart';
import 'package:next_trip/features/hotels/presentation/widgets/hotelSearchPage/hotel_attribute_tag.dart';

class HotelCard extends StatelessWidget {
  final HotelModel hotel;
  final VoidCallback onTap;

  const HotelCard({super.key, required this.hotel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          child: _buildHotelImage(),
        ),

        // Badges container
        Positioned(
          top: 15,
          left: 15,
          right: 15,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Badge del tipo de hotel
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
                  hotel.type,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Badge de disponibilidad
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: hotel.isAvailable ? Colors.green : Colors.red,
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
                  hotel.isAvailable ? 'Disponible' : 'No disponible',
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

  Widget _buildHotelImage() {
    return hotel.imageUrl.startsWith('http')
        ? Image.network(
            hotel.imageUrl,
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
      'assets/images/hotel.webp',
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
          Icon(Icons.hotel, size: 50, color: Colors.grey[600]),
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
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 20),
      child: Column(
        children: [
          _buildHotelInfo(),
          const SizedBox(height: 15),
          _buildHotelAttributes(),
        ],
      ),
    );
  }

  Widget _buildHotelInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hotel.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: 5),
              Text(
                hotel.address,
                style: const TextStyle(
                  color: Color(0xFF8F8F8F),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
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
              hotel.formattedPrice,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              'por noche',
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

  Widget _buildHotelAttributes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        HotelAttributeTag(
          title: hotel.maxGuests.toString(),
          icon: Icons.person,
        ),
        const SizedBox(width: 10),
        HotelAttributeTag(title: hotel.rooms.toString(), icon: Icons.home),
        const SizedBox(width: 10),
        HotelAttributeTag(title: hotel.beds.toString(), icon: Icons.bed),
        const SizedBox(width: 10),
        HotelAttributeTag(
          title: hotel.bathrooms.toString(),
          icon: Icons.bathtub,
        ),
      ],
    );
  }
}
