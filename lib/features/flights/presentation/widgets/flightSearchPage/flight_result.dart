import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:next_trip/features/flights/data/controllers/flight_controller.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/flight_card.dart';
import 'package:next_trip/features/flights/presentation/pages/flight_seats_page.dart';

class FlightResult extends StatelessWidget {
  const FlightResult({
    super.key,
    required this.controller,
    required this.originCity,
    required this.originCountry,
    required this.title,
    this.showSelectButton = false,
    this.onFlightSelected,
    this.isReturnTrip = false,
  });

  final FlightController controller;
  final String originCity;
  final String originCountry;
  final String title;
  final bool showSelectButton;
  final VoidCallback? onFlightSelected;
  final bool isReturnTrip;

  @override
  Widget build(BuildContext context) {
    final flights = isReturnTrip
        ? controller.returnFlights
        : controller.flights;
    final isLoading = isReturnTrip
        ? controller.returnLoading
        : controller.loading;

    // Estado de carga
    if (isLoading && flights.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              isReturnTrip
                  ? 'Buscando vuelos de regreso...'
                  : 'Buscando vuelos...',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      );
    }

    // Estado de error
    if (controller.error != null && flights.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(
              isReturnTrip
                  ? 'Error al buscar vuelos de regreso'
                  : 'Error al buscar vuelos',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Estado vacío
    if (flights.isEmpty && !isLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(
              isReturnTrip ? Icons.flight_land : Icons.flight_takeoff_outlined,
              size: 48,
              color: Colors.black,
            ),
            const SizedBox(height: 12),
            Text(
              isReturnTrip
                  ? 'No se encontraron vuelos de regreso'
                  : 'No se encontraron vuelos',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isReturnTrip
                  ? 'Intenta con fechas diferentes para el regreso'
                  : 'Intenta con fechas o destinos diferentes',
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),

        const SizedBox(height: 16),

        ...flights.asMap().entries.map((entry) {
          final flight = entry.value;
          final dateStr = DateFormat(
            'dd/MM/yyyy',
          ).format(flight.departureDateTime);

          final isSelected = isReturnTrip
              ? controller.selectedReturnFlight?.id == flight.id
              : controller.selectedOutboundFlight?.id == flight.id;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: FlightCard(
              total: flight.totalPriceLabelCop,
              flightDate: dateStr,
              departureTime: flight.departureTimeStr,
              arrivalTime: flight.arrivalTimeStr,
              originIata: flight.originIata,
              destinationIata: flight.destinationIata,
              durationLabel: flight.durationLabel,
              isDirect: flight.isDirect,
              showSelectButton: showSelectButton,
              isSelected: isSelected,
              flight: flight,
              onTap: () => _handleFlightTap(context, flight),
            ),
          );
        }),

        if (controller.isRoundTrip && controller.hasCompleteRoundTrip)
          _buildContinueButton(context),

        if (flights.isNotEmpty) _buildFlightInfo(),
      ],
    );
  }

  Widget _buildHeader() {
    final flights = isReturnTrip
        ? controller.returnFlights
        : controller.flights;
    final destinationName =
        isReturnTrip && controller.selectedOutboundFlight != null
        ? controller.selectedOutboundFlight!.originCity
        : originCountry;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isReturnTrip
              ? [
                  Colors.orange.withValues(alpha: 0.1),
                  Colors.orange.withValues(alpha: 0.05),
                ]
              : [
                  Colors.blue.withValues(alpha: 0.1),
                  Colors.blue.withValues(alpha: 0.05),
                ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isReturnTrip
              ? Colors.orange.withValues(alpha: 0.3)
              : Colors.blue.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isReturnTrip ? Icons.flight_land : Icons.flight_takeoff,
            size: 28,
            color: isReturnTrip ? Colors.orange : Colors.blue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$originCity → $destinationName',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isReturnTrip ? Colors.orange : Colors.blue,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              '${flights.length} vuelos',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 24),
              SizedBox(width: 8),
              Text(
                'Vuelos seleccionados',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ida: ${controller.selectedOutboundFlight!.routeTitle}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Regreso: ${controller.selectedReturnFlight!.routeTitle}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total: ${controller.formattedTotalRoundTripPrice} COP',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FlightSeatsPage(
                        flight: controller.selectedOutboundFlight!,
                        returnFlight: controller.selectedReturnFlight,
                        isRoundTrip: true,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Continuar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlightInfo() {
    final stats = controller.getSearchStatistics(isReturnFlight: isReturnTrip);

    if (stats.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información de la búsqueda',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vuelos directos: ${stats['directFlights']}',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
              Text(
                'Con escalas: ${stats['connectingFlights']}',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Precio desde: \$${NumberFormat('#,###').format(stats['minPrice'])}',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
              Text(
                'Aerolíneas: ${stats['airlines']}',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleFlightTap(BuildContext context, flight) {
    if (showSelectButton) {
      controller.selectOutboundFlight(flight);
      onFlightSelected?.call();
    } else if (isReturnTrip) {
      controller.selectReturnFlight(flight);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              FlightSeatsPage(flight: flight, isRoundTrip: false),
        ),
      );
    }
  }
}
