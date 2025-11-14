import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/features/bookings/application/bloc/hotel_booking/hotel_booking_bloc.dart';
import 'package:next_trip/features/bookings/application/bloc/hotel_booking/hotel_booking_event.dart';
import 'package:next_trip/features/bookings/application/bloc/hotel_booking/hotel_booking_state.dart';
import 'package:next_trip/features/bookings/domain/entities/hotel_booking.dart';
import 'package:next_trip/features/bookings/infrastructure/models/hotel_booking_model.dart';

class BookingDetailsHotel extends StatefulWidget {
  final HotelBookingModel booking;

  const BookingDetailsHotel({super.key, required this.booking});

  @override
  State<BookingDetailsHotel> createState() => _BookingDetailsHotelState();
}

class _BookingDetailsHotelState extends State<BookingDetailsHotel> {
  late HotelBookingModel _currentBooking;
  bool _isCancelling = false;

  @override
  void initState() {
    super.initState();
    _currentBooking = widget.booking;
  }

  Color _getStatusColor() {
    switch (_currentBooking.status) {
      case BookingStatus.completed:
        return const Color(0xFF4CAF50);
      case BookingStatus.cancelled:
        return const Color(0xFFF44336);
      case BookingStatus.confirmed:
        return const Color(0xFF2196F3);
    }
  }

  // Verificar si la reserva se puede cancelar
  bool get _canCancelBooking {
    return _currentBooking.status != BookingStatus.cancelled &&
        _currentBooking.status != BookingStatus.completed;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return BlocListener<HotelBookingBloc, HotelBookingState>(
      listener: (context, state) {
        if (state is HotelBookingSuccess) {
          setState(() {
            _currentBooking = _currentBooking.copyWith(
              status: BookingStatus.cancelled,
              updatedAt: DateTime.now(),
            );
            _isCancelling = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Reserva cancelada exitosamente',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 3),
            ),
          );

          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop(true);
            }
          });
        } else if (state is HotelBookingError) {
          setState(() {
            _isCancelling = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      state.error,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: Appbar(title: 'Detalles de la reserva'),
        body: Container(
          decoration: AppConstantsColors.radialBackground,
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final horizontalPadding = screenWidth > 600
                    ? screenWidth * 0.15
                    : 20.0;

                final maxContentWidth = screenWidth > 800
                    ? 600.0
                    : double.infinity;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 20,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: maxContentWidth,
                        minHeight: constraints.maxHeight - 100,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header con logo y nombre del hotel
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
                                    _currentBooking.hotelDetails.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),

                            // Detalles de la reserva
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF6F3F3),
                                border: Border(bottom: BorderSide(width: 1)),
                              ),
                              width: double.infinity,
                              child: Column(
                                children: [
                                  // Estado
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color(0xFFEFECEC),
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Estado:",
                                          style: TextStyle(
                                            color: Color(0xFF8F8F8F),
                                            fontSize: 12,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 7,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                            color: statusColor.withValues(
                                              alpha: 0.2,
                                            ),
                                          ),
                                          child: Text(
                                            _currentBooking.statusDisplayText,
                                            style: TextStyle(
                                              color: statusColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Dirección
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color(0xFFEFECEC),
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Dirección:",
                                          style: TextStyle(
                                            color: Color(0xFF8F8F8F),
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            _currentBooking
                                                .hotelDetails
                                                .address,
                                            style: const TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 15,
                                            ),
                                            textAlign: TextAlign.right,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  Container(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color(0xFFEFECEC),
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Fechas:",
                                          style: TextStyle(
                                            color: Color(0xFF8F8F8F),
                                            fontSize: 12,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            '${_currentBooking.checkInFormatted} - ${_currentBooking.checkOutFormatted}',
                                            style: const TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 15,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Noches:",
                                        style: TextStyle(
                                          color: Color(0xFF8F8F8F),
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '${_currentBooking.numberOfNights} noches',
                                        style: const TextStyle(
                                          color: Color(0xFF000000),
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Información del huésped
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF6F3F3),
                                border: Border(bottom: BorderSide(width: 1)),
                              ),
                              width: double.infinity,
                              child: Column(
                                children: [
                                  // Nombre
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Nombre:",
                                        style: TextStyle(
                                          color: Color(0xFF8F8F8F),
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          _currentBooking.guestName,
                                          style: const TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.right,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Email
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Email:",
                                        style: TextStyle(
                                          color: Color(0xFF8F8F8F),
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          _currentBooking.guestEmail,
                                          style: const TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.right,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Teléfono
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Teléfono:",
                                        style: TextStyle(
                                          color: Color(0xFF8F8F8F),
                                          fontSize: 12,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          _currentBooking.guestPhone,
                                          style: const TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Información adicional
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF6F3F3),
                                border: Border(bottom: BorderSide(width: 1)),
                              ),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "ID de Reserva:",
                                    style: TextStyle(
                                      color: Color(0xFF8F8F8F),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      '#${_currentBooking.id.substring(0, 8)}',
                                      style: const TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Total
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Total:",
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      _currentBooking.formattedTotalPrice,
                                      style: const TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Botón de cancelar
                            if (_canCancelBooking) ...[
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isCancelling
                                      ? null
                                      : () => _showCancelDialog(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isCancelling
                                        ? Colors.grey
                                        : Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      vertical: screenWidth > 600 ? 20 : 15,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: _isCancelling
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Cancelando...',
                                              style: TextStyle(
                                                fontSize: screenWidth > 600
                                                    ? 18
                                                    : 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          'Cancelar Reserva',
                                          style: TextStyle(
                                            fontSize: screenWidth > 600
                                                ? 18
                                                : 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                            ],

                            // Mensaje informativo si no se puede cancelar
                            if (!_canCancelBooking) ...[
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _currentBooking.status ==
                                                BookingStatus.cancelled
                                            ? 'Esta reserva ya ha sido cancelada'
                                            : 'Esta reserva ya ha sido completada',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            SizedBox(
                              height:
                                  MediaQuery.of(context).viewInsets.bottom + 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange[600],
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text(
              'Cancelar Reserva',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Estás seguro de que deseas cancelar esta reserva?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.orange[700]),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Esta acción no se puede deshacer',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Hotel: ${_currentBooking.hotelDetails.name}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              'Fechas: ${_currentBooking.checkInFormatted} - ${_currentBooking.checkOutFormatted}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              'Total: ${_currentBooking.formattedTotalPrice}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'No, Mantener',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(true);
                }
              });

              _cancelBooking();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Sí, Cancelar',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _cancelBooking() {
    setState(() {
      _isCancelling = true;
    });

    context.read<HotelBookingBloc>().add(
      CancelBookingRequested(_currentBooking.id),
    );
  }
}
