import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:next_trip/features/bookings/application/bloc/hotel_booking/hotel_booking_event.dart';
import 'package:next_trip/features/bookings/application/bloc/hotel_booking/hotel_booking_state.dart';
import 'package:next_trip/features/bookings/domain/usecases/hotel_booking/cancel_booking_usecase.dart';
import 'package:next_trip/features/bookings/domain/usecases/hotel_booking/create_booking_usecase.dart';
import 'package:next_trip/features/bookings/domain/usecases/hotel_booking/get_bookings_by_user_usecase.dart';

class HotelBookingBloc extends Bloc<HotelBookingEvent, HotelBookingState> {
  final CreateBookingUseCase createBookingUseCase;
  final GetBookingsByUserUseCase getBookingsByUserUseCase;
  final CancelBookingUseCase cancelBookingUseCase;

  HotelBookingBloc({
    required this.createBookingUseCase,
    required this.getBookingsByUserUseCase,
    required this.cancelBookingUseCase,
  }) : super(HotelBookingInitial()) {
    on<CreateBookingRequested>(_onCreateBookingRequested);
    on<GetBookingsByUserRequested>(
      _onGetBookingsByUserRequested,
      transformer: restartable(),
    );
    on<GetUserBookingsStreamRequested>(_onGetUserBookingsStreamRequested);
    on<CancelBookingRequested>(_onCancelBookingRequested);
  }

  Future<void> _onCreateBookingRequested(
    CreateBookingRequested event,
    Emitter<HotelBookingState> emit,
  ) async {
    emit(HotelBookingLoading());

    try {
      final booking = await createBookingUseCase.execute(
        hotel: event.hotel,
        userId: event.userId,
        guestName: event.guestName,
        guestEmail: event.guestEmail,
        guestPhone: event.guestPhone,
        checkInDate: event.checkInDate,
        checkOutDate: event.checkOutDate,
      );
      emit(
        HotelBookingSuccess("Hotel reservado exitosamente!", booking: booking),
      );
    } catch (e) {
      emit(HotelBookingError('Error al crear la reserva del hotel: $e'));
    }
  }

  Future<void> _onGetBookingsByUserRequested(
    GetBookingsByUserRequested event,
    Emitter<HotelBookingState> emit,
  ) async {
    emit(HotelBookingLoading());
    try {
      final bookings = await getBookingsByUserUseCase.execute(
        userId: event.userId,
      );
      emit(HotelBookingsLoaded(bookings));
    } catch (e) {
      emit(
        HotelBookingError(
          'Error al obtener los hoteles reservados del usuario: $e',
        ),
      );
    }
  }

  void _onGetUserBookingsStreamRequested(
    GetUserBookingsStreamRequested event,
    Emitter<HotelBookingState> emit,
  ) {
    if (state is HotelBookingsLoaded) {
      final currentState = state as HotelBookingsLoaded;
      emit(HotelBookingsLoaded(currentState.bookings));
    }
  }

  Future<void> _onCancelBookingRequested(
    CancelBookingRequested event,
    Emitter<HotelBookingState> emit,
  ) async {
    emit(HotelBookingLoading());
    try {
      await cancelBookingUseCase.execute(id: event.id);
      emit(HotelBookingSuccess("Hotel cancelado exitosamente!"));
    } catch (e) {
      emit(
        HotelBookingError(
          'Error al obtener los hoteles reservados del usuario: $e',
        ),
      );
    }
  }
}
