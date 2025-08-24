import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/features/hotels/presentation/widgets/hotelSearchPage/bottom_reserve_panel.dart';
import 'package:next_trip/features/hotels/presentation/widgets/hotelSearchPage/hotel_attribute_card.dart';
import 'package:next_trip/features/hotels/presentation/widgets/hotelSearchPage/hotel_calendar.dart';

class HotelDetailsPage extends StatelessWidget {
  const HotelDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(title: "Detalles del hotel"),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              decoration: AppConstantsColors.radialBackground,
              child: Column(
                children: [
                  // Image
                  SizedBox(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      child: Image.asset(
                        'assets/images/hotel.webp',
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Padding(
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
                                  "Hotel Dann Carlton",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                SizedBox(height: 5),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Calle 98 No. 52B-10",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 5),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "+57 605 367 7777",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            Text(
                              "\$785,000",
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
                            HotelAttributeCard(
                              icon: Icons.person,
                              value: "4",
                              label: "4 Huesp.",
                            ),
                            SizedBox(width: 5),

                            HotelAttributeCard(
                              icon: Icons.home,
                              value: "3",
                              label: "3 Habit.",
                            ),
                            SizedBox(width: 5),

                            HotelAttributeCard(
                              icon: Icons.bed,
                              value: "2",
                              label: "2 Cama",
                            ),
                            SizedBox(width: 5),

                            HotelAttributeCard(
                              icon: Icons.bathtub,
                              value: "1",
                              label: "1 Baño",
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        // Calendar
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          decoration: BoxDecoration(
                            border: Border.symmetric(
                              horizontal: BorderSide(
                                width: 1,
                                color: const Color.fromARGB(255, 184, 183, 183),
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "6 noches en Dann Carlton",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 5),

                              Text(
                                "10 de nov. de 2025 - 16 de nov. de 2025",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 20),

                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.all(16),
                                child: HotelCalendar(),
                              ),
                            ],
                          ),
                        ),

                        // About
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Acerca de este espacio",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Hotel de lujo con 2 restaurantes y spa de servicio completo Este hotel para no fumadores cuenta con 2 restaurantes, un spa de servicio completo y una alberca al aire libre. También se ofrecen wifi gratis en las áreas comunes y una recepción de cortesía organizada por la dirección. Además, la propiedad dispone de una sala de fitness, un bar o lounge y un bar junto a la alberca. Dann Carlton Barranquilla tiene 179 opciones de hospedaje con aire acondicionado, minibar y caja de seguridad.",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          BottomReservePanel(),
        ],
      ),
    );
  }
}
