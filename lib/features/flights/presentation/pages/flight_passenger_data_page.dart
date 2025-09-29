import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/features/flights/data/models/flight_model.dart';
import 'package:next_trip/features/flights/data/models/passenger_model.dart';
import 'package:next_trip/features/flights/data/models/seat_model.dart';
import 'package:next_trip/features/flights/presentation/pages/flight_booking_payment.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightPassengerDataPage/collapsible_passenger_box.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightPassengerDataPage/confirm_passenger_data_button.dart';

class FlightPassengerDataPage extends StatefulWidget {
  final int seatCount;
  final Flight flight;
  final List<Seat> selectedSeats;
  final String seatNumber;
  final bool isRoundTrip;
  final Flight? outboundFlight;
  final Flight? returnFlight;
  final List<Seat>? outboundSeats;
  final List<Seat>? returnSeats;

  const FlightPassengerDataPage({
    super.key,
    required this.seatCount,
    required this.flight,
    required this.selectedSeats,
    required this.seatNumber,
    this.isRoundTrip = false,
    this.outboundFlight,
    this.returnFlight,
    this.outboundSeats,
    this.returnSeats,
  });

  @override
  State<FlightPassengerDataPage> createState() =>
      _FlightPassengerDataPageState();
}

class _FlightPassengerDataPageState extends State<FlightPassengerDataPage> {
  final List<String> passengers =
      []; // lista de tipos: "Adulto", "Niño", "Bebé"
  final List<Passenger> passengersData = [];

  void _addPassenger(String type) {
    if (passengers.length >= widget.seatCount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "No puedes agregar más pasajeros que asientos seleccionados",
          ),
        ),
      );
      return;
    }
    setState(() {
      passengers.add(type);
    });
  }

  void _removePassenger(int index) {
    if (passengers[index] == "Adulto" &&
        passengers.where((p) => p == "Adulto").length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Debe haber al menos un adulto en la reserva"),
        ),
      );
      return;
    }

    setState(() {
      passengers.removeAt(index);
      if (index < passengersData.length) {
        passengersData.removeAt(index);
      }
    });
  }

  bool _validatePassengers() {
    return passengersData.length == widget.seatCount &&
        passengersData.every(
          (p) =>
              p.fullName.isNotEmpty &&
              p.cc.isNotEmpty &&
              p.gender.isNotEmpty &&
              p.email.isNotEmpty &&
              p.phone.isNotEmpty,
        );
  }

  void _updatePassenger(
    int index,
    Map<String, String> data,
    PassengerType type,
  ) {
    final passenger = Passenger(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: data['fullName'] ?? '',
      cc: data['cc'] ?? '',
      gender: data['gender'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      birthDate: DateTime.tryParse(data['birthDate'] ?? '') ?? DateTime(2000),
      type: type,
    );

    if (index < passengersData.length) {
      passengersData[index] = passenger;
    } else {
      passengersData.add(passenger);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: widget.isRoundTrip
            ? "Datos de pasajeros (Ida y Vuelta)"
            : "Datos de los pasajeros",
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: AppConstantsColors.radialBackground,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      kToolbarHeight -
                      MediaQuery.of(context).padding.top -
                      20,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header informativo para ida y vuelta
                      if (widget.isRoundTrip) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.withValues(alpha: 0.1),
                                Colors.green.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blue.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.info_outline, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text(
                                    'Reserva ida y vuelta',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.flight_takeoff, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Ida: ${widget.outboundFlight?.routeTitle ?? widget.flight.routeTitle}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.flight_land, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Regreso: ${widget.returnFlight?.routeTitle ?? 'No especificado'}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.airline_seat_recline_normal,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Total asientos: ${widget.seatCount} (${widget.outboundSeats?.length ?? 0} ida + ${widget.returnSeats?.length ?? 0} regreso)',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Lista de pasajeros
                      for (var i = 0; i < passengers.length; i++)
                        CollapsiblePassengerBox(
                          title: '${passengers[i]} ${i + 1}',
                          icon: passengers[i] == "Bebé"
                              ? Icons.child_care
                              : Icons.person,
                          onRemove: () => _removePassenger(i),
                          onChanged: (data) => _updatePassenger(
                            i,
                            data,
                            _parsePassengerType(passengers[i]),
                          ),
                        ),

                      const Spacer(),

                      // Información de progreso
                      if (passengers.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.green.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                passengers.length == widget.seatCount
                                    ? Icons.check_circle
                                    : Icons.info_outline,
                                color: passengers.length == widget.seatCount
                                    ? Colors.green
                                    : Colors.orange,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  passengers.length == widget.seatCount
                                      ? 'Todos los pasajeros agregados. Completa los datos para continuar.'
                                      : 'Faltan ${widget.seatCount - passengers.length} pasajero(s) por agregar',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: passengers.length == widget.seatCount
                                        ? Colors.green[700]
                                        : Colors.orange[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Botones para agregar pasajeros
                      if (passengers.length < widget.seatCount)
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildAddPassengerButton("Adulto", Icons.person),
                            _buildAddPassengerButton("Niño", Icons.child_care),
                            _buildAddPassengerButton(
                              "Bebé",
                              Icons.baby_changing_station,
                            ),
                          ],
                        ),

                      const SizedBox(height: 200),
                    ],
                  ),
                ),
              ),
            ),

            // Botón de confirmación
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: ConfirmPassengerDataButton(
                seatCount: widget.seatCount,
                addedPassengersCount: passengers.length,
                seatNumber: widget.selectedSeats.isNotEmpty
                    ? widget.selectedSeats.first.id
                    : '',
                passengerTypes: passengers,
                hasAtLeastOneAdult: passengers.contains("Adulto"),
                isRoundTrip: widget.isRoundTrip,
                onPressed: () {
                  if (!_validatePassengers()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Debes completar todos los datos"),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }

                  _navigateToPayment();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPassengerButton(String type, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () => _addPassenger(type),
      icon: Icon(icon, size: 16),
      label: Text("Agregar $type"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  void _navigateToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightBookingPayment(
          passengerCount: widget.seatCount,
          flight: widget.flight,
          seatNumber: widget.selectedSeats.isNotEmpty
              ? widget.selectedSeats.first.id
              : '',
          seatNumbers: widget.selectedSeats.map((s) => s.id).toList(),
          passengers: passengersData,
          selectedSeats: widget.selectedSeats,
          isRoundTrip: widget.isRoundTrip,
          outboundFlight: widget.outboundFlight,
          returnFlight: widget.returnFlight,
          outboundSeats: widget.outboundSeats,
          returnSeats: widget.returnSeats,
        ),
      ),
    );
  }
}
