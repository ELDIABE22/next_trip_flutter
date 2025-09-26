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

  const FlightPassengerDataPage({
    super.key,
    required this.seatCount,
    required this.flight,
    required this.selectedSeats,
    required this.seatNumber,
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
      appBar: Appbar(title: "Datos de los pasajeros"),
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
                      for (var i = 0; i < passengers.length; i++)
                        CollapsiblePassengerBox(
                          title: passengers[i],
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
                      if (passengers.length < widget.seatCount)
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () => _addPassenger("Adulto"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Text("Agregar Adulto"),
                            ),
                            ElevatedButton(
                              onPressed: () => _addPassenger("Niño"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Text("Agregar Niño"),
                            ),
                            ElevatedButton(
                              onPressed: () => _addPassenger("Bebé"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Text("Agregar Bebé"),
                            ),
                          ],
                        ),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ),
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
                onPressed: () {
                  if (!_validatePassengers()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Debes completar todos los datos"),
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FlightBookingPayment(
                        passengerCount: widget.seatCount,
                        flight: widget.flight,
                        seatNumber: widget.selectedSeats.isNotEmpty
                            ? widget.selectedSeats.first.id
                            : '',
                        seatNumbers: widget.selectedSeats
                            .map((s) => s.id)
                            .toList(),
                        passengers: passengersData,
                        selectedSeats: widget.selectedSeats,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
