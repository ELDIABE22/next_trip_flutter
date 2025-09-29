import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/features/bookings/data/controllers/car_booking_controller.dart';
import 'package:next_trip/features/bookings/data/models/car_booking_model.dart';

class BookingDetailsCar extends StatefulWidget {
  final CarBooking booking;

  const BookingDetailsCar({super.key, required this.booking});

  @override
  State<BookingDetailsCar> createState() => _BookingDetailsCarState();
}

class _BookingDetailsCarState extends State<BookingDetailsCar> {
  late final CarBookingController _bookingController;

  @override
  void initState() {
    super.initState();
    _bookingController = CarBookingController(
      onStateChanged: () {
        if (mounted) setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _bookingController.dispose();
    super.dispose();
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.completed:
        return const Color(0xFF4CAF50);
      case BookingStatus.cancelled:
        return const Color(0xFFF44336);
      case BookingStatus.inProgress:
        return const Color(0xFFFF9800);
      case BookingStatus.confirmed:
        return const Color(0xFF2196F3);
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final statusColor = _getStatusColor(booking.status);

    return Scaffold(
      appBar: Appbar(title: 'Detalles de la reserva'),
      body: Container(
        width: double.infinity,
        decoration: AppConstantsColors.radialBackground,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header con logo y nombre del carro
              Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Color(0xFFF6F3F3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  border: Border(bottom: BorderSide(width: 1)),
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo-app-black.webp',
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "NEXTRIP",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      booking.carName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Información del carro y reserva
              Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Color(0xFFF6F3F3),
                  border: Border(bottom: BorderSide(width: 1)),
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    _buildInfoRow(
                      'Estado:',
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 7,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: statusColor.withValues(alpha: 0.2),
                        ),
                        child: Text(
                          booking.statusDisplayText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Modelo:',
                      Text(
                        booking.carCategory,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Fecha:',
                      Text(
                        booking.dateRange,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Duración:',
                      Text(
                        booking.durationText,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Información del huésped y ubicaciones
              Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Color(0xFFF6F3F3),
                  border: Border(bottom: BorderSide(width: 1)),
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    _buildInfoRow(
                      'Nombre:',
                      Text(
                        booking.guestName,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Email:',
                      Text(
                        booking.guestEmail,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Teléfono:',
                      Text(
                        booking.guestPhone,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Licencia:',
                      Text(
                        booking.guestLicenseNumber,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Información de recogida y devolución
              Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Color(0xFFF6F3F3),
                  border: Border(bottom: BorderSide(width: 1)),
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    _buildInfoRow(
                      'Recogida:',
                      Expanded(
                        child: Text(
                          booking.pickupLocation,
                          style: const TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.end,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Hora:',
                      Text(
                        booking.pickupTimeFormatted,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Devolución:',
                      Expanded(
                        child: Text(
                          booking.returnLocation,
                          style: const TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.end,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Hora:',
                      Text(
                        booking.returnTimeFormatted,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Total y desglose de precios
              Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Color(0xFFF6F3F3),
                  border: Border(bottom: BorderSide(width: 1)),
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    _buildInfoRow(
                      'Subtotal:',
                      Text(
                        booking.formattedSubtotal,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Impuestos (19%):',
                      Text(
                        booking.formattedTaxes,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Seguro (10%):',
                      Text(
                        booking.formattedInsurance,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Total final
              Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Color(0xFFF6F3F3),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${booking.formattedTotalPrice} COP",
                      style: const TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _buildActionButtons(booking),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, Widget valueWidget) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEFECEC))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF8F8F8F), fontSize: 12),
          ),
          valueWidget,
        ],
      ),
    );
  }

  Widget _buildActionButtons(CarBooking booking) {
    if (booking.status == BookingStatus.confirmed && booking.canBeCancelled) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _bookingController.isLoading
                  ? null
                  : () => _cancelBooking(booking.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: _bookingController.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Cancelar Reserva',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Future<void> _cancelBooking(String bookingId) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Reserva'),
        content: const Text(
          '¿Estás seguro de que quieres cancelar esta reserva?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Sí, cancelar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _bookingController.cancelBooking(bookingId);

      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reserva cancelada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _bookingController.errorMessage ?? 'Error al cancelar la reserva',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
