import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/appbar.dart';

class BookingDetailsCar extends StatelessWidget {
  const BookingDetailsCar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(title: 'Detalles de la reserva'),
      body: Container(
        width: double.infinity,
        decoration: AppConstantsColors.radialBackground,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
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
                      "Hyundai Tucson",
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
                              color: Color(0xFFFF9800).withValues(alpha: 0.2),
                            ),
                            child: Text(
                              "En curso",
                              style: TextStyle(
                                color: Color(0xFFFF9800),
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
                            "Modelo:",
                            style: TextStyle(
                              color: Color(0xFF8F8F8F),
                              fontSize: 12,
                            ),
                          ),

                          Text(
                            "SUV compacto o similar",
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
                          "01 Oct. 2025 - 10 Oct. 2025",
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
                            "Nombre:",
                            style: TextStyle(
                              color: Color(0xFF8F8F8F),
                              fontSize: 12,
                            ),
                          ),

                          Text(
                            "Juan Pérez",
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 15,
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
                            "Recogida:",
                            style: TextStyle(
                              color: Color(0xFF8F8F8F),
                              fontSize: 12,
                            ),
                          ),

                          Expanded(
                            child: Text(
                              "Aeropuerto Internacional Ernesto Cortissoz",
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.end,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
                            "Hora:",
                            style: TextStyle(
                              color: Color(0xFF8F8F8F),
                              fontSize: 12,
                            ),
                          ),

                          Text(
                            "10:00 AM",
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 15,
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
                            "Vuelta:",
                            style: TextStyle(
                              color: Color(0xFF8F8F8F),
                              fontSize: 12,
                            ),
                          ),

                          Expanded(
                            child: Text(
                              "Aeropuerto Internacional Ernesto Cortissoz",
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.end,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
                          "Hora:",
                          style: TextStyle(
                            color: Color(0xFF8F8F8F),
                            fontSize: 12,
                          ),
                        ),

                        Text(
                          "01:30 PM",
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
      ),
    );
  }
}
