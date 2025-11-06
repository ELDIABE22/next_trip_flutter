import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:next_trip/features/flights/domain/entities/flight.dart';

class FlightCard extends StatefulWidget {
  final Flight flight;
  final bool showSelectButton;
  final bool isSelected;
  final VoidCallback? onTap;

  const FlightCard({
    super.key,
    required this.flight,
    this.showSelectButton = false,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<FlightCard> createState() => _FlightCardState();
}

class _FlightCardState extends State<FlightCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  String get departureTime =>
      DateFormat('HH:mm').format(widget.flight.departureDateTime);
  String get arrivalTime =>
      DateFormat('HH:mm').format(widget.flight.arrivalDateTime);
  String get durationLabel {
    final hours = widget.flight.duration.inHours;
    final minutes = widget.flight.duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  String get total => NumberFormat('#,###').format(widget.flight.totalPriceCop);
  String get flightDate =>
      DateFormat('dd/MM/yyyy').format(widget.flight.departureDateTime);

  String get availabilityText {
    final seats = widget.flight.availableSeats ?? 0;
    if (seats > 10) return '$seats disponibles';
    if (seats > 5) return 'Pocas plazas';
    return 'Últimas plazas';
  }

  String get availabilityColor {
    final seats = widget.flight.availableSeats ?? 0;
    if (seats > 10) return 'green';
    if (seats > 5) return 'orange';
    return 'red';
  }

  String get priceCategory {
    if (widget.flight.totalPriceCop < 200000) return 'Económico';
    if (widget.flight.totalPriceCop < 500000) return 'Medio';
    return 'Premium';
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _shadowAnimation = Tween<double>(begin: 8.0, end: 4.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.isSelected ? Colors.green : Colors.black;
    final backgroundColor = widget.isSelected
        ? Colors.green.withAlpha(12)
        : Colors.white;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: widget.isSelected
                    ? Border.all(color: Colors.green, width: 2)
                    : Border.all(color: Colors.grey.withAlpha(25), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: widget.isSelected
                        ? Colors.green.withAlpha(65)
                        : Colors.black.withAlpha(20),
                    spreadRadius: widget.isSelected ? 1 : 0,
                    blurRadius: _shadowAnimation.value,
                    offset: Offset(0, _shadowAnimation.value / 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.isSelected
                          ? [
                              Colors.green.withAlpha(20),
                              Colors.green.withAlpha(5),
                            ]
                          : [Colors.white, Colors.grey.withAlpha(5)],
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              backgroundColor,
                              backgroundColor.withAlpha(180),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        departureTime,
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey[900],
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.flight.originIata,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        widget.flight.originCity,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 45,
                                            height: 2,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  primaryColor.withAlpha(75),
                                                  primaryColor,
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(1),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: primaryColor.withAlpha(
                                                    75,
                                                  ),
                                                  blurRadius: 8,
                                                  spreadRadius: 0,
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.flight,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                          Container(
                                            width: 45,
                                            height: 2,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  primaryColor,
                                                  primaryColor.withAlpha(75),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(1),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  (widget.flight.isDirect ??
                                                      true)
                                                  ? Colors.green.withAlpha(25)
                                                  : Colors.orange.withAlpha(25),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color:
                                                    (widget.flight.isDirect ??
                                                        true)
                                                    ? Colors.green.withAlpha(75)
                                                    : Colors.orange.withAlpha(
                                                        75,
                                                      ),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  (widget.flight.isDirect ??
                                                          true)
                                                      ? Icons.trending_flat
                                                      : Icons
                                                            .connecting_airports,
                                                  size: 12,
                                                  color:
                                                      (widget.flight.isDirect ??
                                                          true)
                                                      ? Colors.green[700]
                                                      : Colors.orange[700],
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  (widget.flight.isDirect ??
                                                          true)
                                                      ? 'Directo'
                                                      : 'Escalas',
                                                  style: TextStyle(
                                                    color:
                                                        (widget
                                                                .flight
                                                                .isDirect ??
                                                            true)
                                                        ? Colors.green[700]
                                                        : Colors.orange[700],
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        durationLabel,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        arrivalTime,
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey[900],
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.flight.destinationIata,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        widget.flight.destinationCity,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.withAlpha(12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.withAlpha(25),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withAlpha(25),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.business,
                                            size: 14,
                                            color: Colors.blue[700],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.flight.airline ??
                                                    'Aerolínea',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[800],
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              if (widget.flight.flightNumber !=
                                                  null)
                                                Text(
                                                  widget.flight.flightNumber!,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.grey[500],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getAvailabilityColor().withAlpha(
                                        25,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.airline_seat_recline_normal,
                                          size: 12,
                                          color: _getAvailabilityColor(),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          availabilityText,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: _getAvailabilityColor(),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  flightDate,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: widget.isSelected
                                ? [
                                    Colors.green.withAlpha(7),
                                    Colors.green.withAlpha(20),
                                  ]
                                : [
                                    Colors.grey.withAlpha(5),
                                    Colors.grey.withAlpha(12),
                                  ],
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Desde',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        'COP',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        total,
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.grey[900],
                                          letterSpacing: -1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getPriceCategoryColor().withAlpha(
                                        25,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      priceCategory,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: _getPriceCategoryColor(),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (widget.showSelectButton) ...[
                              const SizedBox(width: 20),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                child: ElevatedButton.icon(
                                  onPressed: widget.isSelected
                                      ? null
                                      : widget.onTap,
                                  icon: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: Icon(
                                      widget.isSelected
                                          ? Icons.check_circle
                                          : Icons.add_circle_outline,
                                      size: 18,
                                      key: ValueKey(widget.isSelected),
                                    ),
                                  ),
                                  label: Text(
                                    widget.isSelected
                                        ? 'Seleccionado'
                                        : 'Seleccionar',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: widget.isSelected
                                        ? Colors.green
                                        : primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    elevation: widget.isSelected ? 0 : 4,
                                    shadowColor: primaryColor.withAlpha(75),
                                  ),
                                ),
                              ),
                            ] else ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: primaryColor.withAlpha(25),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: primaryColor,
                                  size: 16,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getAvailabilityColor() {
    if (availabilityColor == 'green') return Colors.green;
    if (availabilityColor == 'orange') return Colors.orange;
    return Colors.red;
  }

  Color _getPriceCategoryColor() {
    switch (priceCategory) {
      case 'Económico':
        return Colors.blue;
      case 'Medio':
        return Colors.orange;
      case 'Premium':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }
}
