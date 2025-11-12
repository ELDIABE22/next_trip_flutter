import 'package:equatable/equatable.dart';

abstract class HotelEvent extends Equatable {
  const HotelEvent();

  @override
  List<Object?> get props => [];
}

class GetAllHotelsRequested extends HotelEvent {}

class GetHotelsByCityRequested extends HotelEvent {
  final String city;
  final String? country;

  const GetHotelsByCityRequested({required this.city, this.country});

  @override
  List<Object?> get props => [city, country];
}

class GetHotelByIdRequested extends HotelEvent {
  final String id;

  const GetHotelByIdRequested({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetHotelsByCityStreamRequested extends HotelEvent {
  final String city;
  final String? country;

  const GetHotelsByCityStreamRequested({required this.city, this.country});

  @override
  List<Object?> get props => [city, country];
}

class GetHotelsStreamRequested extends HotelEvent {}

class HotelRefreshRequested extends HotelEvent {}
