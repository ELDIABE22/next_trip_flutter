import 'package:equatable/equatable.dart';
import 'package:next_trip/features/hotels/infrastructure/models/hotel_model.dart';

abstract class HotelState extends Equatable {
  const HotelState();

  @override
  List<Object?> get props => [];
}

class HotelInitial extends HotelState {}

class HotelLoading extends HotelState {}

class HotelSuccess extends HotelState {
  final String message;

  const HotelSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class HotelError extends HotelState {
  final String error;

  const HotelError(this.error);

  @override
  List<Object?> get props => [error];
}

class HotelLoaded extends HotelState {
  final HotelModel? hotels;

  const HotelLoaded(this.hotels);

  @override
  List<Object?> get props => [hotels];
}

class HotelListLoaded extends HotelState {
  final List<HotelModel> hotels;

  const HotelListLoaded(this.hotels);

  @override
  List<Object?> get props => [hotels];
}

class HotelListSteamLoaded extends HotelState {
  final Stream<List<HotelModel>> hotels;

  const HotelListSteamLoaded(this.hotels);

  @override
  List<Object?> get props => [hotels];
}
