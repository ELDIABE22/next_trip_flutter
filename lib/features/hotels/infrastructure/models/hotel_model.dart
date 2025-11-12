import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:next_trip/core/utils/helpers.dart';
import 'package:next_trip/features/hotels/domain/entities/hotel.dart';

class HotelModel extends Hotel {
  HotelModel({
    required super.id,
    required super.name,
    required super.address,
    required super.phone,
    required super.price,
    required super.imageUrl,
    required super.type,
    required super.maxGuests,
    required super.rooms,
    required super.beds,
    required super.bathrooms,
    required super.description,
    required super.country,
    required super.city,
    super.isAvailable,
    required super.createdAt,
    required super.updatedAt,
  });

  String get formattedPrice =>
      '\$${price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';

  String get guestsLabel =>
      maxGuests == 1 ? '$maxGuests Huesp.' : '$maxGuests Huesp.';
  String get roomsLabel => rooms == 1 ? '$rooms Habit.' : '$rooms Habit.';
  String get bedsLabel => beds == 1 ? '$beds Cama' : '$beds Camas';
  String get bathroomsLabel =>
      bathrooms == 1 ? '$bathrooms Baño' : '$bathrooms Baños';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'price': price,
      'imageUrl': imageUrl,
      'type': type,
      'maxGuests': maxGuests,
      'rooms': rooms,
      'beds': beds,
      'bathrooms': bathrooms,
      'description': description,
      'country': country,
      'city': city,
      'isAvailable': isAvailable,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory HotelModel.fromMap(String id, Map<String, dynamic> map) {
    return HotelModel(
      id: id,
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      type: map['type'] ?? 'Hotel',
      maxGuests: map['maxGuests'] ?? 0,
      rooms: map['rooms'] ?? 0,
      beds: map['beds'] ?? 0,
      bathrooms: map['bathrooms'] ?? 0,
      description: map['description'] ?? '',
      country: map['country'] ?? '',
      city: map['city'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      createdAt: parseDateTime(map['createdAt']),
      updatedAt: parseDateTime(map['updatedAt']),
    );
  }

  factory HotelModel.fromEntity(Hotel hotel) {
    return HotelModel(
      id: hotel.id,
      name: hotel.name,
      address: hotel.address,
      phone: hotel.phone,
      price: hotel.price,
      imageUrl: hotel.imageUrl,
      type: hotel.type,
      maxGuests: hotel.maxGuests,
      rooms: hotel.rooms,
      beds: hotel.beds,
      bathrooms: hotel.bathrooms,
      description: hotel.description,
      country: hotel.country,
      city: hotel.city,
      isAvailable: hotel.isAvailable,
      createdAt: hotel.createdAt,
      updatedAt: hotel.updatedAt,
    );
  }
}
