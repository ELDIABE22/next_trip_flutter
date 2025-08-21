import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:next_trip/features/destinations/presentation/pages/search_country_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.promptTextTheme()),
      home: SearchCountryPage(),
    );
  }
}
