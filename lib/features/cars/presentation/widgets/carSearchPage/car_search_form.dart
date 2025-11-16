import 'package:flutter/material.dart';
import 'package:next_trip/features/cars/domain/entities/car.dart';

class CarSearchForm extends StatefulWidget {
  final Function(Map<String, dynamic>)? onSearch;
  final Function()? onClearFilters;

  const CarSearchForm({super.key, this.onSearch, this.onClearFilters});

  @override
  State<CarSearchForm> createState() => _CarSearchFormState();
}

class _CarSearchFormState extends State<CarSearchForm>
    with TickerProviderStateMixin {
  CarCategory? _selectedCategory;
  TransmissionType? _selectedTransmission;
  FuelType? _selectedFuelType;
  int? _minPassengers;
  String? _priceRange;

  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  final List<Map<String, dynamic>> _priceRanges = [
    {'label': 'Hasta \$150k', 'value': '150000', 'max': 150000.0},
    {'label': 'Hasta \$250k', 'value': '250000', 'max': 250000.0},
    {'label': 'Hasta \$350k', 'value': '350000', 'max': 350000.0},
    {'label': 'Hasta \$500k', 'value': '500000', 'max': 500000.0},
  ];

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFECEC),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildFilterHeader(),

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
            child: _buildCollapsibleFilters(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterHeader() {
    return GestureDetector(
      onTap: _toggleExpansion,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color(0xFFEFECEC),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  turns: _isExpanded ? 0.5 : 0,
                  child: const Icon(
                    Icons.expand_more,
                    size: 20,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Filtros',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (_hasActiveFilters()) ...[
                  const SizedBox(width: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_getActiveFiltersCount()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            Row(
              children: [
                if (_hasActiveFilters() && _isExpanded)
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isExpanded ? 1.0 : 0.0,
                    child: TextButton.icon(
                      onPressed: _clearAllFilters,
                      icon: const Icon(Icons.clear_all, size: 14),
                      label: const Text('Limpiar'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red[600],
                        minimumSize: const Size(0, 28),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Text(
                  _isExpanded ? 'Ocultar' : 'Mostrar',
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
    );
  }

  Widget _buildCollapsibleFilters() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.black12, thickness: 1, height: 1),
          const SizedBox(height: 15),

          AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            opacity: _isExpanded ? 1.0 : 0.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryFilters(),
                const SizedBox(height: 12),

                _buildTransmissionFilters(),
                const SizedBox(height: 12),

                _buildFuelTypeFilters(),
                const SizedBox(height: 12),

                _buildPassengerFilters(),
                const SizedBox(height: 12),

                _buildPriceFilters(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return _buildFilterSection(
      'Categoría',
      CarCategory.values,
      _selectedCategory,
      (category) => setState(() {
        _selectedCategory = category == _selectedCategory ? null : category;
        _performSearch();
      }),
      (category) => _getCategoryDisplayName(category),
      Colors.blue,
    );
  }

  Widget _buildTransmissionFilters() {
    return _buildFilterSection(
      'Transmisión',
      TransmissionType.values,
      _selectedTransmission,
      (transmission) => setState(() {
        _selectedTransmission = transmission == _selectedTransmission
            ? null
            : transmission;
        _performSearch();
      }),
      (transmission) => _getTransmissionDisplayName(transmission),
      Colors.green,
    );
  }

  Widget _buildFuelTypeFilters() {
    return _buildFilterSection(
      'Combustible',
      FuelType.values,
      _selectedFuelType,
      (fuelType) => setState(() {
        _selectedFuelType = fuelType == _selectedFuelType ? null : fuelType;
        _performSearch();
      }),
      (fuelType) => _getFuelTypeDisplayName(fuelType),
      Colors.orange,
    );
  }

  Widget _buildPassengerFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mín. Pasajeros',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [2, 4, 5, 7, 8].map((passengers) {
              final isSelected = _minPassengers == passengers;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: FilterChip(
                    label: Text('$passengers+'),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _minPassengers = selected ? passengers : null;
                      });
                      _performSearch();
                    },
                    selectedColor: Colors.purple.withValues(alpha: 0.2),
                    checkmarkColor: Colors.purple,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.purple
                            : Colors.grey.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.purple : Colors.black87,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Precio por día',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _priceRanges.map((priceRange) {
              final isSelected = _priceRange == priceRange['value'];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: FilterChip(
                    label: Text(priceRange['label']),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _priceRange = selected ? priceRange['value'] : null;
                      });
                      _performSearch();
                    },
                    selectedColor: Colors.teal.withValues(alpha: 0.2),
                    checkmarkColor: Colors.teal,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.teal
                            : Colors.grey.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.teal : Colors.black87,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection<T>(
    String title,
    List<T> items,
    T? selectedItem,
    Function(T) onSelected,
    String Function(T) getDisplayName,
    Color accentColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: items.map((item) {
              final isSelected = selectedItem == item;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: FilterChip(
                    label: Text(getDisplayName(item)),
                    selected: isSelected,
                    onSelected: (_) => onSelected(item),
                    selectedColor: accentColor.withValues(alpha: 0.2),
                    checkmarkColor: accentColor,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? accentColor
                            : Colors.grey.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? accentColor : Colors.black87,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
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

  void _performSearch() {
    final Map<String, dynamic> searchFilters = {};

    if (_selectedCategory != null) {
      searchFilters['category'] = _selectedCategory;
    }
    if (_selectedTransmission != null) {
      searchFilters['transmission'] = _selectedTransmission;
    }
    if (_selectedFuelType != null) {
      searchFilters['fuelType'] = _selectedFuelType;
    }
    if (_minPassengers != null) {
      searchFilters['minPassengers'] = _minPassengers;
    }

    if (_priceRange != null) {
      final selectedRange = _priceRanges.firstWhere(
        (range) => range['value'] == _priceRange,
        orElse: () => {},
      );
      if (selectedRange.isNotEmpty) {
        searchFilters['maxPrice'] = selectedRange['max'];
      }
    }

    if (searchFilters.isNotEmpty) {
      widget.onSearch?.call(searchFilters);
    } else {
      widget.onClearFilters?.call();
    }
  }

  void _clearAllFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedTransmission = null;
      _selectedFuelType = null;
      _minPassengers = null;
      _priceRange = null;
    });
    widget.onClearFilters?.call();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filtros limpiados'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.grey,
      ),
    );
  }

  bool _hasActiveFilters() {
    return _selectedCategory != null ||
        _selectedTransmission != null ||
        _selectedFuelType != null ||
        _minPassengers != null ||
        _priceRange != null;
  }

  int _getActiveFiltersCount() {
    int count = 0;
    if (_selectedCategory != null) count++;
    if (_selectedTransmission != null) count++;
    if (_selectedFuelType != null) count++;
    if (_minPassengers != null) count++;
    if (_priceRange != null) count++;
    return count;
  }

  String _getCategoryDisplayName(CarCategory category) {
    switch (category) {
      case CarCategory.compact:
        return 'Compacto';
      case CarCategory.economy:
        return 'Económico';
      case CarCategory.suv:
        return 'SUV';
      case CarCategory.luxury:
        return 'Lujo';
      case CarCategory.pickup:
        return 'Pickup';
      case CarCategory.van:
        return 'Van';
      case CarCategory.convertible:
        return 'Convertible';
    }
  }

  String _getTransmissionDisplayName(TransmissionType transmission) {
    switch (transmission) {
      case TransmissionType.automatic:
        return 'Automática';
      case TransmissionType.manual:
        return 'Manual';
      case TransmissionType.hybrid:
        return 'Híbrida';
    }
  }

  String _getFuelTypeDisplayName(FuelType fuelType) {
    switch (fuelType) {
      case FuelType.gasoline:
        return 'Gasolina';
      case FuelType.diesel:
        return 'Diesel';
      case FuelType.electric:
        return 'Eléctrico';
      case FuelType.hybrid:
        return 'Híbrido';
    }
  }
}
