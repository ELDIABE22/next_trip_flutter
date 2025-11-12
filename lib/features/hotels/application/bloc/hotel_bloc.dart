import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_trip/features/hotels/application/bloc/hotel_event.dart';
import 'package:next_trip/features/hotels/application/bloc/hotel_state.dart';
import 'package:next_trip/features/hotels/domain/usecases/get_all_hotels_usecase.dart';
import 'package:next_trip/features/hotels/domain/usecases/get_hotel_by_id_usecase.dart';
import 'package:next_trip/features/hotels/domain/usecases/get_hotels_by_city_stream_usecase.dart';
import 'package:next_trip/features/hotels/domain/usecases/get_hotels_by_city_usecase.dart';
import 'package:next_trip/features/hotels/domain/usecases/get_hotels_stream_usecase.dart';
import 'package:next_trip/features/hotels/domain/usecases/hotel_refresh_usecase.dart';

class HotelBloc extends Bloc<HotelEvent, HotelState> {
  final GetAllHotelsUsecase getAllHotelsUsecase;
  final GetHotelsByCityUsecase getHotelsByCityUsecase;
  final GetHotelByIdUsecase getHotelByIdUsecase;
  final GetHotelsByCityStreamUsecase getHotelsByCityStreamUsecase;
  final GetHotelsStreamUsecase getHotelsStreamUsecase;
  final HotelRefreshUsecase hotelRefreshUsecase;

  HotelBloc({
    required this.getAllHotelsUsecase,
    required this.getHotelsByCityUsecase,
    required this.getHotelByIdUsecase,
    required this.getHotelsByCityStreamUsecase,
    required this.getHotelsStreamUsecase,
    required this.hotelRefreshUsecase,
  }) : super(HotelInitial()) {
    on<GetAllHotelsRequested>(_onGetAllHotelsRequested);
    on<GetHotelsByCityRequested>(_onGetHotelsByCityRequested);
    on<GetHotelByIdRequested>(_onGetHotelByIdRequested);
    on<GetHotelsByCityStreamRequested>(_onGetHotelsByCityStreamRequested);
    on<GetHotelsStreamRequested>(_onGetHotelsStreamRequested);
    on<HotelRefreshRequested>(_onHotelRefreshRequested);
  }

  Future<void> _onGetAllHotelsRequested(
    GetAllHotelsRequested event,
    Emitter<HotelState> emit,
  ) async {
    emit(HotelLoading());
    try {
      final hotels = await getAllHotelsUsecase.execute();
      emit(HotelListLoaded(hotels));
    } catch (e) {
      emit(HotelError('Error al obtener todos los hoteles: $e'));
    }
  }

  Future<void> _onGetHotelsByCityRequested(
    GetHotelsByCityRequested event,
    Emitter<HotelState> emit,
  ) async {
    emit(HotelLoading());
    try {
      final hotels = await getHotelsByCityUsecase.execute(
        city: event.city,
        country: event.country,
      );
      emit(HotelListLoaded(hotels));
    } catch (e) {
      emit(HotelError('Error al obtener los hoteles por ciudad: $e'));
    }
  }

  Future<void> _onGetHotelByIdRequested(
    GetHotelByIdRequested event,
    Emitter<HotelState> emit,
  ) async {
    emit(HotelLoading());
    try {
      final hotels = await getHotelByIdUsecase.execute(id: event.id);
      emit(HotelLoaded(hotels));
    } catch (e) {
      emit(HotelError('Error al obtener los hoteles por id: $e'));
    }
  }

  Future<void> _onGetHotelsByCityStreamRequested(
    GetHotelsByCityStreamRequested event,
    Emitter<HotelState> emit,
  ) async {
    emit(HotelLoading());
    try {
      final hotels = getHotelsByCityStreamUsecase.execute(
        city: event.city,
        country: event.country,
      );
      emit(HotelListSteamLoaded(hotels));
    } catch (e) {
      emit(
        HotelError(
          'Error al obtener los hoteles por ciudad en tiempo real: $e',
        ),
      );
    }
  }

  Future<void> _onGetHotelsStreamRequested(
    GetHotelsStreamRequested event,
    Emitter<HotelState> emit,
  ) async {
    emit(HotelLoading());
    try {
      final hotels = getHotelsStreamUsecase.execute();
      emit(HotelListSteamLoaded(hotels));
    } catch (e) {
      emit(HotelError('Error al obtener los hoteles en tiempo real: $e'));
    }
  }

  Future<void> _onHotelRefreshRequested(
    HotelRefreshRequested event,
    Emitter<HotelState> emit,
  ) async {
    emit(HotelLoading());
    try {
      await hotelRefreshUsecase.execute();
      emit(HotelSuccess(""));
    } catch (e) {
      emit(HotelError('Error al refrescar los hoteles: $e'));
    }
  }
}
