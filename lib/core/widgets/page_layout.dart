import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/custom_navbar.dart';
import 'package:next_trip/core/widgets/header.dart';

class PageLayout extends StatelessWidget {
  final String title;
  final Widget? child;
  final List<Widget>? children;
  final int selectedIndex;
  final Function(int) onItemTapped;

  const PageLayout({
    super.key,
    required this.title,
    this.child,
    this.children,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : assert(
         child != null || children != null,
         'Either child or children must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Header(containerHeight: 120, imageSize: 150, top: -50, right: -30),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: AppConstantsColors.radialBackground.copyWith(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: const Color(0x99000000),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      if (child != null) child!,
                      if (children != null) ...children!,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}
