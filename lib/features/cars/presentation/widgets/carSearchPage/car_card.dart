import 'package:flutter/material.dart';
import 'package:next_trip/features/cars/presentation/pages/car_datails_page.dart';
import 'package:next_trip/features/cars/presentation/widgets/carSearchPage/car_attribute_tag.dart';

class CarCard extends StatelessWidget {
  const CarCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CarDetailsPage()),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      // borderRadius: const BorderRadius.only(
                      //   bottomLeft: Radius.circular(25),
                      //   bottomRight: Radius.circular(25),
                      // ),
                      child: Image.asset(
                        'assets/images/carro.webp',
                        width: double.infinity,
                        height: 210,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 10,
                    right: 20,
                    left: 20,
                    bottom: 20,
                  ),
                  decoration: BoxDecoration(color: const Color(0xFFF6F3F3)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hyundai Tucson",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "SUV compacto o similar",
                                style: TextStyle(
                                  color: const Color(0xFF8F8F8F),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),

                          Text(
                            '\$2,252,176',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CarAttributeTag(title: "4", icon: Icons.person),
                          SizedBox(width: 10),
                          CarAttributeTag(title: "3", icon: Icons.work),
                          SizedBox(width: 10),
                          CarAttributeTag(title: "2", icon: Icons.meeting_room),
                          SizedBox(width: 10),
                          CarAttributeTag(
                            title: "A",
                            icon: Icons.settings_input_component,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
