import 'package:flutter/foundation.dart';

String formatDate(String dateTimeStr) {
  try {
    final date = DateTime.parse(dateTimeStr);
    final weekdays = ['dom', 'lun', 'mar', 'mié', 'jue', 'vie', 'sáb'];
    final months = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];

    final weekday = weekdays[date.weekday % 7];
    final day = date.day;
    final month = months[date.month - 1];

    return '$weekday. $day de $month';
  } catch (e) {
    debugPrint('Error al formatear fecha: $e');
    debugPrint('Cadena de fecha recibida: $dateTimeStr');
    return 'Fecha no disponible';
  }
}

String formatTime(String dateTimeStr) {
  try {
    final time = DateTime.parse(dateTimeStr);
    final hour = time.hour % 12;
    final period = time.hour < 12 ? 'A.M' : 'P.M';
    final formattedHour = hour == 0 ? 12 : hour;

    return '${formattedHour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  } catch (e) {
    return '--:-- --';
  }
}
