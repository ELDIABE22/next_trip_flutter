import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/features/bookings/infrastructure/models/hotel_booking_model.dart';
import 'package:next_trip/routes/app_routes.dart';

class PaymentSuccessPage extends StatefulWidget {
  final HotelBookingModel booking;
  final String paymentMethod;
  final String transactionId;

  const PaymentSuccessPage({
    super.key,
    required this.booking,
    this.paymentMethod = 'Tarjeta de crédito',
    required this.transactionId,
  });

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
    _vibrate();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startAnimations() {
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _fadeAnimationController.forward();
    });
  }

  void _vibrate() {
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppConstantsColors.radialBackground,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),

              // Contenido principal
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      // Ícono de éxito animado
                      _buildSuccessIcon(),

                      const SizedBox(height: 32),

                      // Título y mensaje de éxito
                      _buildSuccessMessage(),

                      const SizedBox(height: 40),

                      // Tarjeta con detalles de la reserva
                      _buildBookingDetails(),

                      const SizedBox(height: 24),

                      // Detalles del pago
                      _buildPaymentDetails(),

                      const SizedBox(height: 40),

                      // Botones de acción
                      _buildActionButtons(),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 40),
          const Text(
            'Pago Exitoso',
            style: TextStyle(
              color: Colors.green,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: () => _navigateToHome(),
            icon: const Icon(Icons.close, color: Colors.black, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.green.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(Icons.check_rounded, size: 60, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          const Text(
            '¡Reserva Confirmada!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Tu pago se ha procesado exitosamente.\nHemos enviado los detalles a tu correo.',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetails() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image:
                          widget.booking.hotelDetails.imageUrl.startsWith(
                            'http',
                          )
                          ? NetworkImage(widget.booking.hotelDetails.imageUrl)
                          : const AssetImage('assets/images/hotel.webp')
                                as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.booking.hotelDetails.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Container(height: 1, color: Colors.grey[200]),

            const SizedBox(height: 20),

            // Detalles de la reserva
            _buildDetailRow(
              'ID de Reserva',
              '#${widget.booking.id.substring(0, 8)}',
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Huésped', widget.booking.guestName),
            const SizedBox(height: 12),
            _buildDetailRow('Check-in', widget.booking.checkInFormatted),
            const SizedBox(height: 12),
            _buildDetailRow('Check-out', widget.booking.checkOutFormatted),
            const SizedBox(height: 12),
            _buildDetailRow('Noches', '${widget.booking.numberOfNights}'),
            const SizedBox(height: 12),
            _buildDetailRow(
              'Huéspedes',
              '${widget.booking.hotelDetails.maxGuests}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detalles del Pago',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            _buildDetailRow('Método de pago', widget.paymentMethod),
            const SizedBox(height: 12),
            _buildDetailRow('ID de transacción', widget.transactionId),
            const SizedBox(height: 12),
            _buildDetailRow(
              'Fecha de pago',
              widget.booking.bookingDateFormatted,
            ),

            const SizedBox(height: 16),

            Container(height: 1, color: Colors.grey[200]),

            const SizedBox(height: 16),

            // Total pagado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Pagado',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  widget.booking.formattedTotalPrice,
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
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _navigateToBookings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Ver Mis Reservas',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Botones secundarios
          // Row(
          //   children: [
          //     Expanded(
          //       child: SizedBox(
          //         height: 50,
          //         child: OutlinedButton(
          //           onPressed: _shareBooking,
          //           style: OutlinedButton.styleFrom(
          //             foregroundColor: Colors.white,
          //             side: const BorderSide(color: Colors.white, width: 2),
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(25),
          //             ),
          //           ),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               const Icon(Icons.share, size: 18),
          //               const SizedBox(width: 6),
          //               const Text(
          //                 'Compartir',
          //                 style: TextStyle(fontWeight: FontWeight.w500),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),

          //     const SizedBox(width: 16),

          //     Expanded(
          //       child: SizedBox(
          //         height: 50,
          //         child: OutlinedButton(
          //           onPressed: _downloadReceipt,
          //           style: OutlinedButton.styleFrom(
          //             foregroundColor: Colors.white,
          //             side: const BorderSide(color: Colors.white, width: 2),
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(25),
          //             ),
          //           ),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               const Icon(Icons.download, size: 18),
          //               const SizedBox(width: 6),
          //               const Text(
          //                 'Descargar',
          //                 style: TextStyle(fontWeight: FontWeight.w500),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          TextButton(
            onPressed: _navigateToHome,
            child: const Text(
              'Continuar explorando hoteles',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);

    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  void _navigateToBookings() {
    Navigator.of(context).popUntil((route) => route.isFirst);

    Navigator.pushReplacementNamed(context, AppRoutes.bookings);
  }

  // void _shareBooking() {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Funcionalidad de compartir próximamente'),
  //       backgroundColor: Colors.orange,
  //     ),
  //   );
  // }

  // void _downloadReceipt() {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Descarga de comprobante próximamente'),
  //       backgroundColor: Colors.green,
  //     ),
  //   );
  // }
}
