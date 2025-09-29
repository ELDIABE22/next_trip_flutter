import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:next_trip/features/hotels/data/models/hotel_model.dart';

enum BookingStatus { confirmed, cancelled, completed }

class HotelBooking {
  final String id;
  final String hotelId;
  final String userId;
  final String guestName;
  final String guestEmail;
  final String guestPhone;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final double totalPrice;
  final int numberOfNights;
  final BookingStatus status;
  final DateTime bookingDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Hotel hotelDetails;

  HotelBooking({
    required this.id,
    required this.hotelId,
    required this.userId,
    required this.guestName,
    required this.guestEmail,
    required this.guestPhone,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalPrice,
    required this.numberOfNights,
    required this.status,
    required this.bookingDate,
    required this.createdAt,
    required this.updatedAt,
    required this.hotelDetails,
  });

  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();
    if (dateValue is Timestamp) return dateValue.toDate();
    if (dateValue is String) {
      try {
        return DateTime.parse(dateValue);
      } catch (e) {
        return DateTime.now();
      }
    }
    if (dateValue is DateTime) return dateValue;
    return DateTime.now();
  }

  static BookingStatus _parseStatus(dynamic statusValue) {
    if (statusValue is String) {
      switch (statusValue.toLowerCase()) {
        case 'confirmed':
          return BookingStatus.confirmed;
        case 'cancelled':
          return BookingStatus.cancelled;
        case 'completed':
          return BookingStatus.completed;
        default:
          return BookingStatus.completed;
      }
    }
    return BookingStatus.completed;
  }

  factory HotelBooking.fromMap(Map<String, dynamic> map, String documentId) {
    Hotel hotelDetails;
    if (map['hotel_details'] != null &&
        map['hotel_details'] is Map<String, dynamic>) {
      hotelDetails = Hotel.fromMap(
        map['hotel_details'] as Map<String, dynamic>,
        map['hotelId'] ?? '',
      );
    } else {
      hotelDetails = Hotel(
        id: map['hotelId'] ?? '',
        name: 'Hotel no disponible',
        address: '',
        phone: '',
        price: 0.0,
        imageUrl: '',
        type: 'Hotel',
        maxGuests: 0,
        rooms: 0,
        beds: 0,
        bathrooms: 0,
        description: '',
        country: '',
        city: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isAvailable: false,
      );
    }

    return HotelBooking(
      id: documentId,
      hotelId: map['hotelId'] ?? '',
      userId: map['userId'] ?? '',
      guestName: map['guestName'] ?? '',
      guestEmail: map['guestEmail'] ?? '',
      guestPhone: map['guestPhone'] ?? '',
      checkInDate: _parseDateTime(map['checkInDate']),
      checkOutDate: _parseDateTime(map['checkOutDate']),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      numberOfNights: map['numberOfNights'] ?? 1,
      status: _parseStatus(map['status']),
      bookingDate: _parseDateTime(map['bookingDate']),
      createdAt: _parseDateTime(map['createdAt']),
      updatedAt: _parseDateTime(map['updatedAt']),
      hotelDetails: hotelDetails,
    );
  }

  factory HotelBooking.fromJson(Map<String, dynamic> json) {
    Hotel hotelDetails;
    if (json['hotel_details'] != null &&
        json['hotel_details'] is Map<String, dynamic>) {
      hotelDetails = Hotel.fromJson(
        json['hotel_details'] as Map<String, dynamic>,
      );
    } else {
      hotelDetails = Hotel(
        id: json['hotelId'] ?? '',
        name: 'Hotel no disponible',
        address: '',
        phone: '',
        price: 0.0,
        imageUrl: '',
        type: 'Hotel',
        maxGuests: 0,
        rooms: 0,
        beds: 0,
        bathrooms: 0,
        description: '',
        country: '',
        city: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isAvailable: false,
      );
    }

    return HotelBooking(
      id: json['id'] ?? '',
      hotelId: json['hotelId'] ?? '',
      userId: json['userId'] ?? '',
      guestName: json['guestName'] ?? '',
      guestEmail: json['guestEmail'] ?? '',
      guestPhone: json['guestPhone'] ?? '',
      checkInDate: _parseDateTime(json['checkInDate']),
      checkOutDate: _parseDateTime(json['checkOutDate']),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      numberOfNights: json['numberOfNights'] ?? 1,
      status: _parseStatus(json['status']),
      bookingDate: _parseDateTime(json['bookingDate']),
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      hotelDetails: hotelDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hotelId': hotelId,
      'userId': userId,
      'guestName': guestName,
      'guestEmail': guestEmail,
      'guestPhone': guestPhone,
      'checkInDate': Timestamp.fromDate(checkInDate),
      'checkOutDate': Timestamp.fromDate(checkOutDate),
      'totalPrice': totalPrice,
      'numberOfNights': numberOfNights,
      'status': status.name,
      'bookingDate': Timestamp.fromDate(bookingDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'hotel_details': hotelDetails.toMap(),
    };
  }

  String get formattedTotalPrice =>
      '\$${totalPrice.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';

  String get statusDisplayText {
    switch (status) {
      case BookingStatus.confirmed:
        return 'Confirmada';
      case BookingStatus.cancelled:
        return 'Cancelada';
      case BookingStatus.completed:
        return 'Completada';
    }
  }

  String get checkInFormatted =>
      '${checkInDate.day}/${checkInDate.month}/${checkInDate.year}';
  String get checkOutFormatted =>
      '${checkOutDate.day}/${checkOutDate.month}/${checkOutDate.year}';
  String get bookingDateFormatted =>
      '${bookingDate.day}/${bookingDate.month}/${bookingDate.year}';

  String get dateRange => '$checkInFormatted - $checkOutFormatted';

  Duration get duration => checkOutDate.difference(checkInDate);

  bool get isConfirmed => status == BookingStatus.confirmed;
  bool get isCancelled => status == BookingStatus.cancelled;
  bool get isCompleted => status == BookingStatus.completed;

  bool get canBeCancelled => status == BookingStatus.confirmed;

  String get hotelName => hotelDetails.name;
  String get hotelAddress => hotelDetails.address;
  String get hotelCity => hotelDetails.city;
  String get hotelCountry => hotelDetails.country;
  String get hotelImageUrl => hotelDetails.imageUrl;
  double get pricePerNight => hotelDetails.price;

  HotelBooking copyWith({
    String? id,
    String? hotelId,
    String? userId,
    String? guestName,
    String? guestEmail,
    String? guestPhone,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    double? totalPrice,
    int? numberOfNights,
    BookingStatus? status,
    DateTime? bookingDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    Hotel? hotelDetails,
  }) {
    return HotelBooking(
      id: id ?? this.id,
      hotelId: hotelId ?? this.hotelId,
      userId: userId ?? this.userId,
      guestName: guestName ?? this.guestName,
      guestEmail: guestEmail ?? this.guestEmail,
      guestPhone: guestPhone ?? this.guestPhone,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      totalPrice: totalPrice ?? this.totalPrice,
      numberOfNights: numberOfNights ?? this.numberOfNights,
      status: status ?? this.status,
      bookingDate: bookingDate ?? this.bookingDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hotelDetails: hotelDetails ?? this.hotelDetails,
    );
  }

  @override
  String toString() {
    return 'HotelBooking{id: $id, hotelName: $hotelName, guestName: $guestName, status: $status, dateRange: $dateRange}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HotelBooking && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
