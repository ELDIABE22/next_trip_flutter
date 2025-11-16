import 'package:equatable/equatable.dart';
import 'package:next_trip/features/cars/domain/entities/car.dart';

abstract class CarEvent extends Equatable {
  const CarEvent();

  @override
  List<Object?> get props => [];
}

class LoadCarsByCityRequested extends CarEvent {
  final String city;
  final String? country;

  const LoadCarsByCityRequested({required this.city, this.country});

  @override
  List<Object?> get props => [city, country];
}

class LoadCarByIdRequested extends CarEvent {
  final String id;

  const LoadCarByIdRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class SearchCarsRequested extends CarEvent {
  final String? city;
  final String? country;
  final double? minPrice;
  final double? maxPrice;
  final int? minPassengers;
  final CarCategory? category;
  final TransmissionType? transmission;
  final FuelType? fuelType;
  final bool? isAvailable;

  const SearchCarsRequested({
    this.city,
    this.country,
    this.minPrice,
    this.maxPrice,
    this.minPassengers,
    this.category,
    this.transmission,
    this.fuelType,
    this.isAvailable,
  });

  @override
  List<Object?> get props => [
    city,
    country,
    minPrice,
    maxPrice,
    minPassengers,
    category,
    transmission,
    fuelType,
    isAvailable,
  ];
}
