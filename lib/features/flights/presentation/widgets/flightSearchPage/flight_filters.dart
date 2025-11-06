import 'package:flutter/material.dart';

enum SortOption { priceAsc, durationAsc, departureAsc }

class FlightFilters extends StatefulWidget {
  final bool isReturnFlight;
  final VoidCallback onFiltersChanged;
  final String? title;
  final Map<String, double> Function()? getPriceRange;
  final Map<String, double> Function()? getDurationRange;
  final List<String> Function()? getAvailableAirlines;
  final Function({
    double? minPrice,
    double? maxPrice,
    double? minDuration,
    double? maxDuration,
    bool? directFlightsOnly,
    Set<String>? airlines,
    SortOption? sortOption,
  })?
  applyFilters;
  final VoidCallback? clearFilters;

  const FlightFilters({
    super.key,
    this.isReturnFlight = false,
    required this.onFiltersChanged,
    this.title,
    this.getPriceRange,
    this.getDurationRange,
    this.getAvailableAirlines,
    this.applyFilters,
    this.clearFilters,
  });

  @override
  State<FlightFilters> createState() => _FlightFiltersState();
}

class _FlightFiltersState extends State<FlightFilters>
    with TickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  RangeValues? _priceRange;
  RangeValues? _durationRange;
  bool _directFlightsOnly = false;
  SortOption _selectedSort = SortOption.priceAsc;
  final Set<String> _selectedAirlines = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _initializeFilters();
  }

  void _initializeFilters() {
    final priceRange = widget.getPriceRange?.call();
    final durationRange = widget.getDurationRange?.call();

    setState(() {
      _priceRange = priceRange != null
          ? RangeValues(priceRange['min']!, priceRange['max']!)
          : null;
      _durationRange = durationRange != null
          ? RangeValues(durationRange['min']!, durationRange['max']!)
          : null;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _applyFilters() {
    widget.applyFilters?.call(
      minPrice: _priceRange?.start,
      maxPrice: _priceRange?.end,
      minDuration: _durationRange?.start,
      maxDuration: _durationRange?.end,
      directFlightsOnly: _directFlightsOnly,
      airlines: _selectedAirlines,
      sortOption: _selectedSort,
    );
    widget.onFiltersChanged();
  }

  void _clearFilters() {
    setState(() {
      _directFlightsOnly = false;
      _selectedSort = SortOption.priceAsc;
      _selectedAirlines.clear();
    });
    widget.clearFilters?.call();
    widget.onFiltersChanged();
  }

  @override
  Widget build(BuildContext context) {
    if (_priceRange == null || _durationRange == null) {
      return const SizedBox.shrink();
    }

    final hasActiveFilters = _directFlightsOnly || _selectedAirlines.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _toggleExpansion,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.tune,
                    color: widget.isReturnFlight ? Colors.orange : Colors.blue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.title ??
                        (widget.isReturnFlight
                            ? 'Filtros vuelos de regreso'
                            : 'Filtros y ordenamiento'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (hasActiveFilters) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: widget.isReturnFlight
                            ? Colors.orange
                            : Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Activos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    turns: _isExpanded ? 0.5 : 0,
                    child: const Icon(Icons.expand_more),
                  ),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _expandAnimation.value,
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuickSortButtons(),
                  const SizedBox(height: 20),
                  _buildPriceRangeSection(),
                  const SizedBox(height: 20),
                  _buildDurationRangeSection(),
                  const SizedBox(height: 20),
                  _buildAdditionalFilters(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _clearFilters,
                          child: const Text('Limpiar'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _applyFilters,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.isReturnFlight
                                ? Colors.orange
                                : Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Aplicar filtros'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSortButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ordenar por',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildSortChip('Menor precio', SortOption.priceAsc),
            _buildSortChip('Más rápido', SortOption.durationAsc),
            _buildSortChip('Más temprano', SortOption.departureAsc),
          ],
        ),
      ],
    );
  }

  Widget _buildSortChip(String label, SortOption option) {
    final isSelected = _selectedSort == option;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedSort = option;
        });
      },
      selectedColor: (widget.isReturnFlight ? Colors.orange : Colors.blue)
          .withAlpha(50),
      checkmarkColor: widget.isReturnFlight ? Colors.orange : Colors.blue,
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Precio: \$${_priceRange!.start.toInt()} - \$${_priceRange!.end.toInt()}',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        RangeSlider(
          values: _priceRange!,
          min: _priceRange!.start,
          max: _priceRange!.end,
          divisions: 20,
          activeColor: widget.isReturnFlight ? Colors.orange : Colors.blue,
          onChanged: (RangeValues values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDurationRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duración: ${_durationRange!.start.toStringAsFixed(1)}h - ${_durationRange!.end.toStringAsFixed(1)}h',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        RangeSlider(
          values: _durationRange!,
          min: _durationRange!.start,
          max: _durationRange!.end,
          divisions: 10,
          activeColor: widget.isReturnFlight ? Colors.orange : Colors.blue,
          onChanged: (RangeValues values) {
            setState(() {
              _durationRange = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAdditionalFilters() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Solo vuelos directos',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Switch(
              value: _directFlightsOnly,
              onChanged: (value) {
                setState(() {
                  _directFlightsOnly = value;
                });
              },
              activeThumbColor: widget.isReturnFlight
                  ? Colors.orange
                  : Colors.blue,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildAirlinesSection(),
      ],
    );
  }

  Widget _buildAirlinesSection() {
    final airlines = widget.getAvailableAirlines?.call() ?? [];

    if (airlines.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aerolíneas',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: airlines.map((airline) {
            final isSelected = _selectedAirlines.contains(airline);
            return FilterChip(
              label: Text(airline),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedAirlines.add(airline);
                  } else {
                    _selectedAirlines.remove(airline);
                  }
                });
              },
              selectedColor:
                  (widget.isReturnFlight ? Colors.orange : Colors.blue)
                      .withAlpha(50),
              checkmarkColor: widget.isReturnFlight
                  ? Colors.orange
                  : Colors.blue,
            );
          }).toList(),
        ),
      ],
    );
  }
}
