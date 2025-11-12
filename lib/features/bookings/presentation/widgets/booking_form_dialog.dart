import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:next_trip/core/utils/form_validators.dart';
import 'package:next_trip/core/widgets/input.dart';
import 'package:next_trip/features/bookings/data/controllers/hotel_booking_controller.dart';
import 'package:next_trip/features/hotels/infrastructure/models/hotel_model.dart';
import 'package:next_trip/features/hotels/presentation/page/payment_success_page.dart';

class BookingFormDialog extends StatefulWidget {
  final HotelModel hotel;
  final HotelBookingController bookingController;

  const BookingFormDialog({
    super.key,
    required this.hotel,
    required this.bookingController,
  });

  @override
  State<BookingFormDialog> createState() => _BookingFormDialogState();
}

class _BookingFormDialogState extends State<BookingFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _requestsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.bookingController.guestName;
    _emailController.text = widget.bookingController.guestEmail;
    _phoneController.text = widget.bookingController.guestPhone;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _requestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Expanded(
            child: Text(
              'Información del Huésped',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBookingSummary(),
                const SizedBox(height: 20),

                _buildNameField(),
                const SizedBox(height: 16),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPhoneField(),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: widget.bookingController.isCreatingBooking
              ? null
              : _handleCreateBooking,
          child: widget.bookingController.isCreatingBooking
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Confirmar Reserva'),
        ),
      ],
    );
  }

  Widget _buildBookingSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.hotel.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                '${widget.bookingController.selectedCheckInDate!.day}/${widget.bookingController.selectedCheckInDate!.month}/${widget.bookingController.selectedCheckInDate!.year}',
                style: const TextStyle(fontSize: 14),
              ),
              const Text(' - '),
              Text(
                '${widget.bookingController.selectedCheckOutDate!.day}/${widget.bookingController.selectedCheckOutDate!.month}/${widget.bookingController.selectedCheckOutDate!.year}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.nights_stay, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                '${widget.bookingController.numberOfNights} noches',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.bookingController.getFormattedTotalPrice(widget.hotel),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Input(
      controller: _nameController,
      labelText: 'Nombre completo *',
      prefixIcon: Icons.person,
      validator: FormValidators.validateFullName,
    );
  }

  Widget _buildEmailField() {
    return Input(
      controller: _emailController,
      labelText: 'Correo electrónico *',
      prefixIcon: Icons.email,
      validator: FormValidators.validateEmail,
    );
  }

  Widget _buildPhoneField() {
    return Input(
      controller: _phoneController,
      labelText: 'Número de teléfono *',
      prefixIcon: Icons.phone,
      validator: FormValidators.validatePhoneNumber,
    );
  }

  Future<void> _handleCreateBooking() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    widget.bookingController.setGuestInfo(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    final String userId = FirebaseAuth.instance.currentUser!.uid;

    final success = await widget.bookingController.createBooking(
      hotel: widget.hotel,
      userId: userId,
      specialRequests: _requestsController.text.trim().isNotEmpty
          ? _requestsController.text.trim()
          : null,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PaymentSuccessPage(
            booking: widget.bookingController.selectedBooking!,
            paymentMethod: 'Tarjeta de crédito',
            transactionId: 'TXN${DateTime.now().millisecondsSinceEpoch}',
          ),
        ),
      );
    }
  }
}
