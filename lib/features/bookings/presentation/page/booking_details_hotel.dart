import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/appbar.dart';

class BookingDetailsHotel extends StatelessWidget {
  const BookingDetailsHotel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(title: 'Detalles de la reserva'),
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        decoration: AppConstantsColors.radialBackground,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFFF6F3F3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                border: Border(bottom: BorderSide(width: 1)),
              ),
              width: double.infinity,
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo-app-black.webp',
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                      ),

                      SizedBox(height: 5),

                      Text(
                        "NEXTRIP",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Hotel Dann Carlton",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFFF6F3F3),
                border: Border(bottom: BorderSide(width: 1)),
              ),
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFEFECEC)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Estado:",
                          style: TextStyle(
                            color: Color(0xFF8F8F8F),
                            fontSize: 12,
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 7,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xFFFF0000).withValues(alpha: 0.2),
                          ),
                          child: Text(
                            "Cancelado",
                            style: TextStyle(
                              color: Color(0xFFFF0000),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFEFECEC)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Dirección:",
                          style: TextStyle(
                            color: Color(0xFF8F8F8F),
                            fontSize: 12,
                          ),
                        ),

                        Text(
                          "Calle 98 No. 52B-10",
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Fecha:",
                        style: TextStyle(
                          color: Color(0xFF8F8F8F),
                          fontSize: 12,
                        ),
                      ),

                      Text(
                        "10 Nov. 2025 - 16 Nov. 2025",
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFFF6F3F3),
                border: Border(bottom: BorderSide(width: 1)),
              ),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Nombre:",
                    style: TextStyle(color: Color(0xFF8F8F8F), fontSize: 12),
                  ),

                  Text(
                    "Juan Pérez",
                    style: TextStyle(color: Color(0xFF000000), fontSize: 15),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFFF6F3F3),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total:",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Text(
                    "\$4,710,000 COP",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
