import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_trip/features/bookings/application/bloc/flight_booking/flight_booking_event.dart';
import 'package:next_trip/features/bookings/application/bloc/flight_booking/flight_booking_state.dart';
import 'package:next_trip/features/bookings/domain/usecases/flight_booking/cancel_booking_usecase.dart';
import 'package:next_trip/features/bookings/domain/usecases/flight_booking/create_booking_usecase.dart';
import 'package:next_trip/features/bookings/domain/usecases/flight_booking/create_round_trip_booking_usecase.dart';
import 'package:next_trip/features/bookings/domain/usecases/flight_booking/get_user_bookings_usecase.dart';
import 'package:next_trip/features/bookings/domain/usecases/flight_booking/get_user_round_trip_bookings_usecase.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

class FlightBookingBloc extends Bloc<FlightBookingEvent, FlightBookingState> {
  final CreateBookingUseCase createBookingUseCase;
  final CreateRoundTripBookingUseCase createRoundTripBookingUseCase;
  final GetUserBookingsUseCase getUserBookingsUseCase;
  final GetUserRoundTripBookingsUseCase getUserRoundTripBookingsUseCase;
  final CancelBookingUseCase cancelBookingUsecase;

  FlightBookingBloc({
    required this.createBookingUseCase,
    required this.createRoundTripBookingUseCase,
    required this.getUserBookingsUseCase,
    required this.getUserRoundTripBookingsUseCase,
    required this.cancelBookingUsecase,
  }) : super(FlightBookingInitial()) {
    on<CreateBookingRequested>(_onCreateBookingRequested);
    on<CreateRoundTripBookingRequested>(_onCreateRoundTripBookingRequested);
    on<GetUserBookingsRequested>(
      _onGetUserBookingsRequested,
      transformer: restartable(),
    );
    on<GetUserRoundTripBookingsRequested>(_onGetUserRoundTripBookingsRequested);
    on<CancelBookingRequested>(_onCancelBookingRequested);
  }

  Future<void> _onCreateBookingRequested(
    CreateBookingRequested event,
    Emitter<FlightBookingState> emit,
  ) async {
    emit(FlightBookingLoading());

    try {
      await createBookingUseCase.execute(
        userId: event.userId,
        flight: event.flight,
        seats: event.seats,
        passengers: event.passengers,
        totalPrice: event.totalPrice,
      );
      emit(FlightBookingSuccess("Vuelo reservado exitosamente!"));
    } catch (e) {
      emit(FlightBookingError('Error al crear reserva: $e'));
    }
  }

  Future<void> _onCreateRoundTripBookingRequested(
    CreateRoundTripBookingRequested event,
    Emitter<FlightBookingState> emit,
  ) async {
    emit(FlightBookingLoading());

    try {
      await createRoundTripBookingUseCase.execute(
        userId: event.userId,
        outboundFlight: event.outboundFlight,
        returnFlight: event.returnFlight,
        outboundSeats: event.outboundSeats,
        returnSeats: event.returnSeats,
        passengers: event.passengers,
        totalPrice: event.totalPrice,
      );
      emit(FlightBookingSuccess("Vuelo reservado exitosamente!"));
    } catch (e) {
      emit(FlightBookingError('Error al crear reserva ida y vuelta: $e'));
    }
  }

  Future<void> _onGetUserBookingsRequested(
    GetUserBookingsRequested event,
    Emitter<FlightBookingState> emit,
  ) async {
    emit(FlightBookingLoading());
    try {
      final bookings = await getUserBookingsUseCase.execute(
        userId: event.userId,
      );
      emit(UserBookingsLoaded(bookings));
    } catch (e) {
      emit(FlightBookingError('Error al obtener los vuelos del usuario: $e'));
    }
  }

  Future<void> _onGetUserRoundTripBookingsRequested(
    GetUserRoundTripBookingsRequested event,
    Emitter<FlightBookingState> emit,
  ) async {
    emit(FlightBookingLoading());
    try {
      final roundTripBookings = await getUserRoundTripBookingsUseCase.execute(
        userId: event.userId,
      );

      emit(UserRoundTripBookingsLoaded(roundTripBookings));
    } catch (e) {
      emit(
        FlightBookingError(
          'Error al obtener los vuelos de ida y vuelta del usuario: $e',
        ),
      );
    }
  }

  Future<void> _onCancelBookingRequested(
    CancelBookingRequested event,
    Emitter<FlightBookingState> emit,
  ) async {
    emit(FlightBookingLoading());
    try {
      await cancelBookingUsecase.execute(bookingId: event.bookingId);
      emit(FlightBookingSuccess("Reserva cancelada exitosamente."));
    } catch (e) {
      emit(FlightBookingError("Error al cancelar la reserva: $e"));
    }
  }
}
