import 'package:flutter/foundation.dart';

// return "dom. 01 de oct"
String formatDateWithWeekday(String dateTimeStr) {
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

// return "01 Octubre 2025"
String formatDateFullMonth(DateTime date) {
  const meses = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];
  final dia = date.day.toString().padLeft(2, '0');
  final mes = meses[date.month - 1];
  final anio = date.year;
  return '$dia $mes $anio';
}

// return "01 Oct. 2025"
String formatDateWithDayMonthYear(DateTime date) {
  const meses = [
    'Ene.',
    'Feb.',
    'Mar.',
    'Abr.',
    'May.',
    'Jun.',
    'Jul.',
    'Ago.',
    'Sep.',
    'Oct.',
    'Nov.',
    'Dic.',
  ];
  final dia = date.day.toString().padLeft(2, '0');
  final mes = meses[date.month - 1];
  final anio = date.year;
  return '$dia $mes $anio';
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

String formatTimeWithAmPm(DateTime dateTime) {
  final hour = dateTime.hour % 12;
  final period = dateTime.hour < 12 ? 'AM' : 'PM';
  final formattedHour = hour == 0 ? 12 : hour;
  final minute = dateTime.minute.toString().padLeft(2, '0');

  return '$formattedHour:$minute $period';
}

/// return "Oct 01, 04:41 AM"
String formatDateTimeWithMonthDayTime(DateTime dateTime) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final month = months[dateTime.month - 1];
  final day = dateTime.day.toString().padLeft(2, '0');
  final time = formatTimeWithAmPm(dateTime);

  return '$month $day, $time';
}

String getStatusTextFlightBooking(String status) {
  switch (status.toLowerCase()) {
    case 'completed':
      return 'Completado';
    case 'cancelled':
      return 'Cancelado';
    case 'pending':
      return 'Pendiente';
    default:
      return status;
  }
}
