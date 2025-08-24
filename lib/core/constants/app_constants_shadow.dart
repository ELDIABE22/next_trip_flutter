import 'package:flutter/material.dart';

class AppConstantsShadow {
  static final List<BoxShadow> boxShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      offset: const Offset(0, 2),
      blurRadius: 15,
      spreadRadius: 0,
    ),
  ];
}
