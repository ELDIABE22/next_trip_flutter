import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/utils/helpers.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/core/widgets/bottom_reserve_panel.dart';
import 'package:next_trip/features/bookings/data/controllers/flight_booking_controller.dart'
    show FlightBookingController;
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

  const FlightBookingPayment({
    super.key,
    required this.passengerCount,
    required this.flight,
    required this.seatNumber,
    required this.passengers,
    required this.selectedSeats,
    required this.seatNumbers,
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
    final cleanPrice = widget.flight.totalPriceCop.toString().replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    final totalPrice = int.tryParse(cleanPrice) ?? 0;
    final total = totalPrice * widget.passengerCount;

    final formatter = NumberFormat("#,###", "es_CO");
    return '${formatter.format(total)} COP';
  }

  Future<void> _handlePayment() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));

      await _bookingController.createBooking(
        userId: FirebaseAuth.instance.currentUser!.uid,
        flight: widget.flight,
        passengers: widget.passengers,
        selectedSeats: widget.selectedSeats,
        totalPrice: widget.flight.totalPriceCop * widget.passengerCount,
      );

      if (mounted) {
        // Show success screen
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessScreen(
              flight: widget.flight,
              passengerCount: widget.passengerCount,
              totalPrice: widget.flight.totalPriceCop * widget.passengerCount,
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
      appBar: Appbar(title: "Confirmar y pagar"),
      body: Container(
        width: double.infinity,
        decoration: AppConstantsColors.radialBackground,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Card principal
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            // Info
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color(0xFF858585),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${widget.passengerCount} ${widget.passengerCount == 1 ? 'Pasajero' : 'Pasajeros'}",
                                            style: TextStyle(
                                              color: Color(0xFF8F8F8F),
                                              fontSize: 12,
                                            ),
                                          ),
                                          ...['Adulto', 'Niño', 'Bebé'].map((
                                            type,
                                          ) {
                                            final count = widget.passengers
                                                .where(
                                                  (p) =>
                                                      p.type ==
                                                      _parsePassengerType(type),
                                                )
                                                .length;
                                            if (count == 0) {
                                              return SizedBox.shrink();
                                            }
                                            return Text(
                                              "$count ${type == 'Adulto'
                                                  ? 'Adulto(s)'
                                                  : type == 'Niño'
                                                  ? 'Niño(s)'
                                                  : 'Bebé(s)'}",
                                              style: TextStyle(
                                                color: Color(0xFF8F8F8F),
                                                fontSize: 12,
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                      Text(
                                        '\$${calculateTotalPrice()}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "De ${widget.flight.originCity} a ${widget.flight.destinationCity}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          widget.flight.flightNumber!,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          widget.seatNumbers.join(', '),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                Text(
                                  formatDate(
                                    widget.flight.departureDateTime
                                        .toIso8601String(),
                                  ),
                                  style: TextStyle(
                                    color: Color(0xFF6F6E6E),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                Text(
                                  "${formatTime(widget.flight.departureDateTime.toIso8601String())} ${widget.flight.originCity} -> ${formatTime(widget.flight.arrivalDateTime.toIso8601String())} ${widget.flight.destinationCity}",
                                  style: TextStyle(
                                    color: Color(0xFF6F6E6E),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Método de pago con checkbox
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF000000),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // Header del checkbox
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showCardForm = !_showCardForm;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.credit_card,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 14,
                                            ),
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

                            // Formulario expandible
                            if (_showCardForm)
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.grey[700]!,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    // Campo número de tarjeta
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF1A1A1A),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _cardNumberController,
                                              style: TextStyle(
                                                color: Color(0XffEFECEC),
                                                fontSize: 16,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: '0000 0000 0000 0000',
                                                hintStyle: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 16,
                                                ),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.credit_card,
                                            color: Colors.grey[500],
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 10),

                                    // Campos fecha de vencimiento y CVV
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF1A1A1A),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: TextField(
                                              controller: _expiryController,
                                              style: TextStyle(
                                                color: Color(0XffEFECEC),
                                                fontSize: 16,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: 'MM/YY',
                                                hintStyle: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 16,
                                                ),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF1A1A1A),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: TextField(
                                              controller: _cvvController,
                                              style: TextStyle(
                                                color: Color(0XffEFECEC),
                                                fontSize: 16,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: '000',
                                                hintStyle: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 16,
                                                ),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 10),

                                    // Campo nombre del titular
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF1A1A1A),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: TextField(
                                        controller: _cardholderController,
                                        style: TextStyle(
                                          color: Color(0XffEFECEC),
                                          fontSize: 16,
                                        ),
                                        textCapitalization:
                                            TextCapitalization.words,
                                        decoration: InputDecoration(
                                          hintText: 'Nombre del titular',
                                          hintStyle: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 16,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 5),

            // Botón Fixed
            BottomReservePanel(
              totalPrice: '\$${calculateTotalPrice()}',
              buttonText: _isLoading ? 'Procesando...' : 'Pagar',
              onPressed: _handlePayment,
            ),
          ],
        ),
      ),
    );
  }
}
