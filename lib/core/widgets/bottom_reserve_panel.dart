import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/custom_button.dart';

class BottomReservePanel extends StatelessWidget {
  final String totalPrice;
  final String? dateRange;
  final String buttonText;
  final VoidCallback? onPressed;
  final bool isLoading;

  const BottomReservePanel({
    super.key,
    required this.totalPrice,
    this.dateRange,
    required this.buttonText,
    this.onPressed,
    this.isLoading = false,
  });

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
              top: BorderSide(
                width: 1,
                color: const Color.fromARGB(255, 161, 161, 161),
              ),
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
                        totalPrice,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      // SizedBox(height: 5),
                      if (dateRange != null)
                        Text(
                          dateRange!,
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
                child: CustomButton(
                  text: buttonText,
                  onPressed: isLoading ? null : onPressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
