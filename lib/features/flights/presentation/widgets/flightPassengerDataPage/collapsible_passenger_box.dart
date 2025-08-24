import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/input.dart';

class CollapsiblePassengerBox extends StatefulWidget {
  final String title;
  final IconData icon;

  const CollapsiblePassengerBox({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  State<CollapsiblePassengerBox> createState() =>
      _CollapsiblePassengerBoxState();
}

class _CollapsiblePassengerBoxState extends State<CollapsiblePassengerBox> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
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
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            onTap: () => setState(() => isExpanded = !isExpanded),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Column(
                children: [
                  Input(labelText: "Nombre"),
                  SizedBox(height: 15),
                  Input(labelText: "Apellido"),
                  SizedBox(height: 15),
                  Input(labelText: "Fecha de nacimiento"),
                  SizedBox(height: 15),
                  Input(labelText: "Género"),
                  SizedBox(height: 15),
                  Input(labelText: "Número de documento"),
                  SizedBox(height: 15),
                  Input(labelText: "Email"),
                  SizedBox(height: 15),
                  Input(labelText: "Número de teléfono"),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
