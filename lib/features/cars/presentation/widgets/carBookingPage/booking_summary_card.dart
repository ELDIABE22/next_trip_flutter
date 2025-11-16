import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:next_trip/features/bookings/data/controllers/car_booking_controller.dart';
import 'package:next_trip/features/cars/infrastructure/models/car_model.dart';

class BookingSummaryCard extends StatelessWidget {
  final CarBookingController controller;
  final CarModel car;

  const BookingSummaryCard({
    super.key,
    required this.controller,
    required this.car,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCarSummary(),
        const SizedBox(height: 16),
        _buildDatesSummary(),
        const SizedBox(height: 16),
        _buildGuestSummary(),
        const SizedBox(height: 16),
        _buildPricingSummary(),
      ],
    );
  }

  Widget _buildCarSummary() {
    return _buildSummaryCard(
      title: 'Vehículo',
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/carro.webp',
              width: 60,
              height: 45,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  car.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  car.category,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            car.formattedPrice,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatesSummary() {
    return _buildSummaryCard(
      title: 'Fechas y ubicación',
      child: Column(
        children: [
          _buildSummaryRow(
            'Recogida',
            '${_formatDate(controller.selectedPickupDate)} - ${_formatTime(controller.selectedPickupTime)}',
          ),
          const SizedBox(height: 8),
          _buildSummaryRow('Lugar', controller.pickupLocation),
          const Divider(height: 16),
          _buildSummaryRow(
            'Devolución',
            '${_formatDate(controller.selectedReturnDate)} - ${_formatTime(controller.selectedReturnTime)}',
          ),
          const SizedBox(height: 8),
          _buildSummaryRow('Lugar', controller.returnLocation),
          const Divider(height: 16),
          _buildSummaryRow(
            'Duración',
            '${controller.numberOfDays} días',
            isHighlight: true,
          ),
        ],
      ),
    );
  }

  Widget _buildGuestSummary() {
    return _buildSummaryCard(
      title: 'Conductor principal',
      child: Column(
        children: [
          _buildSummaryRow('Nombre', controller.guestName),
          const SizedBox(height: 8),
          _buildSummaryRow('Email', controller.guestEmail),
          const SizedBox(height: 8),
          _buildSummaryRow('Teléfono', controller.guestPhone),
          const SizedBox(height: 8),
          _buildSummaryRow('Licencia', controller.guestLicenseNumber),
        ],
      ),
    );
  }

  Widget _buildPricingSummary() {
    final subtotal = controller.calculateSubtotal(car);
    final taxes = controller.calculateTaxes(car);
    final insurance = controller.calculateInsurance(car);
    final total = controller.calculateTotalPrice(car);

    return _buildSummaryCard(
      title: 'Resumen de precios',
      child: Column(
        children: [
          _buildPriceRow(
            'Subtotal (${controller.numberOfDays} días)',
            _formatPrice(subtotal),
          ),
          const SizedBox(height: 8),
          _buildPriceRow('Impuestos (19%)', _formatPrice(taxes)),
          const SizedBox(height: 8),
          _buildPriceRow('Seguro (10%)', _formatPrice(insurance)),
          const Divider(height: 16),
          _buildPriceRow('Total', _formatPrice(total), isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
            color: isHighlight ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'No seleccionada';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'No seleccionada';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatPrice(double price) {
    return '\$${price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }
}
