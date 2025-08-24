import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/custom_button.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/input_field.dart';

class CarSearchForm extends StatefulWidget {
  const CarSearchForm({super.key});

  @override
  State<CarSearchForm> createState() => _CarSearchFormState();
}

class _CarSearchFormState extends State<CarSearchForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFEFECEC),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: InputField(
                  label: 'Lugar de recogida',
                  value: 'Aeropuerto Internacional Ernesto Cortissoz',
                  icon: Icons.location_on,
                  enabled: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          Row(
            children: [
              Expanded(
                child: InputField(
                  label: 'Fecha recogida',
                  value: '01/09/2025',
                  icon: Icons.event,
                  enabled: true,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: InputField(
                  label: 'Hora',
                  value: '10:00',
                  icon: Icons.access_time,
                  enabled: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          Row(
            children: [
              Expanded(
                child: InputField(
                  label: 'Fecha devolución',
                  value: '10/09/2025',
                  icon: Icons.event,
                  enabled: true,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: InputField(
                  label: 'Hora',
                  value: '10:00',
                  icon: Icons.access_time,
                  enabled: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          CustomButton(text: "Buscar", onPressed: () {}),
        ],
      ),
    );
  }
}
