import 'package:flutter/material.dart';
import 'package:next_trip/features/flights/data/models/flight_model.dart';

class FlightCard extends StatelessWidget {
  final String total;
  final String? flightDate;
  final String? departureTime;
  final String? arrivalTime;
  final String? originIata;
  final String? destinationIata;
  final String? durationLabel;
  final bool? isDirect;
  final String? currency;
  final bool navigateToSeatsOnTap;
  final VoidCallback? onTap;
  final bool showSelectButton;
  final bool isSelected;
  final Flight? flight;

  const FlightCard({
    super.key,
    this.flightDate,
    required this.total,
    this.departureTime,
    this.arrivalTime,
    this.originIata,
    this.destinationIata,
    this.durationLabel,
    this.isDirect,
    this.currency,
    this.navigateToSeatsOnTap = true,
    this.onTap,
    this.showSelectButton = false,
    this.isSelected = false,
    this.flight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigateToSeatsOnTap ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: isSelected ? Border.all(color: Colors.green, width: 2) : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            // Header con información del vuelo
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  // Información principal del vuelo
                  Row(
                    children: [
                      // Salida
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              departureTime ?? '—',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              originIata ?? '',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Información del vuelo (centro)
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.green
                                        : Colors.blue,
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                                Icon(
                                  Icons.flight,
                                  color: isSelected
                                      ? Colors.green
                                      : Colors.blue,
                                  size: 18,
                                ),
                                Container(
                                  width: 40,
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.green
                                        : Colors.blue,
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              (isDirect ?? true) ? 'Directo' : 'Con escalas',
                              style: TextStyle(
                                color: isSelected ? Colors.green : Colors.blue,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              durationLabel ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Llegada
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              arrivalTime ?? '—',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              destinationIata ?? '',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Información adicional del vuelo
                  if (flight != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          flight!.airline ?? 'Aerolínea',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (flight!.flightNumber != null)
                          Text(
                            flight!.flightNumber!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        Text(
                          flight!.availabilityText,
                          style: TextStyle(
                            fontSize: 12,
                            color: flight!.availabilityColor == 'green'
                                ? Colors.green
                                : flight!.availabilityColor == 'orange'
                                ? Colors.orange
                                : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Fecha del vuelo
                  if (flightDate != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      flightDate!,
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ],
              ),
            ),

            // Footer con precio y botón
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.green.withValues(alpha: 0.05)
                    : const Color(0xFFEFECEC),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Precio
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Desde',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              currency ?? 'COP',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              total,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        if (flight != null)
                          Text(
                            flight!.priceCategory,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),

                  if (showSelectButton) ...[
                    const SizedBox(width: 16),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: ElevatedButton.icon(
                        onPressed: isSelected ? null : onTap,
                        icon: Icon(
                          isSelected ? Icons.check : Icons.arrow_forward,
                          size: 16,
                        ),
                        label: Text(
                          isSelected ? 'Seleccionado' : 'Seleccionar',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? Colors.green
                              : Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          elevation: isSelected ? 0 : 2,
                        ),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.black54,
                      size: 24,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
