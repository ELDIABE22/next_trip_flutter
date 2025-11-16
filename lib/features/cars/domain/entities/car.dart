enum CarCategory { compact, economy, suv, luxury, pickup, van, convertible }

enum TransmissionType { automatic, manual, hybrid }

enum FuelType { gasoline, diesel, electric, hybrid }

class Car {
  final String id;
  final String name;
  final String brand;
  final String model;
  final String category;
  final CarCategory carCategory;
  final String imageUrl;
  final double pricePerDay;
  final String description;
  final int passengers;
  final int luggage;
  final int doors;
  final TransmissionType transmission;
  final FuelType fuelType;
  final double engineSize;
  final String year;
  final String color;
  final bool isAvailable;
  final String country;
  final String city;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  Car({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.category,
    required this.carCategory,
    required this.imageUrl,
    required this.pricePerDay,
    required this.description,
    required this.passengers,
    required this.luggage,
    required this.doors,
    required this.transmission,
    required this.fuelType,
    this.engineSize = 0.0,
    required this.year,
    this.color = '',
    this.isAvailable = true,
    required this.country,
    required this.city,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  Car copyWith({
    String? id,
    String? name,
    String? brand,
    String? model,
    String? category,
    CarCategory? carCategory,
    String? imageUrl,
    double? pricePerDay,
    String? description,
    int? passengers,
    int? luggage,
    int? doors,
    TransmissionType? transmission,
    FuelType? fuelType,
    double? engineSize,
    String? year,
    String? color,
    bool? isAvailable,
    String? country,
    String? city,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return Car(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      category: category ?? this.category,
      carCategory: carCategory ?? this.carCategory,
      imageUrl: imageUrl ?? this.imageUrl,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      description: description ?? this.description,
      passengers: passengers ?? this.passengers,
      luggage: luggage ?? this.luggage,
      doors: doors ?? this.doors,
      transmission: transmission ?? this.transmission,
      fuelType: fuelType ?? this.fuelType,
      engineSize: engineSize ?? this.engineSize,
      year: year ?? this.year,
      color: color ?? this.color,
      isAvailable: isAvailable ?? this.isAvailable,
      country: country ?? this.country,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
