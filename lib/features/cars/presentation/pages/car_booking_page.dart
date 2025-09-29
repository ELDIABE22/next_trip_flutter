import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/core/widgets/custom_button.dart';
import 'package:next_trip/features/bookings/data/controllers/car_booking_controller.dart';
import 'package:next_trip/features/cars/data/models/car_model.dart';
import 'package:next_trip/features/cars/presentation/widgets/carBookingPage/booking_form_step.dart';
import 'package:next_trip/features/cars/presentation/widgets/carBookingPage/booking_summary_card.dart';
import 'package:next_trip/features/cars/presentation/widgets/carBookingPage/car_info_card.dart';

class CarBookingPage extends StatefulWidget {
  final Car car;
  final String userId;

  const CarBookingPage({super.key, required this.car, required this.userId});

  @override
  State<CarBookingPage> createState() => _CarBookingPageState();
}

class _CarBookingPageState extends State<CarBookingPage> {
  late final CarBookingController _bookingController;
  final PageController _pageController = PageController();

  int _currentStep = 0;
  final int _totalSteps = 3;

  @override
  void initState() {
    super.initState();
    _bookingController = CarBookingController(
      onStateChanged: () {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {});
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _bookingController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: Appbar(title: 'Reservar Carro', isTransparent: false),
        ),
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                _buildDateTimeStep(),
                _buildGuestInfoStep(),
                _buildConfirmationStep(),
              ],
            ),
          ),
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: List.generate(_totalSteps, (index) {
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: isCompleted || isActive
                          ? Colors.green
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (index < _totalSteps - 1) const SizedBox(width: 8),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDateTimeStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecciona fechas y horas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Elige cuándo quieres recoger y devolver tu ${widget.car.name}',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 30),

          CarInfoCard(car: widget.car),
          const SizedBox(height: 20),

          BookingFormStep(
            controller: _bookingController,
            car: widget.car,
            stepType: BookingStepType.dateTime,
          ),
        ],
      ),
    );
  }

  Widget _buildGuestInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información del conductor',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Completa tus datos para la reserva',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 30),

          BookingFormStep(
            controller: _bookingController,
            car: widget.car,
            stepType: BookingStepType.guestInfo,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Confirma tu reserva',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Revisa los detalles antes de confirmar',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 30),

          BookingSummaryCard(controller: _bookingController, car: widget.car),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _goToPreviousStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.grey[400]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text('Anterior'),
                ),
              ),

            if (_currentStep > 0) const SizedBox(width: 16),

            Expanded(
              flex: _currentStep == 0 ? 1 : 2,
              child: CustomButton(
                text: _getNextButtonText(),
                onPressed: _bookingController.isCreatingBooking
                    ? null
                    : _handleNextStep,
                isLoading: _bookingController.isCreatingBooking,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getNextButtonText() {
    switch (_currentStep) {
      case 0:
        return 'Continuar';
      case 1:
        return 'Revisar';
      case 2:
        return 'Confirmar Reserva';
      default:
        return 'Continuar';
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _handleNextStep() async {
    switch (_currentStep) {
      case 0:
        if (_validateDateTimeStep()) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        break;
      case 1:
        if (_validateGuestInfoStep()) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        break;
      case 2:
        await _createBooking();
        break;
    }
  }

  bool _validateDateTimeStep() {
    final errors = _bookingController.validateDates();
    final locationErrors = _bookingController.validateLocations();
    errors.addAll(locationErrors);

    if (errors.isNotEmpty) {
      _showValidationErrors(errors);
      return false;
    }

    return true;
  }

  bool _validateGuestInfoStep() {
    final errors = _bookingController.validateGuestInfo();

    if (errors.isNotEmpty) {
      _showValidationErrors(errors);
      return false;
    }

    return true;
  }

  void _showValidationErrors(Map<String, String> errors) {
    final errorMessages = errors.values.join('\n');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessages),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _createBooking() async {
    final success = await _bookingController.createBooking(
      car: widget.car,
      userId: widget.userId,
    );

    if (success) {
      if (!mounted) return;
      _showSuccessDialog();
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _bookingController.errorMessage ?? 'Error al crear la reserva',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 64),
        title: const Text(
          '¡Reserva Confirmada!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tu reserva para ${widget.car.name} ha sido confirmada exitosamente.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar diálogo
              Navigator.of(context).pop(); // Volver a detalles
              Navigator.of(context).pop(); // Volver a lista
            },
            child: const Text('Ver mis reservas'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar diálogo
              Navigator.of(context).pop(); // Volver a detalles
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }
}
