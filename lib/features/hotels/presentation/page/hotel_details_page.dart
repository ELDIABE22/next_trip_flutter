import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/core/widgets/bottom_reserve_panel.dart';
import 'package:next_trip/features/hotels/data/controllers/hotel_controller.dart';
import 'package:next_trip/features/hotels/data/models/hotel_model.dart';
import 'package:next_trip/features/hotels/presentation/widgets/hotelSearchPage/hotel_attribute_card.dart';
import 'package:next_trip/features/hotels/presentation/widgets/hotelSearchPage/hotel_calendar.dart';

class HotelDetailsPage extends StatefulWidget {
  final Hotel? hotel;
  final String? hotelId;

  const HotelDetailsPage({super.key, this.hotel, this.hotelId});

  @override
  State<HotelDetailsPage> createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  late final HotelController _hotelController;
  Hotel? _currentHotel;

  @override
  void initState() {
    super.initState();
    _setupController();
    _initializeHotel();
  }

  void _setupController() {
    _hotelController = HotelController(
      onStateChanged: () {
        if (mounted) setState(() {});
      },
    );
  }

  void _initializeHotel() {
    if (widget.hotel != null) {
      _currentHotel = widget.hotel;
      _hotelController.selectHotel(widget.hotel!);
    } else if (widget.hotelId != null) {
      _hotelController.loadHotelById(widget.hotelId!);
    }
  }

  @override
  void dispose() {
    _hotelController.dispose();
    super.dispose();
  }

  Hotel? get _displayHotel {
    return _currentHotel ?? _hotelController.selectedHotel ?? widget.hotel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: Appbar(isTransparent: true, iconColor: Colors.white),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final hotel = _displayHotel;

    // Loading state
    if (_hotelController.isLoading && hotel == null) {
      return Container(
        decoration: AppConstantsColors.radialBackground,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Cargando detalles del hotel...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    // Error state
    if (hotel == null && _hotelController.hasError) {
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
                  'Error al cargar el hotel',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _hotelController.errorMessage ?? 'Error desconocido',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[300]),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.hotelId != null)
                      ElevatedButton(
                        onPressed: () {
                          _hotelController.clearError();
                          _hotelController.loadHotelById(widget.hotelId!);
                        },
                        child: const Text('Reintentar'),
                      ),
                    if (widget.hotelId != null) const SizedBox(width: 8),
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

    // No hotel state
    if (hotel == null) {
      return Container(
        decoration: AppConstantsColors.radialBackground,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hotel_outlined, size: 64, color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Hotel no encontrado',
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

    // Success state - show hotel details
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            decoration: AppConstantsColors.radialBackground,
            child: Column(
              children: [
                // Image
                _buildHotelImage(hotel),

                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildHotelDetails(hotel),
                      const SizedBox(height: 20),
                      _buildHotelAttributes(hotel),
                      const SizedBox(height: 20),
                      _buildCalendarSection(hotel),
                      _buildAboutSection(hotel),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom panel
        BottomReservePanel(
          totalPrice: '${hotel.formattedPrice} COP',
          dateRange: 'por 6 noches 10 - 16 de nov',
          buttonText: 'Reservar',
          onPressed: () {
            _handleReservation(hotel);
          },
        ),
      ],
    );
  }

  void _handleReservation(Hotel hotel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reservar Hotel'),
        content: Text('¿Confirmar reserva de ${hotel.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Reserva confirmada para ${hotel.name}'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelImage(Hotel hotel) {
    return SizedBox(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: hotel.imageUrl.startsWith('http')
            ? Image.network(
                hotel.imageUrl,
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: double.infinity,
                    height: 350,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/hotel.webp',
                    width: double.infinity,
                    height: 350,
                    fit: BoxFit.cover,
                  );
                },
              )
            : Image.asset(
                hotel.imageUrl,
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget _buildHotelDetails(Hotel hotel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hotel.name,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 20, color: Colors.black),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      hotel.address,
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.phone, size: 20, color: Colors.black),
                  const SizedBox(width: 5),
                  Text(
                    hotel.phone,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(
          hotel.formattedPrice,
          style: const TextStyle(
            fontSize: 26,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildHotelAttributes(Hotel hotel) {
    return Row(
      children: [
        Expanded(
          child: HotelAttributeCard(
            icon: Icons.person,
            value: hotel.maxGuests.toString(),
            label: hotel.guestsLabel,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: HotelAttributeCard(
            icon: Icons.home,
            value: hotel.rooms.toString(),
            label: hotel.roomsLabel,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: HotelAttributeCard(
            icon: Icons.bed,
            value: hotel.beds.toString(),
            label: hotel.bedsLabel,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: HotelAttributeCard(
            icon: Icons.bathtub,
            value: hotel.bathrooms.toString(),
            label: hotel.bathroomsLabel,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarSection(Hotel hotel) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            width: 1,
            color: Color.fromARGB(255, 184, 183, 183),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "6 noches en ${hotel.name}",
            style: const TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Text(
            "10 de nov. de 2025 - 16 de nov. de 2025",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[300],
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(16),
            child: const HotelCalendar(),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(Hotel hotel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Acerca de este espacio",
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            hotel.description,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
