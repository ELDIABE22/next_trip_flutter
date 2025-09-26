import 'package:flutter/material.dart';
import 'package:next_trip/core/utils/form_validators.dart';
import 'package:next_trip/core/widgets/input.dart';

class CollapsiblePassengerBox extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onRemove;
  final ValueChanged<Map<String, String>> onChanged;

  const CollapsiblePassengerBox({
    super.key,
    required this.title,
    required this.icon,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  State<CollapsiblePassengerBox> createState() =>
      _CollapsiblePassengerBoxState();
}

class _CollapsiblePassengerBoxState extends State<CollapsiblePassengerBox> {
  bool isExpanded = false;

  final _fullName = TextEditingController();
  final _birthDate = TextEditingController();
  String? _birthDateError;
  final _gender = TextEditingController();
  final _documentNumber = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();

  void _validateBirthDate(String value) {
    if (value.isEmpty) {
      setState(() => _birthDateError = 'Requerido');
      return;
    }

    try {
      final parts = value.trim().split('/');
      if (parts.length != 3) {
        setState(
          () => _birthDateError = 'Formato de fecha inválido (dd/mm/aaaa)',
        );
        return;
      }

      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);

      if (day == null || month == null || year == null) {
        setState(
          () => _birthDateError = 'Formato de fecha inválido (dd/mm/aaaa)',
        );
        return;
      }

      final dt = DateTime(year, month, day);

      if (dt.isAfter(DateTime.now())) {
        setState(() => _birthDateError = 'La fecha no puede ser futura');
        return;
      }

      setState(() => _birthDateError = null);
    } catch (e) {
      setState(
        () => _birthDateError = 'Formato de fecha inválido (dd/mm/aaaa)',
      );
    }
  }

  bool validate() {
    _validateBirthDate(_birthDate.text);
    return _birthDateError == null;
  }

  void _notifyParent() {
    widget.onChanged({
      "fullName": _fullName.text,
      "birthDate": _birthDate.text,
      "gender": _gender.text,
      "cc": _documentNumber.text,
      "email": _email.text,
      "phone": _phone.text,
    });
  }

  @override
  void dispose() {
    _birthDate.dispose();
    _fullName.dispose();
    _gender.dispose();
    _documentNumber.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(widget.icon),
            title: Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  onPressed: () => setState(() => isExpanded = !isExpanded),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
            onTap: () => setState(() => isExpanded = !isExpanded),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Column(
                children: [
                  Input(
                    controller: _documentNumber,
                    labelText: "Número de documento",
                    onChanged: (_) => _notifyParent(),
                    validator: FormValidators.validateCC,
                  ),
                  const SizedBox(height: 15),
                  Input(
                    controller: _fullName,
                    labelText: "Nombre completo",
                    onChanged: (_) => _notifyParent(),
                    validator: FormValidators.validateFullName,
                  ),
                  const SizedBox(height: 15),
                  Input(
                    controller: _email,
                    labelText: "Email",
                    onChanged: (_) => _notifyParent(),
                    validator: FormValidators.validateEmail,
                  ),
                  const SizedBox(height: 15),
                  Input(
                    controller: _phone,
                    labelText: "Número de teléfono",
                    onChanged: (_) => _notifyParent(),
                    validator: FormValidators.validatePhoneNumber,
                  ),
                  const SizedBox(height: 15),
                  Input(
                    controller: _birthDate,
                    labelText: "Fecha de Nacimiento",
                    prefixIcon: Icons.calendar_today,
                    readOnly: true,
                    errorText: _birthDateError,
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _birthDate.text =
                              '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                          _validateBirthDate(_birthDate.text);
                        });
                        _notifyParent();
                      }
                    },
                    onChanged: (value) {
                      _validateBirthDate(value);
                      _notifyParent();
                    },
                  ),
                  const SizedBox(height: 15),
                  Input(
                    controller: _gender,
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
                                  setState(() {
                                    _gender.text = genders[index];
                                  });
                                  _notifyParent();
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                    validator: FormValidators.validateGender,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
