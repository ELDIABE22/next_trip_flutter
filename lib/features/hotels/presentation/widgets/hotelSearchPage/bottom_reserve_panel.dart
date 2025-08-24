import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/custom_button.dart';

class BottomReservePanel extends StatelessWidget {
  const BottomReservePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(width: 1, color: const Color.fromARGB(255, 161, 161, 161)),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        width: 1,
                        color: const Color(0xFFC5C5C5),
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$4,710,000 COP",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // SizedBox(height: 5),
                      Text(
                        "por 6 noches 10 - 16 de nov",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 15),
              SizedBox(
                width: 160,
                child: CustomButton(text: "Reservar", onPressed: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
