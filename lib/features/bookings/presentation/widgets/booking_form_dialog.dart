import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_trip/core/utils/form_validators.dart';
import 'package:next_trip/core/widgets/input.dart';
import 'package:next_trip/features/bookings/application/bloc/hotel_booking/hotel_booking_bloc.dart';
import 'package:next_trip/features/bookings/application/bloc/hotel_booking/hotel_booking_event.dart';
import 'package:next_trip/features/bookings/application/bloc/hotel_booking/hotel_booking_state.dart';
import 'package:next_trip/features/hotels/infrastructure/models/hotel_model.dart';
import 'package:next_trip/features/hotels/presentation/page/payment_success_page.dart';

class BookingFormDialog extends StatefulWidget {
  final HotelModel hotel;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numberOfNights;

  const BookingFormDialog({
    super.key,
    required this.hotel,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfNights,
  });

  @override
  State<BookingFormDialog> createState() => _BookingFormDialogState();
}

class _BookingFormDialogState extends State<BookingFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isCreatingBooking = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String _getFormattedTotalPrice() {
    final totalPrice = widget.hotel.price * widget.numberOfNights;
    return '\$${totalPrice.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HotelBookingBloc, HotelBookingState>(
      listener: (context, state) {
        if (state is HotelBookingSuccess) {
          setState(() {
            _isCreatingBooking = false;
          });

          Navigator.of(context).pop(true);

          if (state.booking != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PaymentSuccessPage(
                  booking: state.booking!,
                  paymentMethod: 'Tarjeta de crédito',
                  transactionId: 'TXN${DateTime.now().millisecondsSinceEpoch}',
                ),
              ),
            );
          }
        } else if (state is HotelBookingError) {
          setState(() {
            _isCreatingBooking = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        } else if (state is HotelBookingLoading) {
          setState(() {
            _isCreatingBooking = true;
          });
        }
      },
      child: AlertDialog(
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
            onPressed: _isCreatingBooking ? null : _handleCreateBooking,
            child: _isCreatingBooking
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Confirmar Reserva'),
          ),
        ],
      ),
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
                '${widget.checkInDate.day}/${widget.checkInDate.month}/${widget.checkInDate.year}',
                style: const TextStyle(fontSize: 14),
              ),
              const Text(' - '),
              Text(
                '${widget.checkOutDate.day}/${widget.checkOutDate.month}/${widget.checkOutDate.year}',
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
                '${widget.numberOfNights} noches',
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
                _getFormattedTotalPrice(),
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

  void _handleCreateBooking() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String userId = FirebaseAuth.instance.currentUser!.uid;

    context.read<HotelBookingBloc>().add(
      CreateBookingRequested(
        hotel: widget.hotel,
        userId: userId,
        guestName: _nameController.text.trim(),
        guestEmail: _emailController.text.trim(),
        guestPhone: _phoneController.text.trim(),
        checkInDate: widget.checkInDate,
        checkOutDate: widget.checkOutDate,
      ),
    );
  }
}
