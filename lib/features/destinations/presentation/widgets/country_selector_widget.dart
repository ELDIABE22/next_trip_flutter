import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';

class CountrySelector extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const CountrySelector({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: AppConstantsColors.buttonColor2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.black),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
