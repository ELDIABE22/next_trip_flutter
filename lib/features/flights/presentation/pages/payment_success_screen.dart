import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:next_trip/core/utils/helpers.dart';
import 'package:next_trip/core/widgets/custom_button.dart';
import 'package:next_trip/features/bookings/presentation/page/bookings_page.dart';
import 'package:next_trip/features/flights/domain/entities/flight.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final Flight flight;
  final int passengerCount;
  final int totalPrice;
  final bool isRoundTrip;
  final Flight? returnFlight;

  const PaymentSuccessScreen({
    super.key,
    required this.flight,
    required this.passengerCount,
    required this.totalPrice,
    this.isRoundTrip = false,
    this.returnFlight,
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
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xFF38b000).withAlpha(25),
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
                  isRoundTrip
                      ? 'Tu reserva de ida y vuelta ha sido confirmada exitosamente.'
                      : 'Tu vuelo ha sido reservado exitosamente.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isRoundTrip
                      ? Colors.blue.withAlpha(25)
                      : Colors.green.withAlpha(25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isRoundTrip
                        ? Colors.blue.withAlpha(75)
                        : Colors.green.withAlpha(75),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isRoundTrip ? Icons.swap_horiz : Icons.flight,
                      size: 16,
                      color: isRoundTrip ? Colors.blue : Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isRoundTrip ? 'Ida y Vuelta' : 'Solo Ida',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isRoundTrip ? Colors.blue : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Detalles de la reserva',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              if (isRoundTrip) ...[
                _buildFlightCard(
                  context,
                  flight,
                  'Vuelo de Ida',
                  Icons.flight_takeoff,
                ),
                const SizedBox(height: 16),
                if (returnFlight != null)
                  _buildFlightCard(
                    context,
                    returnFlight!,
                    'Vuelo de Regreso',
                    Icons.flight_land,
                  ),
              ] else ...[
                _buildFlightCard(
                  context,
                  flight,
                  'Detalles del Vuelo',
                  Icons.flight,
                ),
              ],
              const SizedBox(height: 16),
              _buildSummaryCard(),
              const SizedBox(height: 32),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withAlpha(50)),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Información importante',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Recibirás un email de confirmación en breve\n'
                      '• Presenta tu documento de identidad en el aeropuerto\n'
                      '• Llega 2 horas antes para vuelos nacionales\n'
                      '• Puedes gestionar tu reserva desde "Mis Reservas"',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
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

  Widget _buildFlightCard(
    BuildContext context,
    Flight flight,
    String title,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDetailRow('Aerolínea', flight.airline ?? 'N/A'),
              const Divider(height: 20),
              _buildDetailRow('Número de vuelo', flight.flightNumber ?? 'N/A'),
              const Divider(height: 20),
              _buildDetailRow(
                'Ruta',
                '${flight.originCity} (${flight.originIata}) → ${flight.destinationCity} (${flight.destinationIata})',
              ),
              const Divider(height: 20),
              _buildDetailRow(
                'Fecha',
                formatDateWithWeekday(
                  flight.departureDateTime.toIso8601String(),
                ),
              ),
              const Divider(height: 20),
              _buildDetailRow(
                'Horario',
                '${formatTime(flight.departureDateTime.toIso8601String())} → ${formatTime(flight.arrivalDateTime.toIso8601String())}',
              ),
              const Divider(height: 20),
              _buildDetailRow('Duración', _formatDuration(flight.duration)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Card(
        elevation: 2,
        color: const Color(0xFF38b000).withAlpha(25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: const Color(0xFF38b000).withAlpha(75)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Row(
                children: [
                  Icon(Icons.receipt_long, color: Color(0xFF38b000), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Resumen del Pago',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF38b000),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDetailRow('Pasajeros', passengerCount.toString()),
              const Divider(height: 20),
              _buildDetailRow(
                'Total Pagado',
                '\$${NumberFormat('#,##0', 'es_CO').format(totalPrice)} COP',
                isBold: true,
                textColor: const Color(0xFF38b000),
              ),
              if (isRoundTrip) ...[
                const Divider(height: 20),
                const Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      'Incluye vuelos de ida y regreso',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: textColor ?? Colors.black87,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
  }
}
