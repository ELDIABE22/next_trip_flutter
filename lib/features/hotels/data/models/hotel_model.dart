import 'package:cloud_firestore/cloud_firestore.dart';

class Hotel {
  final String id;
  final String name;
  final String address;
  final String phone;
  final double price;
  final String imageUrl;
  final String type;
  final int maxGuests;
  final int rooms;
  final int beds;
  final int bathrooms;
  final String description;
  final String country;
  final String city;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isAvailable;

  Hotel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.price,
    required this.imageUrl,
    required this.type,
    required this.maxGuests,
    required this.rooms,
    required this.beds,
    required this.bathrooms,
    required this.description,
    required this.country,
    required this.city,
    required this.createdAt,
    required this.updatedAt,
    this.isAvailable = true,
  });

  factory Hotel.fromMap(Map<String, dynamic> map, String documentId) {
    return Hotel(
      id: documentId,
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
      createdAt: _parseDateTime(map['createdAt']),
      updatedAt: _parseDateTime(map['updatedAt']),
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      type: json['type'] ?? 'Hotel',
      maxGuests: json['maxGuests'] ?? 0,
      rooms: json['rooms'] ?? 0,
      beds: json['beds'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      description: json['description'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      isAvailable: json['isAvailable'] ?? true,
    );
  }

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
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isAvailable': isAvailable,
    };
  }

  Hotel copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    double? price,
    String? imageUrl,
    String? type,
    int? maxGuests,
    int? rooms,
    int? beds,
    int? bathrooms,
    String? description,
    String? country,
    String? city,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isAvailable,
  }) {
    return Hotel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      maxGuests: maxGuests ?? this.maxGuests,
      rooms: rooms ?? this.rooms,
      beds: beds ?? this.beds,
      bathrooms: bathrooms ?? this.bathrooms,
      description: description ?? this.description,
      country: country ?? this.country,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) {
      return DateTime.now();
    }

    if (dateValue is Timestamp) {
      return dateValue.toDate();
    }

    if (dateValue is String) {
      try {
        return DateTime.parse(dateValue);
      } catch (e) {
        return DateTime.now();
      }
    }

    if (dateValue is DateTime) {
      return dateValue;
    }

    if (dateValue is int) {
      return DateTime.fromMillisecondsSinceEpoch(dateValue);
    }

    return DateTime.now();
  }

  String get formattedPrice =>
      '\$${price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';

  String get guestsLabel =>
      maxGuests == 1 ? '$maxGuests Huesp.' : '$maxGuests Huesp.';
  String get roomsLabel => rooms == 1 ? '$rooms Habit.' : '$rooms Habit.';
  String get bedsLabel => beds == 1 ? '$beds Cama' : '$beds Camas';
  String get bathroomsLabel =>
      bathrooms == 1 ? '$bathrooms Baño' : '$bathrooms Baños';

  @override
  String toString() {
    return 'Hotel{id: $id, name: $name, address: $address, price: $price}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Hotel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
