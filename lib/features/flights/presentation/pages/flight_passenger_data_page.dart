import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/features/auth/domain/entities/user.dart' as app_user;
import 'package:next_trip/features/flights/domain/entities/flight.dart';
import 'package:next_trip/features/flights/domain/entities/passenger.dart';
import 'package:next_trip/features/flights/infrastructure/models/passenger_model.dart';
import 'package:next_trip/features/flights/infrastructure/models/seat_model.dart';
import 'package:next_trip/features/flights/presentation/pages/flight_booking_payment.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightPassengerDataPage/collapsible_passenger_box.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightPassengerDataPage/confirm_passenger_data_button.dart';

class FlightPassengerDataPage extends StatefulWidget {
  final int seatCount;
  final Flight flight;
  final List<SeatModel> selectedSeats;
  final String seatNumber;
  final bool isRoundTrip;
  final Flight? outboundFlight;
  final Flight? returnFlight;
  final List<SeatModel>? outboundSeats;
  final List<SeatModel>? returnSeats;

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
  final List<String> passengers = [];
  final List<PassengerModel> passengersData = [];
  bool _isLoadingUserData = false;
  bool _hasUsedAutoFill = false;
  int _rebuildKey = 0;

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
    final passenger = PassengerModel(
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

  Future<app_user.User?> _getUserData() async {
    try {
      final currentUser = auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) return null;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!doc.exists) return null;

      final data = doc.data()!;

      DateTime birthDate = DateTime.now();
      if (data['birthDate'] != null) {
        if (data['birthDate'] is Timestamp) {
          birthDate = (data['birthDate'] as Timestamp).toDate();
        } else if (data['birthDate'] is String) {
          try {
            final parts = (data['birthDate'] as String).split('/');
            if (parts.length == 3) {
              birthDate = DateTime(
                int.parse(parts[2]),
                int.parse(parts[1]),
                int.parse(parts[0]),
              );
            } else {
              birthDate = DateTime.parse(data['birthDate'] as String);
            }
          } catch (e) {
            debugPrint('Error parseando birthDate: $e');
            birthDate = DateTime.now();
          }
        }
      }

      DateTime createdAt = DateTime.now();
      if (data['createdAt'] != null) {
        if (data['createdAt'] is Timestamp) {
          createdAt = (data['createdAt'] as Timestamp).toDate();
        } else if (data['createdAt'] is String) {
          try {
            createdAt = DateTime.parse(data['createdAt'] as String);
          } catch (e) {
            debugPrint('Error parseando createdAt: $e');
            createdAt = DateTime.now();
          }
        }
      }

      return app_user.User(
        id: currentUser.uid,
        fullName: data['fullName'] ?? '',
        email: data['email'] ?? currentUser.email ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
        cc: data['cc'] ?? '',
        gender: data['gender'] ?? '',
        birthDate: birthDate,
        createdAt: createdAt,
      );
    } catch (e) {
      debugPrint('Error al obtener datos del usuario: $e');
      return null;
    }
  }

  Future<void> _autoFillUserData() async {
    if (_hasUsedAutoFill) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ya has usado tus datos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoadingUserData = true;
    });

    try {
      final user = await _getUserData();

      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudieron cargar tus datos'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      setState(() {
        if (passengers.isEmpty) {
          passengers.add("Adulto");
        }

        _hasUsedAutoFill = true;

        final userData = {
          'fullName': user.fullName,
          'cc': user.cc,
          'gender': user.gender,
          'email': user.email,
          'phone': user.phoneNumber,
          'birthDate': DateFormat('dd/MM/yyyy').format(user.birthDate),
        };

        setState(() {
          if (passengers.isEmpty) {
            passengers.add("Adulto");
          }

          _updatePassenger(0, userData, PassengerType.adult);

          _hasUsedAutoFill = true;

          _rebuildKey++;
        });
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Datos cargados correctamente'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar datos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingUserData = false;
        });
      }
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
                      if (widget.isRoundTrip) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.withAlpha(25),
                                Colors.green.withAlpha(25),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blue.withAlpha(75),
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
                                    'Ida: ${widget.outboundFlight?.originCity ?? widget.flight.originCity} → ${widget.outboundFlight?.destinationCity ?? widget.flight.destinationCity}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              if (widget.returnFlight != null)
                                Row(
                                  children: [
                                    const Icon(Icons.flight_land, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Regreso: ${widget.returnFlight!.originCity} → ${widget.returnFlight!.destinationCity}',
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

                      for (var i = 0; i < passengers.length; i++)
                        CollapsiblePassengerBox(
                          key: ValueKey(
                            'passenger_${i}_$_rebuildKey',
                          ), // MODIFICADO
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
                          initialData: i < passengersData.length
                              ? {
                                  'fullName': passengersData[i].fullName,
                                  'cc': passengersData[i].cc,
                                  'gender': passengersData[i].gender,
                                  'email': passengersData[i].email,
                                  'phone': passengersData[i].phone,
                                  'birthDate': DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(passengersData[i].birthDate),
                                }
                              : null,
                        ),

                      const Spacer(),

                      if (!_hasUsedAutoFill &&
                          // ignore: prefer_is_empty
                          (passengers.isEmpty || passengers.length >= 1))
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ElevatedButton.icon(
                            onPressed: _isLoadingUserData
                                ? null
                                : _autoFillUserData,
                            icon: _isLoadingUserData
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.person_add, size: 20),
                            label: Text(
                              _isLoadingUserData
                                  ? 'Cargando...'
                                  : 'Usar mis datos',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

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
