import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/features/cars/presentation/widgets/carDetailsPage/car_attribute_card.dart';
import 'package:next_trip/core/widgets/bottom_reserve_panel.dart';

class CarDetailsPage extends StatelessWidget {
  const CarDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: AppConstantsColors.radialBackground,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 350,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      child: Image.asset(
                        'assets/images/carro.webp',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Details
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hyundai Tucson",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5),

                                Text(
                                  "SUV compacto o similar",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "\$2,252,176",
                              style: TextStyle(
                                fontSize: 26,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        // Tags
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CarAttributeCard(
                              icon: Icons.person,
                              value: "4",
                              label: "4 Pasaj.",
                            ),
                            SizedBox(width: 5),

                            CarAttributeCard(
                              icon: Icons.work,
                              value: "3",
                              label: "3 Cap. Equ.",
                            ),
                            SizedBox(width: 5),

                            CarAttributeCard(
                              icon: Icons.meeting_room,
                              value: "2",
                              label: "2 Puertas",
                            ),
                            SizedBox(width: 5),

                            CarAttributeCard(
                              icon: Icons.settings_input_component,
                              value: "A",
                              label: "Transmisión",
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Description
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Descripción",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Es un SUV compacto que combina diseño sofisticado, tecnología avanzada y confort en un paquete versátil. Destaca por su estética futurista con luces paramétricas integradas en la parrilla y un interior espacioso con materiales de calidad.",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: const Color(0xFF686868),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const BottomReservePanel(
            totalPrice: '\$22,521,760 COP',
            dateRange: 'por 10 días 1 - 10 de oct',
            buttonText: 'Reservar',
          ),
        ],
      ),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(child: Appbar(isTransparent: true)),
      ),
    );
  }
}
