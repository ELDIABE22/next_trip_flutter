import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/core/widgets/bottom_reserve_panel.dart';
import 'package:next_trip/features/bookings/data/controllers/hotel_booking_controller.dart';
import 'package:next_trip/features/bookings/presentation/widgets/booking_form_dialog.dart';
import 'package:next_trip/features/hotels/data/controllers/hotel_controller.dart';
import 'package:next_trip/features/hotels/data/models/hotel_model.dart';
import 'package:next_trip/features/hotels/presentation/widgets/hotelSearchPage/hotel_attribute_card.dart';

class HotelDetailsPage extends StatefulWidget {
  final Hotel? hotel;
  final String? hotelId;

  const HotelDetailsPage({super.key, this.hotel, this.hotelId});

  @override
  State<HotelDetailsPage> createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  late final HotelController _hotelController;
  late final HotelBookingController _bookingController;
  Hotel? _currentHotel;

  @override
  void initState() {
    super.initState();
    _setupControllers();
    _initializeHotel();
  }

  void _setupControllers() {
    _hotelController = HotelController(
      onStateChanged: () {
        if (mounted) setState(() {});
      },
    );

    _bookingController = HotelBookingController(
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
    _bookingController.dispose();
    super.dispose();
  }

  Hotel? get _displayHotel {
    return _currentHotel ?? _hotelController.selectedHotel ?? widget.hotel;
  }

  bool get _isUserLoggedIn {
    return FirebaseAuth.instance.currentUser != null;
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
                      _buildBookingSection(hotel),
                      _buildAboutSection(hotel),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        _buildBottomReservePanel(hotel),
      ],
    );
  }

  Widget _buildBookingSection(Hotel hotel) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Selecciona tus fechas",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (_bookingController.hasValidDateRange)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_bookingController.numberOfNights} noches',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 15),

          // Selector de fechas
          Row(
            children: [
              Expanded(
                child: _buildDateSelector(
                  label: 'Fecha de entrada',
                  date: _bookingController.selectedCheckInDate,
                  onTap: () => _selectCheckInDate(),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildDateSelector(
                  label: 'Fecha de salida',
                  date: _bookingController.selectedCheckOutDate,
                  onTap: () => _selectCheckOutDate(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          if (_bookingController.hasValidDateRange) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${hotel.formattedPrice} x ${_bookingController.numberOfNights} noches',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _bookingController.getFormattedTotalPrice(hotel),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _bookingController.getFormattedTotalPrice(hotel),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: date != null
                ? Colors.green
                : Colors.grey.withValues(alpha: 0.3),
            width: date != null ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date != null
                  ? '${date.day}/${date.month}/${date.year}'
                  : 'Seleccionar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: date != null ? Colors.black : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomReservePanel(Hotel hotel) {
    return BottomReservePanel(
      totalPrice: _bookingController.hasValidDateRange
          ? _bookingController.getFormattedTotalPrice(hotel)
          : hotel.formattedPrice,
      dateRange: _bookingController.hasValidDateRange
          ? 'por ${_bookingController.numberOfNights} noches'
          : 'por noche',
      buttonText: 'Reservar',
      onPressed: () => _handleReservation(hotel),
    );
  }

  Future<void> _handleReservation(Hotel hotel) async {
    if (!_isUserLoggedIn) {
      _showAuthenticationRequired();
      return;
    }

    if (!_bookingController.hasValidDateRange) {
      _showSnackBar(
        'Por favor selecciona las fechas de tu estadía',
        isError: true,
      );
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => BookingFormDialog(
        hotel: hotel,
        bookingController: _bookingController,
      ),
    );

    if (result == true) {
      _showSnackBar('¡Reserva creada exitosamente!', isError: false);
    }
  }

  void _showAuthenticationRequired() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.lock, color: Colors.orange[600]),
            const SizedBox(width: 8),
            const Text(
              'Autenticación requerida',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          'Debes autenticarte para poder realizar reservas de hoteles.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectCheckInDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _bookingController.selectedCheckInDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _bookingController.setCheckInDate(picked);
    }
  }

  Future<void> _selectCheckOutDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _bookingController.selectedCheckOutDate ??
          (_bookingController.selectedCheckInDate?.add(
                const Duration(days: 1),
              ) ??
              DateTime.now().add(const Duration(days: 1))),
      firstDate:
          _bookingController.selectedCheckInDate?.add(
            const Duration(days: 1),
          ) ??
          DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _bookingController.setCheckOutDate(picked);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
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
