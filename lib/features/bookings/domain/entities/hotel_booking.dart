import 'package:next_trip/features/hotels/infrastructure/models/hotel_model.dart';

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
  final HotelModel hotelDetails;

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
    HotelModel? hotelDetails,
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
}
