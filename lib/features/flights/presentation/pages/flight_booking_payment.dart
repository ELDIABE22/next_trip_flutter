import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/utils/helpers.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/features/bookings/data/controllers/flight_booking_controller.dart';
import 'package:next_trip/features/flights/data/models/flight_model.dart';
import 'package:next_trip/features/flights/data/models/passenger_model.dart';
import 'package:next_trip/features/flights/data/models/seat_model.dart';
import 'package:next_trip/features/flights/presentation/pages/payment_success_screen.dart';

class FlightBookingPayment extends StatefulWidget {
  final int passengerCount;
  final Flight flight;
  final String seatNumber;
  final List<Passenger> passengers;
  final List<Seat> selectedSeats;
  final List<String> seatNumbers;
  final bool isRoundTrip;
  final Flight? outboundFlight;
  final Flight? returnFlight;
  final List<Seat>? outboundSeats;
  final List<Seat>? returnSeats;

  const FlightBookingPayment({
    super.key,
    required this.passengerCount,
    required this.flight,
    required this.seatNumber,
    required this.passengers,
    required this.selectedSeats,
    required this.seatNumbers,
    this.isRoundTrip = false,
    this.outboundFlight,
    this.returnFlight,
    this.outboundSeats,
    this.returnSeats,
  });

  @override
  State<FlightBookingPayment> createState() => _FlightBookingPaymentState();
}

class _FlightBookingPaymentState extends State<FlightBookingPayment> {
  final FlightBookingController _bookingController = FlightBookingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardholderController = TextEditingController();
  bool _isLoading = false;
  bool _showCardForm = false;

  String calculateTotalPrice() {
    if (widget.isRoundTrip &&
        widget.outboundFlight != null &&
        widget.returnFlight != null) {
      final outboundTotal =
          widget.outboundFlight!.totalPriceCop *
          (widget.outboundSeats?.length ?? 1);
      final returnTotal =
          widget.returnFlight!.totalPriceCop *
          (widget.returnSeats?.length ?? 1);
      final total = outboundTotal + returnTotal;

      final formatter = NumberFormat("#,###", "es_CO");
      return formatter.format(total);
    } else {
      final total = widget.flight.totalPriceCop * widget.passengerCount;
      final formatter = NumberFormat("#,###", "es_CO");
      return formatter.format(total);
    }
  }

  double getTotalPriceValue() {
    if (widget.isRoundTrip &&
        widget.outboundFlight != null &&
        widget.returnFlight != null) {
      final outboundTotal =
          widget.outboundFlight!.totalPriceCop *
          (widget.outboundSeats?.length ?? 1);
      final returnTotal =
          widget.returnFlight!.totalPriceCop *
          (widget.returnSeats?.length ?? 1);
      return (outboundTotal + returnTotal).toDouble();
    } else {
      return (widget.flight.totalPriceCop * widget.passengerCount).toDouble();
    }
  }

  Future<void> _handlePayment() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (widget.isRoundTrip) {
        if (widget.outboundFlight != null && widget.returnFlight != null) {
          await _bookingController.createRoundTripBooking(
            userId: FirebaseAuth.instance.currentUser!.uid,
            outboundFlight: widget.outboundFlight!,
            returnFlight: widget.returnFlight!,
            passengers: widget.passengers,
            outboundSeats: widget.outboundSeats ?? [],
            returnSeats: widget.returnSeats ?? [],
            totalPrice: getTotalPriceValue(),
          );
        }
      } else {
        await _bookingController.createBooking(
          userId: FirebaseAuth.instance.currentUser!.uid,
          flight: widget.flight,
          passengers: widget.passengers,
          selectedSeats: widget.selectedSeats,
          totalPrice: getTotalPriceValue().toInt(),
        );
      }

      if (mounted) {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessScreen(
              flight: widget.flight,
              passengerCount: widget.passengerCount,
              totalPrice: getTotalPriceValue().toInt(),
              isRoundTrip: widget.isRoundTrip,
              returnFlight: widget.returnFlight,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al procesar el pago: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  PassengerType _parsePassengerType(String type) {
    switch (type) {
      case "Niño":
        return PassengerType.child;
      case "Bebé":
        return PassengerType.infant;
      default:
        return PassengerType.adult;
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardholderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: widget.isRoundTrip
            ? "Confirmar y pagar (Ida y Vuelta)"
            : "Confirmar y pagar",
      ),
      body: Container(
        width: double.infinity,
        decoration: AppConstantsColors.radialBackground,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildSummaryCard(),

                      const SizedBox(height: 20),

                      if (widget.isRoundTrip) ...[
                        _buildFlightDetailsCard(
                          widget.outboundFlight!,
                          "Vuelo de Ida",
                          Icons.flight_takeoff,
                        ),
                        const SizedBox(height: 16),
                        _buildFlightDetailsCard(
                          widget.returnFlight!,
                          "Vuelo de Regreso",
                          Icons.flight_land,
                        ),
                        const SizedBox(height: 20),
                      ] else ...[
                        _buildFlightDetailsCard(
                          widget.flight,
                          "Detalles del Vuelo",
                          Icons.flight,
                        ),
                        const SizedBox(height: 20),
                      ],

                      // _buildPaymentMethodCard(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),

            // Botón de pagar
            _buildPayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF858585))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isRoundTrip
                          ? "RESERVA IDA Y VUELTA"
                          : "RESERVA DE VUELO",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${widget.passengerCount} ${widget.passengerCount == 1 ? 'Pasajero' : 'Pasajeros'}",
                      style: const TextStyle(
                        color: Color(0xFF8F8F8F),
                        fontSize: 12,
                      ),
                    ),
                    ...['Adulto', 'Niño', 'Bebé'].map((type) {
                      final count = widget.passengers
                          .where((p) => p.type == _parsePassengerType(type))
                          .length;
                      if (count == 0) return const SizedBox.shrink();
                      return Text(
                        "$count ${type == 'Adulto'
                            ? 'Adulto(s)'
                            : type == 'Niño'
                            ? 'Niño(s)'
                            : 'Bebé(s)'}",
                        style: const TextStyle(
                          color: Color(0xFF8F8F8F),
                          fontSize: 11,
                        ),
                      );
                    }),
                  ],
                ),
                Text(
                  '\$${calculateTotalPrice()} COP',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // Información de asientos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Asientos:",
                style: TextStyle(color: Color(0xFF8F8F8F), fontSize: 12),
              ),
              Expanded(
                child: Text(
                  widget.seatNumbers.join(', '),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlightDetailsCard(Flight flight, String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            flight.routeTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                formatDateWithWeekday(
                  flight.departureDateTime.toIso8601String(),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                "${formatTime(flight.departureDateTime.toIso8601String())} → ${formatTime(flight.arrivalDateTime.toIso8601String())}",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const Spacer(),
              if (flight.flightNumber != null)
                Text(
                  flight.flightNumber!,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildPaymentMethodCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF000000),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _showCardForm = !_showCardForm;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.credit_card, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Agregar tarjeta',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Débito con CVV, crédito Visa o Mastercard',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Checkbox(
                    value: _showCardForm,
                    onChanged: (value) {
                      setState(() {
                        _showCardForm = value ?? false;
                      });
                    },
                    activeColor: const Color(0xFF4CAF50),
                  ),
                ],
              ),
            ),
          ),

          if (_showCardForm)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[700]!, width: 1),
                ),
              ),
              child: Column(
                children: [
                  _buildCardField(
                    controller: _cardNumberController,
                    hintText: '0000 0000 0000 0000',
                    icon: Icons.credit_card,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCardField(
                          controller: _expiryController,
                          hintText: 'MM/YY',
                          icon: Icons.calendar_today,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCardField(
                          controller: _cvvController,
                          hintText: 'CVV',
                          icon: Icons.lock,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildCardField(
                    controller: _cardholderController,
                    hintText: 'Nombre del titular',
                    icon: Icons.person,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCardField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Color(0xFFEFECEC), fontSize: 16),
              keyboardType: hintText == 'CVV' || hintText.contains('0000')
                  ? TextInputType.number
                  : TextInputType.text,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(icon, color: Colors.grey[500], size: 20),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handlePayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: _isLoading
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('Procesando pago...'),
                    ],
                  )
                : Text(
                    'Pagar \$${calculateTotalPrice()} COP',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
