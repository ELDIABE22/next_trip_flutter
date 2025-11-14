import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:next_trip/features/bookings/domain/entities/hotel_booking.dart';
import 'package:next_trip/features/hotels/infrastructure/models/hotel_model.dart';

class HotelBookingModel extends HotelBooking {
  HotelBookingModel({
    required super.id,
    required super.hotelId,
    required super.userId,
    required super.guestName,
    required super.guestEmail,
    required super.guestPhone,
    required super.checkInDate,
    required super.checkOutDate,
    required super.totalPrice,
    required super.numberOfNights,
    required super.status,
    required super.bookingDate,
    required super.createdAt,
    required super.updatedAt,
    required super.hotelDetails,
  });

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

  String get formattedTotalPrice =>
      '\$${totalPrice.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';

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

  factory HotelBookingModel.fromMap(String id, Map<String, dynamic> map) {
    return HotelBookingModel(
      id: id,
      hotelId: map['hotelId'] ?? '',
      userId: map['userId'] ?? '',
      guestName: map['guestName'] ?? '',
      guestEmail: map['guestEmail'] ?? '',
      guestPhone: map['guestPhone'] ?? '',
      checkInDate: (map['checkInDate'] is Timestamp)
          ? (map['checkInDate'] as Timestamp).toDate()
          : DateTime.parse(map['checkInDate']),
      checkOutDate: (map['checkOutDate'] is Timestamp)
          ? (map['checkOutDate'] as Timestamp).toDate()
          : DateTime.parse(map['checkOutDate']),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      numberOfNights: map['numberOfNights'] ?? 0,
      status: BookingStatus.values.firstWhere(
        (e) => e.name == (map['status'] ?? 'confirmed'),
        orElse: () => BookingStatus.confirmed,
      ),
      bookingDate: (map['bookingDate'] is Timestamp)
          ? (map['bookingDate'] as Timestamp).toDate()
          : DateTime.parse(map['bookingDate']),
      createdAt: (map['createdAt'] is Timestamp)
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.parse(map['createdAt']),
      updatedAt: (map['updatedAt'] is Timestamp)
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.parse(map['updatedAt']),
      hotelDetails: HotelModel.fromMap(
        (map['hotel_details'] as Map<String, dynamic>)['id'] ?? '',
        map['hotel_details'] as Map<String, dynamic>,
      ),
    );
  }

  factory HotelBookingModel.fromEntity(HotelBooking booking) {
    return HotelBookingModel(
      id: booking.id,
      hotelId: booking.hotelId,
      userId: booking.userId,
      guestName: booking.guestName,
      guestEmail: booking.guestEmail,
      guestPhone: booking.guestPhone,
      checkInDate: booking.checkInDate,
      checkOutDate: booking.checkOutDate,
      totalPrice: booking.totalPrice,
      numberOfNights: booking.numberOfNights,
      status: booking.status,
      bookingDate: booking.bookingDate,
      createdAt: booking.createdAt,
      updatedAt: booking.updatedAt,
      hotelDetails: HotelModel.fromEntity(booking.hotelDetails),
    );
  }

  @override
  HotelBookingModel copyWith({
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
    HotelModel? hotelDetails,
  }) {
    return HotelBookingModel(
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
}
