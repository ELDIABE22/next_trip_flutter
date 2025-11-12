import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_trip/features/flights/domain/usecases/search_flights_usecase.dart';
import 'package:next_trip/features/flights/domain/usecases/search_return_flights_usecase.dart';
import 'flight_event.dart';
import 'flight_state.dart';

class FlightBloc extends Bloc<FlightEvent, FlightState> {
  final SearchFlightsUseCase searchFlightsUseCase;
  final SearchReturnFlightsUseCase searchReturnFlightsUseCase;

  FlightBloc({
    required this.searchFlightsUseCase,
    required this.searchReturnFlightsUseCase,
  }) : super(FlightInitial()) {
    on<SearchFlightsRequested>(_onSearchFlightsRequested);
    on<SearchReturnFlightsRequested>(_onSearchReturnFlightsRequested);
    on<SelectOutboundFlight>(_onSelectOutboundFlight);
    on<SelectReturnFlight>(_onSelectReturnFlight);
    on<ClearFlightsRequested>(_onClearFlightsRequested);
  }

  Future<void> _onSearchFlightsRequested(
    SearchFlightsRequested event,
    Emitter<FlightState> emit,
  ) async {
    emit(FlightLoading());

    try {
      final flights = await searchFlightsUseCase.execute(
        originCity: event.originCity,
        destinationCity: event.destinationCity,
        departureDate: event.departureDate,
      );
      emit(FlightLoaded(flights: flights));
    } catch (e) {
      emit(FlightError('Error al buscar vuelos: $e'));
    }
  }

  Future<void> _onSearchReturnFlightsRequested(
    SearchReturnFlightsRequested event,
    Emitter<FlightState> emit,
  ) async {
    if (state is! FlightLoaded) return;

    try {
      final returnFlights = await searchReturnFlightsUseCase.execute(
        originCity: event.originCity,
        destinationCity: event.destinationCity,
        returnDate: event.returnDate,
      );

      final currentState = state as FlightLoaded;
      emit(
        FlightLoaded(
          flights: currentState.flights,
          returnFlights: returnFlights,
          selectedOutboundFlight: currentState.selectedOutboundFlight,
          selectedReturnFlight: currentState.selectedReturnFlight,
        ),
      );
    } catch (e) {
      emit(FlightError('Error al buscar vuelos de regreso: $e'));
    }
  }

  void _onSelectOutboundFlight(
    SelectOutboundFlight event,
    Emitter<FlightState> emit,
  ) {
    if (state is FlightLoaded) {
      final currentState = state as FlightLoaded;
      emit(
        FlightLoaded(
          flights: currentState.flights,
          returnFlights: currentState.returnFlights,
          selectedOutboundFlight: event.flight,
          selectedReturnFlight: currentState.selectedReturnFlight,
        ),
      );
    }
  }

  void _onSelectReturnFlight(
    SelectReturnFlight event,
    Emitter<FlightState> emit,
  ) {
    if (state is FlightLoaded) {
      final currentState = state as FlightLoaded;
      emit(
        FlightLoaded(
          flights: currentState.flights,
          returnFlights: currentState.returnFlights,
          selectedOutboundFlight: currentState.selectedOutboundFlight,
          selectedReturnFlight: event.flight,
        ),
      );
    }
  }

  void _onClearFlightsRequested(
    ClearFlightsRequested event,
    Emitter<FlightState> emit,
  ) {
    emit(FlightInitial());
  }
}
