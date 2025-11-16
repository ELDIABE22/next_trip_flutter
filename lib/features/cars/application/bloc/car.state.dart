import 'package:equatable/equatable.dart';
import 'package:next_trip/features/cars/infrastructure/models/car_model.dart';

abstract class CarState extends Equatable {
  const CarState();

  @override
  List<Object?> get props => [];
}

class CarInitial extends CarState {}

class CarLoading extends CarState {}

class CarSuccess extends CarState {
  final String message;

  const CarSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CarError extends CarState {
  final String error;

  const CarError(this.error);

  @override
  List<Object?> get props => [error];
}

class CarLoaded extends CarState {
  final CarModel? car;

  const CarLoaded(this.car);

  @override
  List<Object?> get props => [car];
}

class CarListLoaded extends CarState {
  final List<CarModel> cars;

  const CarListLoaded(this.cars);

  @override
  List<Object?> get props => [cars];
}
