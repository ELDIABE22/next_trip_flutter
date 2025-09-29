import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:next_trip/core/utils/form_validators.dart';
import 'package:next_trip/features/bookings/data/controllers/car_booking_controller.dart';
import 'package:next_trip/features/cars/data/models/car_model.dart';

enum BookingStepType { dateTime, guestInfo }

class BookingFormStep extends StatefulWidget {
  final CarBookingController controller;
  final Car car;
  final BookingStepType stepType;

  const BookingFormStep({
    super.key,
    required this.controller,
    required this.car,
    required this.stepType,
  });

  @override
  State<BookingFormStep> createState() => _BookingFormStepState();
}

class _BookingFormStepState extends State<BookingFormStep> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _licenseController;
  late TextEditingController _pickupLocationController;
  late TextEditingController _returnLocationController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.controller.guestName);
    _emailController = TextEditingController(
      text: widget.controller.guestEmail,
    );
    _phoneController = TextEditingController(
      text: widget.controller.guestPhone,
    );
    _licenseController = TextEditingController(
      text: widget.controller.guestLicenseNumber,
    );
    _pickupLocationController = TextEditingController(
      text: widget.controller.pickupLocation,
    );
    _returnLocationController = TextEditingController(
      text: widget.controller.returnLocation,
    );

    // Set default pickup location
    if (_pickupLocationController.text.isEmpty) {
      _pickupLocationController.text = 'Aeropuerto';
      widget.controller.setPickupLocation(_pickupLocationController.text);
    }
    if (_returnLocationController.text.isEmpty) {
      _returnLocationController.text = 'Aeropuerto';
      widget.controller.setReturnLocation(_returnLocationController.text);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    _pickupLocationController.dispose();
    _returnLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.stepType) {
      case BookingStepType.dateTime:
        return _buildDateTimeForm();
      case BookingStepType.guestInfo:
        return _buildGuestInfoForm();
    }
  }

  Widget _buildDateTimeForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationFields(),
          const SizedBox(height: 24),
          _buildDateFields(),
          const SizedBox(height: 24),
          _buildTimeFields(),
          if (widget.controller.hasValidDateRange) ...[
            const SizedBox(height: 24),
            _buildPricePreview(),
          ],
        ],
      ),
    );
  }

  Widget _buildGuestInfoForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            controller: _nameController,
            label: 'Nombre completo',
            icon: Icons.person,
            onChanged: (value) => widget.controller.setGuestInfo(name: value),
            validator: FormValidators.validateFullName,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => widget.controller.setGuestInfo(email: value),
            validator: FormValidators.validateEmail,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _phoneController,
            label: 'Teléfono',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            onChanged: (value) => widget.controller.setGuestInfo(phone: value),
            validator: FormValidators.validatePhoneNumber,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _licenseController,
            label: 'Número de licencia de conducir',
            icon: Icons.credit_card,
            onChanged: (value) =>
                widget.controller.setGuestInfo(licenseNumber: value),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Requerido';
              }
              if (!widget.controller.isValidLicenseNumber(value!)) {
                return 'Mínimo 5 caracteres';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ubicaciones',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _pickupLocationController,
          label: 'Lugar de recogida',
          icon: Icons.location_on,
          onChanged: (value) => widget.controller.setPickupLocation(value),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _returnLocationController,
          label: 'Lugar de devolución',
          icon: Icons.location_on_outlined,
          onChanged: (value) => widget.controller.setReturnLocation(value),
        ),
      ],
    );
  }

  Widget _buildDateFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fechas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDateSelector(
                label: 'Fecha de recogida',
                date: widget.controller.selectedPickupDate,
                onTap: () => _selectPickupDate(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateSelector(
                label: 'Fecha de devolución',
                date: widget.controller.selectedReturnDate,
                onTap: () => _selectReturnDate(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Horas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTimeSelector(
                label: 'Hora de recogida',
                time: widget.controller.selectedPickupTime,
                onTap: () => _selectPickupTime(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTimeSelector(
                label: 'Hora de devolución',
                time: widget.controller.selectedReturnTime,
                onTap: () => _selectReturnTime(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPricePreview() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Duración',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                '${widget.controller.numberOfDays} días',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total estimado',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                widget.controller.getFormattedTotalPrice(widget.car),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  date != null
                      ? DateFormat('dd/MM/yyyy').format(date)
                      : 'Seleccionar',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector({
    required String label,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  time != null
                      ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
                      : 'Seleccionar',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectPickupDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          widget.controller.selectedPickupDate ??
          DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      widget.controller.setPickupDate(picked);
    }
  }

  Future<void> _selectReturnDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          widget.controller.selectedReturnDate ??
          DateTime.now().add(const Duration(days: 15)),
      firstDate: widget.controller.selectedPickupDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      widget.controller.setReturnDate(picked);
    }
  }

  Future<void> _selectPickupTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          widget.controller.selectedPickupTime ??
          const TimeOfDay(hour: 10, minute: 0),
    );

    if (picked != null) {
      widget.controller.setPickupTime(picked);
    }
  }

  Future<void> _selectReturnTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          widget.controller.selectedReturnTime ??
          const TimeOfDay(hour: 10, minute: 0),
    );

    if (picked != null) {
      widget.controller.setReturnTime(picked);
    }
  }
}
