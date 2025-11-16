import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:next_trip/features/cars/infrastructure/models/car_model.dart';

enum BookingStatus {
  confirmed, // Confirmada
  cancelled, // Cancelada
  completed, // Completada
  inProgress, // En progreso
}

class CarBooking {
  final String id;
  final String userId;
  final String carId;

  // Información del carro (objeto anidado)
  final CarModel carDetails;

  // Información de la reserva
  final DateTime pickupDate;
  final DateTime returnDate;
  final TimeOfDay pickupTime;
  final TimeOfDay returnTime;
  final String pickupLocation;
  final String returnLocation;

  // Información del huésped
  final String guestName;
  final String guestEmail;
  final String guestPhone;
  final String guestLicenseNumber;

  // Detalles financieros
  final int numberOfDays;
  final double subtotal;
  final double taxes;
  final double insuranceFee;
  final double totalPrice;
  final String currency;

  // Estado y metadatos
  final BookingStatus status;
  final DateTime bookingDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  CarBooking({
    required this.id,
    required this.userId,
    required this.carId,
    required this.carDetails,
    required this.pickupDate,
    required this.returnDate,
    required this.pickupTime,
    required this.returnTime,
    required this.pickupLocation,
    required this.returnLocation,
    required this.guestName,
    required this.guestEmail,
    required this.guestPhone,
    required this.guestLicenseNumber,
    required this.numberOfDays,
    required this.subtotal,
    required this.taxes,
    required this.insuranceFee,
    required this.totalPrice,
    this.currency = 'COP',
    this.status = BookingStatus.confirmed,
    DateTime? bookingDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isActive = true,
  }) : bookingDate = bookingDate ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory CarBooking.fromMap(Map<String, dynamic> map, String documentId) {
    return CarBooking(
      id: documentId,
      userId: map['userId'] ?? '',
      carId: map['carId'] ?? '',

      carDetails: CarModel.fromMap(
        map['carId'] ?? '',
        map['car_details'] as Map<String, dynamic>? ?? {},
      ),

      pickupDate: (map['pickupDate'] as Timestamp).toDate(),
      returnDate: (map['returnDate'] as Timestamp).toDate(),
      pickupTime: TimeOfDay(
        hour: map['pickupHour'] ?? 10,
        minute: map['pickupMinute'] ?? 0,
      ),
      returnTime: TimeOfDay(
        hour: map['returnHour'] ?? 10,
        minute: map['returnMinute'] ?? 0,
      ),
      pickupLocation: map['pickupLocation'] ?? '',
      returnLocation: map['returnLocation'] ?? '',

      guestName: map['guestName'] ?? '',
      guestEmail: map['guestEmail'] ?? '',
      guestPhone: map['guestPhone'] ?? '',
      guestLicenseNumber: map['guestLicenseNumber'] ?? '',

      numberOfDays: map['numberOfDays'] ?? 0,
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      taxes: (map['taxes'] ?? 0).toDouble(),
      insuranceFee: (map['insuranceFee'] ?? 0).toDouble(),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      currency: map['currency'] ?? 'COP',

      status: BookingStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => BookingStatus.confirmed,
      ),
      bookingDate:
          (map['bookingDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'carId': carId,

      'car_details': carDetails.toMap(),

      'pickupDate': Timestamp.fromDate(pickupDate),
      'returnDate': Timestamp.fromDate(returnDate),
      'pickupHour': pickupTime.hour,
      'pickupMinute': pickupTime.minute,
      'returnHour': returnTime.hour,
      'returnMinute': returnTime.minute,
      'pickupLocation': pickupLocation,
      'returnLocation': returnLocation,

      'guestName': guestName,
      'guestEmail': guestEmail,
      'guestPhone': guestPhone,
      'guestLicenseNumber': guestLicenseNumber,

      'numberOfDays': numberOfDays,
      'subtotal': subtotal,
      'taxes': taxes,
      'insuranceFee': insuranceFee,
      'totalPrice': totalPrice,
      'currency': currency,

      'status': status.name,
      'bookingDate': Timestamp.fromDate(bookingDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
    };
  }

  factory CarBooking.fromCar({
    required String id,
    required String userId,
    required CarModel car,
    required DateTime pickupDate,
    required DateTime returnDate,
    required TimeOfDay pickupTime,
    required TimeOfDay returnTime,
    required String pickupLocation,
    required String returnLocation,
    required String guestName,
    required String guestEmail,
    required String guestPhone,
    required String guestLicenseNumber,
  }) {
    final numberOfDays = returnDate.difference(pickupDate).inDays;
    final subtotal = car.pricePerDay * numberOfDays;
    final taxes = subtotal * 0.19; // IVA del 19%
    final insuranceFee = subtotal * 0.10; // Seguro del 10%
    final totalPrice = subtotal + taxes + insuranceFee;

    return CarBooking(
      id: id,
      userId: userId,
      carId: car.id,
      carDetails: car,
      pickupDate: pickupDate,
      returnDate: returnDate,
      pickupTime: pickupTime,
      returnTime: returnTime,
      pickupLocation: pickupLocation,
      returnLocation: returnLocation,
      guestName: guestName,
      guestEmail: guestEmail,
      guestPhone: guestPhone,
      guestLicenseNumber: guestLicenseNumber,
      numberOfDays: numberOfDays,
      subtotal: subtotal,
      taxes: taxes,
      insuranceFee: insuranceFee,
      totalPrice: totalPrice,
    );
  }

  // Getters útiles
  String get formattedTotalPrice {
    return '\$${totalPrice.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  String get formattedSubtotal {
    return '\$${subtotal.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  String get formattedTaxes {
    return '\$${taxes.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  String get formattedInsurance {
    return '\$${insuranceFee.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  String get pickupDateFormatted {
    return DateFormat('dd/MM/yyyy').format(pickupDate);
  }

  String get returnDateFormatted {
    return DateFormat('dd/MM/yyyy').format(returnDate);
  }

  String get pickupTimeFormatted {
    return '${pickupTime.hour.toString().padLeft(2, '0')}:${pickupTime.minute.toString().padLeft(2, '0')}';
  }

  String get returnTimeFormatted {
    return '${returnTime.hour.toString().padLeft(2, '0')}:${returnTime.minute.toString().padLeft(2, '0')}';
  }

  String get bookingDateFormatted {
    return DateFormat('dd/MM/yyyy HH:mm').format(bookingDate);
  }

  String get statusDisplayText {
    switch (status) {
      case BookingStatus.confirmed:
        return 'Confirmada';
      case BookingStatus.cancelled:
        return 'Cancelada';
      case BookingStatus.completed:
        return 'Completada';
      case BookingStatus.inProgress:
        return 'En progreso';
    }
  }

  String get dateRange {
    return '$pickupDateFormatted - $returnDateFormatted';
  }

  String get timeRange {
    return '$pickupTimeFormatted - $returnTimeFormatted';
  }

  // Acceso directo a propiedades del carro a través de carDetails
  String get carName => carDetails.name;
  String get carBrand => carDetails.brand;
  String get carModel => carDetails.model;
  String get carImageUrl => carDetails.imageUrl;
  String get carCategory => carDetails.category;
  double get carPricePerDay => carDetails.pricePerDay;
  String get fullCarName => '${carDetails.brand} ${carDetails.model}';

  // Estados de la reserva
  bool get isConfirmed => status == BookingStatus.confirmed;
  bool get isCancelled => status == BookingStatus.cancelled;
  bool get isCompleted => status == BookingStatus.completed;
  bool get isInProgress => status == BookingStatus.inProgress;

  // Verificar si se puede cancelar
  bool get canBeCancelled {
    return (status == BookingStatus.confirmed ||
            status == BookingStatus.inProgress) &&
        pickupDate.isAfter(DateTime.now().add(const Duration(hours: 24)));
  }

  // Verificar si se puede modificar
  bool get canBeModified {
    return status == BookingStatus.confirmed &&
        pickupDate.isAfter(DateTime.now().add(const Duration(hours: 48)));
  }

  // Días hasta la recogida
  int get daysUntilPickup {
    return pickupDate.difference(DateTime.now()).inDays;
  }

  // Duración de la reserva en texto
  String get durationText {
    if (numberOfDays == 1) {
      return '1 día';
    } else {
      return '$numberOfDays días';
    }
  }

  // Crear copia con modificaciones
  CarBooking copyWith({
    String? id,
    String? userId,
    String? carId,
    CarModel? carDetails,
    DateTime? pickupDate,
    DateTime? returnDate,
    TimeOfDay? pickupTime,
    TimeOfDay? returnTime,
    String? pickupLocation,
    String? returnLocation,
    String? guestName,
    String? guestEmail,
    String? guestPhone,
    String? guestLicenseNumber,
    int? numberOfDays,
    double? subtotal,
    double? taxes,
    double? insuranceFee,
    double? totalPrice,
    String? currency,
    BookingStatus? status,
    DateTime? bookingDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return CarBooking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      carId: carId ?? this.carId,
      carDetails: carDetails ?? this.carDetails,
      pickupDate: pickupDate ?? this.pickupDate,
      returnDate: returnDate ?? this.returnDate,
      pickupTime: pickupTime ?? this.pickupTime,
      returnTime: returnTime ?? this.returnTime,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      returnLocation: returnLocation ?? this.returnLocation,
      guestName: guestName ?? this.guestName,
      guestEmail: guestEmail ?? this.guestEmail,
      guestPhone: guestPhone ?? this.guestPhone,
      guestLicenseNumber: guestLicenseNumber ?? this.guestLicenseNumber,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      subtotal: subtotal ?? this.subtotal,
      taxes: taxes ?? this.taxes,
      insuranceFee: insuranceFee ?? this.insuranceFee,
      totalPrice: totalPrice ?? this.totalPrice,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      bookingDate: bookingDate ?? this.bookingDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CarBooking && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
