import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';

class CountryListPage extends StatelessWidget {
  const CountryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Seleccionar país",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: AppConstantsColors.radialBackground,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "¿A qué país te gustaría ir?",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 10),

            TextField(
              // controller: _controller,
              decoration: InputDecoration(
                labelText: "Buscar país",
                labelStyle: TextStyle(
                  color: Color(0xFF9C9C9C),
                ),
                filled: true,
                fillColor: Color(0xFFF4F4F4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
