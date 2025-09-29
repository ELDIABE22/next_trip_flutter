import 'package:cloud_firestore/cloud_firestore.dart';

enum CarCategory {
  compact, // Compacto
  economy, // Económico
  suv, // SUV
  luxury, // Lujo
  pickup, // Pickup
  van, // Van
  convertible, // Convertible
}

enum TransmissionType {
  automatic, // Automática
  manual, // Manual
  hybrid, // Híbrida
}

enum FuelType {
  gasoline, // Gasolina
  diesel, // Diesel
  electric, // Eléctrico
  hybrid, // Híbrido
}

class Car {
  final String id;
  final String name; // "Hyundai Tucson"
  final String brand; // "Hyundai"
  final String model; // "Tucson"
  final String category; // "SUV compacto o similar"
  final CarCategory carCategory; // SUV
  final String imageUrl; // URL de la imagen
  final double pricePerDay; // Precio por día
  final String description; // Descripción del vehículo

  // Especificaciones técnicas
  final int passengers; // 4 pasajeros
  final int luggage; // 3 maletas
  final int doors; // 2 puertas
  final TransmissionType transmission; // Automática/Manual
  final FuelType fuelType; // Tipo de combustible
  final double engineSize; // Tamaño del motor (2.0L)
  final String year; // Año del vehículo
  final String color; // Color del vehículo

  // Información de disponibilidad y ubicación
  final bool isAvailable; // Disponible para alquiler
  final String country;
  final String city;

  // Metadatos
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive; // Activo en el sistema

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

    // Especificaciones técnicas
    required this.passengers,
    required this.luggage,
    required this.doors,
    required this.transmission,
    required this.fuelType,
    this.engineSize = 0.0,
    required this.year,
    this.color = '',

    // Disponibilidad y ubicación
    this.isAvailable = true,
    required this.country,
    required this.city,

    // Metadatos
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

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

  static CarCategory _parseCarCategory(dynamic value) {
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'compact':
          return CarCategory.compact;
        case 'economy':
          return CarCategory.economy;
        case 'suv':
          return CarCategory.suv;
        case 'luxury':
          return CarCategory.luxury;
        case 'pickup':
          return CarCategory.pickup;
        case 'van':
          return CarCategory.van;
        case 'convertible':
          return CarCategory.convertible;
        default:
          return CarCategory.economy;
      }
    }
    return CarCategory.economy;
  }

  static TransmissionType _parseTransmissionType(dynamic value) {
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'automatic':
          return TransmissionType.automatic;
        case 'manual':
          return TransmissionType.manual;
        case 'hybrid':
          return TransmissionType.hybrid;
        default:
          return TransmissionType.automatic;
      }
    }
    return TransmissionType.automatic;
  }

  static FuelType _parseFuelType(dynamic value) {
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'gasoline':
          return FuelType.gasoline;
        case 'diesel':
          return FuelType.diesel;
        case 'electric':
          return FuelType.electric;
        case 'hybrid':
          return FuelType.hybrid;
        default:
          return FuelType.gasoline;
      }
    }
    return FuelType.gasoline;
  }

  factory Car.fromMap(Map<String, dynamic> map, String documentId) {
    return Car(
      id: documentId,
      name: map['name'] ?? '',
      brand: map['brand'] ?? '',
      model: map['model'] ?? '',
      category: map['category'] ?? '',
      carCategory: _parseCarCategory(map['carCategory']),
      imageUrl: map['imageUrl'] ?? '',
      pricePerDay: (map['pricePerDay'] ?? 0).toDouble(),
      description: map['description'] ?? '',

      // Especificaciones técnicas
      passengers: map['passengers'] ?? 0,
      luggage: map['luggage'] ?? 0,
      doors: map['doors'] ?? 0,
      transmission: _parseTransmissionType(map['transmission']),
      fuelType: _parseFuelType(map['fuelType']),
      engineSize: (map['engineSize'] ?? 0).toDouble(),
      year: map['year'] ?? '',
      color: map['color'] ?? '',

      // Disponibilidad y ubicación
      isAvailable: map['isAvailable'] ?? true,
      country: map['country'] ?? '',
      city: map['city'] ?? '',

      // Metadatos
      createdAt: _parseDateTime(map['createdAt']),
      updatedAt: _parseDateTime(map['updatedAt']),
      isActive: map['isActive'] ?? true,
    );
  }

  // Convertir a Map (para Firebase)
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

      // Especificaciones técnicas
      'passengers': passengers,
      'luggage': luggage,
      'doors': doors,
      'transmission': transmission.name,
      'fuelType': fuelType.name,
      'engineSize': engineSize,
      'year': year,
      'color': color,

      // Disponibilidad y ubicación
      'isAvailable': isAvailable,
      'country': country,
      'city': city,

      // Metadatos
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
    };
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'model': model,
      'category': category,
      'carCategory': carCategory.name,
      'imageUrl': imageUrl,
      'pricePerDay': pricePerDay,
      'description': description,

      // Especificaciones técnicas
      'passengers': passengers,
      'luggage': luggage,
      'doors': doors,
      'transmission': transmission.name,
      'fuelType': fuelType.name,
      'engineSize': engineSize,
      'year': year,
      'color': color,

      // Disponibilidad y ubicación
      'isAvailable': isAvailable,
      'country': country,
      'city': city,

      // Metadatos
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  // Getters útiles para mostrar en UI
  String get formattedPrice {
    return '\$${pricePerDay.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  String get fullName => '$brand $model';

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

  // Labels para los tags en UI
  String get passengersLabel =>
      passengers == 1 ? '$passengers Pasaj.' : '$passengers Pasaj.';
  String get luggageLabel =>
      luggage == 1 ? '$luggage Maleta' : '$luggage Maletas';
  String get doorsLabel => doors == 1 ? '$doors Puerta' : '$doors Puertas';

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Car && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
