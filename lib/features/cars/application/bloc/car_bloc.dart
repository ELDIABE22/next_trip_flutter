import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_trip/features/cars/application/bloc/car.state.dart';
import 'package:next_trip/features/cars/application/bloc/car_event.dart';
import 'package:next_trip/features/cars/domain/usecases/get_car_by_id_usecase.dart';
import 'package:next_trip/features/cars/domain/usecases/get_cars_by_city_usecase.dart';
import 'package:next_trip/features/cars/domain/usecases/search_cars_usecase.dart';

class CarBloc extends Bloc<CarEvent, CarState> {
  final GetCarsByCityUseCase getCarsByCityUseCase;
  final GetCarByIdUseCase getCarByIdUseCase;
  final SearchCarsUseCase searchCarsUseCase;

  CarBloc({
    required this.getCarByIdUseCase,
    required this.getCarsByCityUseCase,
    required this.searchCarsUseCase,
  }) : super(CarInitial()) {
    on<LoadCarsByCityRequested>((event, emit) async {
      emit(CarLoading());

      try {
        final cars = await getCarsByCityUseCase.execute(
          event.city,
          country: event.country,
        );

        emit(CarListLoaded(cars));
      } catch (e) {
        emit(CarError(e.toString()));
      }
    });

    on<LoadCarByIdRequested>((event, emit) async {
      emit(CarLoading());

      try {
        final car = await getCarByIdUseCase.execute(event.id);

        emit(CarLoaded(car));
      } catch (e) {
        emit(CarError(e.toString()));
      }
    });

    on<SearchCarsRequested>((event, emit) async {
      emit(CarLoading());

      try {
        final cars = await searchCarsUseCase.execute(
          city: event.city,
          country: event.country,
          minPrice: event.minPrice,
          maxPrice: event.maxPrice,
          minPassengers: event.minPassengers,
          category: event.category,
          transmission: event.transmission,
          fuelType: event.fuelType,
          isAvailable: event.isAvailable,
        );

        emit(CarListLoaded(cars));
      } catch (e) {
        emit(CarError(e.toString()));
      }
    });
  }
}
