import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:next_trip/core/utils/helpers.dart';
import 'package:next_trip/features/cars/domain/entities/car.dart';

class CarModel extends Car {
  CarModel({
    required super.id,
    required super.name,
    required super.brand,
    required super.model,
    required super.category,
    required super.carCategory,
    required super.imageUrl,
    required super.pricePerDay,
    required super.description,
    required super.passengers,
    required super.luggage,
    required super.doors,
    required super.transmission,
    required super.fuelType,
    super.engineSize,
    required super.year,
    super.color,
    super.isAvailable,
    required super.country,
    required super.city,
    required super.createdAt,
    required super.updatedAt,
    super.isActive,
  });

  String get passengersLabel =>
      passengers == 1 ? '$passengers Pasaj.' : '$passengers Pasaj.';

  String get luggageLabel =>
      luggage == 1 ? '$luggage Maleta' : '$luggage Maletas';

  String get doorsLabel => doors == 1 ? '$doors Puerta' : '$doors Puertas';

  String get formattedPrice {
    return '\$${pricePerDay.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  String get transmissionDisplay {
    switch (transmission) {
      case TransmissionType.automatic:
        return 'A';
      case TransmissionType.manual:
        return 'M';
      case TransmissionType.hybrid:
        return 'H';
    }
  }

  String get transmissionFullName {
    switch (transmission) {
      case TransmissionType.automatic:
        return 'Automática';
      case TransmissionType.manual:
        return 'Manual';
      case TransmissionType.hybrid:
        return 'Híbrida';
    }
  }

  String get fuelTypeDisplay {
    switch (fuelType) {
      case FuelType.gasoline:
        return 'Gasolina';
      case FuelType.diesel:
        return 'Diesel';
      case FuelType.electric:
        return 'Eléctrico';
      case FuelType.hybrid:
        return 'Híbrido';
    }
  }

  String get categoryDisplay {
    switch (carCategory) {
      case CarCategory.compact:
        return 'Compacto';
      case CarCategory.economy:
        return 'Económico';
      case CarCategory.suv:
        return 'SUV';
      case CarCategory.luxury:
        return 'Lujo';
      case CarCategory.pickup:
        return 'Pickup';
      case CarCategory.van:
        return 'Van';
      case CarCategory.convertible:
        return 'Convertible';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'brand': brand,
      'model': model,
      'category': category,
      'carCategory': carCategory.name,
      'imageUrl': imageUrl,
      'pricePerDay': pricePerDay,
      'description': description,
      'passengers': passengers,
      'luggage': luggage,
      'doors': doors,
      'transmission': transmission.name,
      'fuelType': fuelType.name,
      'engineSize': engineSize,
      'year': year,
      'color': color,
      'isAvailable': isAvailable,
      'country': country,
      'city': city,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
    };
  }

  factory CarModel.fromMap(String id, Map<String, dynamic> map) {
    return CarModel(
      id: id,
      name: map['name'] ?? '',
      brand: map['brand'] ?? '',
      model: map['model'] ?? '',
      category: map['category'] ?? '',
      carCategory: CarCategory.values.byName(map['carCategory'] ?? 'economy'),
      imageUrl: map['imageUrl'] ?? '',
      pricePerDay: (map['pricePerDay'] ?? 0).toDouble(),
      description: map['description'] ?? '',
      passengers: map['passengers'] ?? 0,
      luggage: map['luggage'] ?? 0,
      doors: map['doors'] ?? 0,
      transmission: TransmissionType.values.byName(
        map['transmission'] ?? 'automatic',
      ),
      fuelType: FuelType.values.byName(map['fuelType'] ?? 'gasoline'),
      engineSize: (map['engineSize'] ?? 0.0).toDouble(),
      year: map['year'] ?? '',
      color: map['color'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      country: map['country'] ?? '',
      city: map['city'] ?? '',
      createdAt: parseDateTime(map['createdAt']),
      updatedAt: parseDateTime(map['updatedAt']),
      isActive: map['isActive'] ?? true,
    );
  }

  factory CarModel.fromEntity(Car entity) {
    return CarModel(
      id: entity.id,
      name: entity.name,
      brand: entity.brand,
      model: entity.model,
      category: entity.category,
      carCategory: entity.carCategory,
      imageUrl: entity.imageUrl,
      pricePerDay: entity.pricePerDay,
      description: entity.description,
      passengers: entity.passengers,
      luggage: entity.luggage,
      doors: entity.doors,
      transmission: entity.transmission,
      fuelType: entity.fuelType,
      engineSize: entity.engineSize,
      year: entity.year,
      color: entity.color,
      isAvailable: entity.isAvailable,
      country: entity.country,
      city: entity.city,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isActive: entity.isActive,
    );
  }
}
