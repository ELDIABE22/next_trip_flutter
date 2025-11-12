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
}
