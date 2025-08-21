import 'package:flutter/material.dart';

class CountryPage extends StatelessWidget {
  const CountryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ciudad")),
      body: const Center(
        child: Text(
          "Aquí irán las ciudades disponibles",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
