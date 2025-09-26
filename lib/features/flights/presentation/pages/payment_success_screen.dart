import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:next_trip/core/utils/helpers.dart';
import 'package:next_trip/core/widgets/custom_button.dart';
import 'package:next_trip/features/bookings/presentation/page/bookings_page.dart';
import 'package:next_trip/features/flights/data/models/flight_model.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final Flight flight;
  final int passengerCount;
  final int totalPrice;

  const PaymentSuccessScreen({
    super.key,
    required this.flight,
    required this.passengerCount,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Animated Checkmark
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Color(0xFF38b000).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Color(0xFF38b000),
                    size: 100,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                '¡Pago Exitoso!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF38b000),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Tu vuelo ha sido reservado exitosamente.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Detalles del vuelo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              // Flight details card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildDetailRow('Aerolínea', flight.airline ?? 'N/A'),
                        const Divider(),
                        _buildDetailRow(
                          'Número de vuelo',
                          flight.flightNumber ?? 'N/A',
                        ),
                        const Divider(),
                        _buildDetailRow(
                          'Origen',
                          '${flight.originCity} (${flight.originIata})',
                        ),
                        const Divider(),
                        _buildDetailRow(
                          'Destino',
                          '${flight.destinationCity} (${flight.destinationIata})',
                        ),
                        const Divider(),
                        _buildDetailRow(
                          'Fecha de salida',
                          formatDate(
                            flight.departureDateTime.toIso8601String(),
                          ),
                        ),
                        const Divider(),
                        _buildDetailRow(
                          'Hora de salida',
                          flight.departureTimeStr,
                        ),
                        const Divider(),
                        _buildDetailRow(
                          'Hora de llegada',
                          flight.arrivalTimeStr,
                        ),
                        const Divider(),
                        _buildDetailRow('Duración', flight.durationLabel),
                        const Divider(),
                        _buildDetailRow('Pasajeros', passengerCount.toString()),
                        const Divider(),
                        _buildDetailRow(
                          'Total',
                          '\$${NumberFormat('#,##0', 'es_CO').format(totalPrice)} COP',
                          isBold: true,
                          textColor: Color(0xFF38b000),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Action buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    CustomButton(
                      text: 'Ver mis reservas',
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BookingsPage(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBold = false,
    Color? textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 15)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: textColor ?? Colors.black87,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
