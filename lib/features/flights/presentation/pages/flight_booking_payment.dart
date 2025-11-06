import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/utils/helpers.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/features/flights/application/bloc/flight_bloc.dart';
import 'package:next_trip/features/flights/application/bloc/flight_event.dart';
import 'package:next_trip/features/flights/domain/entities/flight.dart';
import 'package:next_trip/features/flights/domain/entities/passenger.dart';
import 'package:next_trip/features/flights/domain/entities/seat.dart';
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
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardholderController = TextEditingController();
  bool _isLoading = false;

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

      if (!mounted) return;

      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

      if (widget.isRoundTrip &&
          widget.outboundFlight != null &&
          widget.returnFlight != null &&
          widget.outboundSeats != null &&
          widget.returnSeats != null) {
        context.read<FlightBloc>().add(
          CreateRoundTripBookingRequested(
            userId: userId,
            outboundFlight: widget.outboundFlight!,
            returnFlight: widget.returnFlight!,
            outboundSeats: widget.outboundSeats!,
            returnSeats: widget.returnSeats!,
            passengers: widget.passengers,
            totalPrice: getTotalPriceValue(),
          ),
        );
      } else {
        context.read<FlightBloc>().add(
          CreateBookingRequested(
            userId: userId,
            flight: widget.flight,
            seats: widget.selectedSeats,
            passengers: widget.passengers,
            totalPrice: getTotalPriceValue().toInt(),
          ),
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
            color: Colors.grey.withAlpha(25),
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
            '${flight.originCity} → ${flight.destinationCity}',
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

  Widget _buildPayButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
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
