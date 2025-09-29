import 'package:flutter/material.dart';
import 'package:next_trip/features/flights/data/models/flight_model.dart';

class FlightCard extends StatefulWidget {
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
  State<FlightCard> createState() => _FlightCardState();
}

class _FlightCardState extends State<FlightCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;
  // ignore: unused_field
  bool _isPressed = false;

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

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.isSelected ? Colors.green : Colors.black;
    final backgroundColor = widget.isSelected
        ? Colors.green.withValues(alpha: 0.05)
        : Colors.white;

    return GestureDetector(
      onTap: widget.navigateToSeatsOnTap ? widget.onTap : null,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
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
                    : Border.all(
                        color: Colors.grey.withValues(alpha: 0.1),
                        width: 1,
                      ),
                boxShadow: [
                  BoxShadow(
                    color: widget.isSelected
                        ? Colors.green.withValues(alpha: 0.25)
                        : Colors.black.withValues(alpha: 0.08),
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
                              Colors.green.withValues(alpha: 0.08),
                              Colors.green.withValues(alpha: 0.02),
                            ]
                          : [Colors.white, Colors.grey.withValues(alpha: 0.02)],
                    ),
                  ),
                  child: Column(
                    children: [
                      // Header moderno con gradiente sutil
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              backgroundColor,
                              backgroundColor.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            // Información principal del vuelo con mejor espaciado
                            Row(
                              children: [
                                // Salida
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.departureTime ?? '—',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey[900],
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.originIata ?? '',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      if (widget.flight != null) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          widget.flight!.originCity,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
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
                                                  primaryColor.withValues(
                                                    alpha: 0.3,
                                                  ),
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
                                                  color: primaryColor
                                                      .withValues(alpha: 0.3),
                                                  blurRadius: 8,
                                                  spreadRadius: 0,
                                                ),
                                              ],
                                            ),
                                            child: Icon(
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
                                                  primaryColor.withValues(
                                                    alpha: 0.3,
                                                  ),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(1),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),

                                      // Badges de información
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
                                              color: (widget.isDirect ?? true)
                                                  ? Colors.green.withValues(
                                                      alpha: 0.1,
                                                    )
                                                  : Colors.orange.withValues(
                                                      alpha: 0.1,
                                                    ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: (widget.isDirect ?? true)
                                                    ? Colors.green.withValues(
                                                        alpha: 0.3,
                                                      )
                                                    : Colors.orange.withValues(
                                                        alpha: 0.3,
                                                      ),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  (widget.isDirect ?? true)
                                                      ? Icons.trending_flat
                                                      : Icons
                                                            .connecting_airports,
                                                  size: 12,
                                                  color:
                                                      (widget.isDirect ?? true)
                                                      ? Colors.green[700]
                                                      : Colors.orange[700],
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  (widget.isDirect ?? true)
                                                      ? 'Directo'
                                                      : 'Escalas',
                                                  style: TextStyle(
                                                    color:
                                                        (widget.isDirect ??
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

                                      // Duración
                                      Text(
                                        widget.durationLabel ?? '',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Llegada
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        widget.arrivalTime ?? '—',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey[900],
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.destinationIata ?? '',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      if (widget.flight != null) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          widget.flight!.destinationCity,
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
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            if (widget.flight != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.withValues(alpha: 0.1),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Aerolínea y vuelo
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.withValues(
                                                alpha: 0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                                  widget.flight!.airline ??
                                                      'Aerolínea',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[800],
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                if (widget
                                                        .flight!
                                                        .flightNumber !=
                                                    null)
                                                  Text(
                                                    widget
                                                        .flight!
                                                        .flightNumber!,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.grey[500],
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Disponibilidad
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getAvailabilityColor()
                                            .withValues(alpha: 0.1),
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
                                            widget.flight!.availabilityText,
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
                            ],

                            // Fecha si está disponible
                            if (widget.flightDate != null) ...[
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
                                    widget.flightDate!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                                    Colors.green.withValues(alpha: 0.03),
                                    Colors.green.withValues(alpha: 0.08),
                                  ]
                                : [
                                    Colors.grey.withValues(alpha: 0.02),
                                    Colors.grey.withValues(alpha: 0.05),
                                  ],
                          ),
                        ),
                        child: Row(
                          children: [
                            // Precio destacado
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
                                        widget.currency ?? 'COP',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.total,
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.grey[900],
                                          letterSpacing: -1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (widget.flight != null) ...[
                                    const SizedBox(height: 2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getPriceCategoryColor()
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        widget.flight!.priceCategory,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: _getPriceCategoryColor(),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
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
                                    shadowColor: primaryColor.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.1),
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
    if (widget.flight?.availabilityColor == 'green') return Colors.green;
    if (widget.flight?.availabilityColor == 'orange') return Colors.red;
    return Colors.red;
  }

  Color _getPriceCategoryColor() {
    switch (widget.flight?.priceCategory) {
      case 'Económico':
        return Colors.blue;
      case 'Medio':
        return Colors.red;
      case 'Premium':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }
}
