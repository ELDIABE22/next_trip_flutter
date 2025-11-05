import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/input.dart';
import 'package:next_trip/core/utils/form_validators.dart';

class FullNameField extends StatelessWidget {
  final TextEditingController controller;

  const FullNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Input(
      controller: controller,
      labelText: "Nombre completo",
      prefixIcon: Icons.person,
      validator: FormValidators.validateFullName,
    );
  }
}

class CCField extends StatelessWidget {
  final TextEditingController controller;

  const CCField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Input(
      controller: controller,
      labelText: "CC",
      prefixIcon: Icons.credit_card,
      keyboardType: TextInputType.number,
      validator: FormValidators.validateCC,
    );
  }
}

class PhoneField extends StatelessWidget {
  final TextEditingController controller;

  const PhoneField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Input(
      controller: controller,
      labelText: "Teléfono",
      prefixIcon: Icons.phone,
      keyboardType: TextInputType.phone,
      validator: FormValidators.validatePhoneNumber,
    );
  }
}

class BirthDateField extends StatelessWidget {
  final TextEditingController controller;

  const BirthDateField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Input(
      controller: controller,
      labelText: "Fecha de Nacimiento",
      prefixIcon: Icons.calendar_today,
      readOnly: true,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          controller.text =
              '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Requerido';
        }
        try {
          final parts = value.trim().split('/');
          if (parts.length != 3) {
            return 'Formato de fecha inválido (dd/mm/aaaa)';
          }
          final day = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final year = int.tryParse(parts[2]);

          if (day == null || month == null || year == null) {
            return 'Formato de fecha inválido (dd/mm/aaaa)';
          }

          final dt = DateTime(year, month, day);
          return FormValidators.validateBirthDate(dt);
        } catch (e) {
          return 'Formato de fecha inválido (dd/mm/aaaa)';
        }
      },
    );
  }
}

class GenderField extends StatelessWidget {
  final TextEditingController controller;

  const GenderField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Input(
      controller: controller,
      labelText: "Género",
      prefixIcon: Icons.transgender,
      readOnly: true,
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                final genders = ['Masculino', 'Femenino', 'Otro'];
                return ListTile(
                  title: Text(genders[index]),
                  onTap: () {
                    controller.text = genders[index];
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        );
      },
      validator: FormValidators.validateGender,
    );
  }
}

class DateAndGenderRow extends StatelessWidget {
  final TextEditingController birthDateController;
  final TextEditingController genderController;

  const DateAndGenderRow({
    super.key,
    required this.birthDateController,
    required this.genderController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: BirthDateField(controller: birthDateController)),
        const SizedBox(width: 10),
        Expanded(child: GenderField(controller: genderController)),
      ],
    );
  }
}
