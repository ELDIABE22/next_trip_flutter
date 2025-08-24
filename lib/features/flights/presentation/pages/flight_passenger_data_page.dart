import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightPassengerDataPage/collapsible_passenger_box.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightPassengerDataPage/confirm_passenger_data_button.dart';

class FlightPassengerDataPage extends StatelessWidget {
  const FlightPassengerDataPage({super.key});

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
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    CollapsiblePassengerBox(
                      title: "Adulto",
                      icon: Icons.person,
                    ),
                    CollapsiblePassengerBox(title: "Niño", icon: Icons.person),
                    CollapsiblePassengerBox(
                      title: "Bebé",
                      icon: Icons.child_care,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            ConfirmPassengerDataButton(),
          ],
        ),
      ),
    );
  }
}
