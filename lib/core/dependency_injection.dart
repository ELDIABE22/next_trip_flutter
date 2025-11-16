import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

// Auth imports
import 'package:next_trip/features/auth/application/bloc/auth_bloc.dart';
import 'package:next_trip/features/auth/domain/repositories/auth_repository.dart';
import 'package:next_trip/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:next_trip/features/auth/domain/usecases/register_usecase.dart';
import 'package:next_trip/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:next_trip/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:next_trip/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:next_trip/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:next_trip/features/auth/infrastructure/datasources/auth_remote_datasource.dart';
import 'package:next_trip/features/auth/infrastructure/repositories/auth_repository_impl.dart';

// Flight imports
import 'package:next_trip/features/flights/application/bloc/flight_bloc.dart';
import 'package:next_trip/features/flights/domain/repositories/flight_repository.dart';
import 'package:next_trip/features/flights/domain/usecases/search_flights_usecase.dart';
import 'package:next_trip/features/flights/domain/usecases/search_return_flights_usecase.dart';
import 'package:next_trip/features/flights/infrastructure/datasources/flight_remote_datasource.dart';
import 'package:next_trip/features/flights/infrastructure/repositories/flight_repository_impl.dart';

// Hotel imports
import 'package:next_trip/features/hotels/infrastructure/datasources/hotel_remote_datasource.dart';
import 'package:next_trip/features/hotels/application/bloc/hotel_bloc.dart';
import 'package:next_trip/features/hotels/domain/repositories/hotel_repository.dart';
import 'package:next_trip/features/hotels/domain/usecases/get_all_hotels_usecase.dart';
import 'package:next_trip/features/hotels/domain/usecases/get_hotel_by_id_usecase.dart';
import 'package:next_trip/features/hotels/domain/usecases/get_hotels_by_city_stream_usecase.dart';
import 'package:next_trip/features/hotels/domain/usecases/get_hotels_by_city_usecase.dart';
import 'package:next_trip/features/hotels/domain/usecases/get_hotels_stream_usecase.dart';
import 'package:next_trip/features/hotels/domain/usecases/hotel_refresh_usecase.dart';
import 'package:next_trip/features/hotels/infrastructure/repositories/hotel_repository_impl.dart';

// Car imports
import 'package:next_trip/features/cars/application/bloc/car_bloc.dart';
import 'package:next_trip/features/cars/domain/repositories/car_repository.dart';
import 'package:next_trip/features/cars/domain/usecases/get_car_by_id_usecase.dart';
import 'package:next_trip/features/cars/domain/usecases/get_cars_by_city_usecase.dart';
import 'package:next_trip/features/cars/domain/usecases/search_cars_usecase.dart';
import 'package:next_trip/features/cars/infrastructure/datasources/car_remote_datasource.dart';
import 'package:next_trip/features/cars/infrastructure/repositories/car_repository_impl.dart';

// Flight Booking imports
import 'package:next_trip/features/bookings/domain/usecases/flight_booking/create_booking_usecase.dart'
    // ignore: library_prefixes
    as FlightBookingUseCases;
import 'package:next_trip/features/bookings/domain/usecases/flight_booking/create_round_trip_booking_usecase.dart';
import 'package:next_trip/features/bookings/domain/repositories/flight_booking_repository.dart';
import 'package:next_trip/features/bookings/infrastructure/datasources/flight_booking_remote_datasource.dart';
import 'package:next_trip/features/bookings/infrastructure/repositories/flight_booking_repository_impl.dart';
import 'package:next_trip/features/bookings/domain/usecases/flight_booking/cancel_booking_usecase.dart'
    // ignore: library_prefixes
    as FlightBookingUseCases;
import 'package:next_trip/features/bookings/domain/usecases/flight_booking/get_user_bookings_usecase.dart';
import 'package:next_trip/features/bookings/domain/usecases/flight_booking/get_user_round_trip_bookings_usecase.dart';
import 'package:next_trip/features/bookings/application/bloc/flight_booking/flight_booking_bloc.dart';

// Hotel Booking imports
import 'package:next_trip/features/bookings/infrastructure/datasources/hotel_booking_remote_datasource.dart';
import 'package:next_trip/features/bookings/application/bloc/hotel_booking/hotel_booking_bloc.dart';
import 'package:next_trip/features/bookings/domain/repositories/hotel_booking_repository.dart';
import 'package:next_trip/features/bookings/domain/usecases/hotel_booking/get_bookings_by_user_usecase.dart';
import 'package:next_trip/features/bookings/infrastructure/repositories/hotel_booking_repository_impl.dart';
import 'package:next_trip/features/bookings/domain/usecases/hotel_booking/create_booking_usecase.dart'
    // ignore: library_prefixes
    as HotelBookingUseCases;
import 'package:next_trip/features/bookings/domain/usecases/hotel_booking/cancel_booking_usecase.dart'
    // ignore: library_prefixes
    as HotelBookingUseCases;

void setupDependencies() {
  // Firebase instances
  Get.lazyPut<FirebaseAuth>(() => FirebaseAuth.instance);
  Get.lazyPut<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // --- AUTH  ---

  // Data sources
  Get.lazyPut<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: Get.find<FirebaseAuth>(),
      firestore: Get.find<FirebaseFirestore>(),
    ),
  );

  // Repositories
  Get.lazyPut<AuthRepository>(
    () => AuthRepositoryImpl(Get.find<AuthRemoteDataSource>()),
  );

  // Use cases
  Get.lazyPut(() => SignInUseCase(Get.find<AuthRepository>()));
  Get.lazyPut(() => SignOutUseCase(Get.find<AuthRepository>()));
  Get.lazyPut(() => RegisterUseCase(Get.find<AuthRepository>()));
  Get.lazyPut(() => ResetPasswordUseCase(Get.find<AuthRepository>()));
  Get.lazyPut(() => UpdateProfileUseCase(Get.find<AuthRepository>()));
  Get.lazyPut(() => GetCurrentUserUseCase(Get.find<AuthRepository>()));

  // Bloc
  Get.put<AuthBloc>(
    AuthBloc(
      signInUseCase: Get.find<SignInUseCase>(),
      signOutUseCase: Get.find<SignOutUseCase>(),
      registerUseCase: Get.find<RegisterUseCase>(),
      resetPasswordUseCase: Get.find<ResetPasswordUseCase>(),
      updateProfileUseCase: Get.find<UpdateProfileUseCase>(),
      getCurrentUserUseCase: Get.find<GetCurrentUserUseCase>(),
    ),
    permanent: true,
  );

  // --- FLIGHT ---

  // Data sources
  Get.lazyPut<FlightRemoteDataSource>(
    () => FlightRemoteDataSourceImpl(firestore: Get.find<FirebaseFirestore>()),
  );

  // Repositories
  Get.lazyPut<FlightRepository>(
    () => FlightRepositoryImpl(
      remoteDataSource: Get.find<FlightRemoteDataSource>(),
    ),
  );

  // Use cases
  Get.lazyPut(() => SearchFlightsUseCase(Get.find<FlightRepository>()));
  Get.lazyPut(() => SearchReturnFlightsUseCase(Get.find<FlightRepository>()));

  // Bloc
  Get.put<FlightBloc>(
    FlightBloc(
      searchFlightsUseCase: Get.find<SearchFlightsUseCase>(),
      searchReturnFlightsUseCase: Get.find<SearchReturnFlightsUseCase>(),
    ),
    permanent: true,
  );

  // --- FLIGHT BOOKING  ---

  // Data sources
  Get.lazyPut<FlightBookingRemoteDataSource>(
    () =>
        FlightBookingRemoteDataSource(firestore: Get.find<FirebaseFirestore>()),
  );

  // Repositories
  Get.lazyPut<FlightBookingRepository>(
    () => FlightBookingRepositoryImpl(
      remoteDataSource: Get.find<FlightBookingRemoteDataSource>(),
    ),
  );

  // Use cases
  Get.lazyPut(
    () => FlightBookingUseCases.CancelBookingUseCase(
      Get.find<FlightBookingRepository>(),
    ),
    tag: 'flight_cancel',
  );
  Get.lazyPut(
    () => FlightBookingUseCases.CreateBookingUseCase(
      Get.find<FlightBookingRepository>(),
    ),
    tag: 'flight_create',
  );
  Get.lazyPut(
    () => CreateRoundTripBookingUseCase(Get.find<FlightBookingRepository>()),
  );
  Get.lazyPut(
    () => GetUserBookingsUseCase(Get.find<FlightBookingRepository>()),
  );
  Get.lazyPut(
    () => GetUserRoundTripBookingsUseCase(Get.find<FlightBookingRepository>()),
  );

  // Bloc
  Get.put<FlightBookingBloc>(
    FlightBookingBloc(
      getUserRoundTripBookingsUseCase:
          Get.find<GetUserRoundTripBookingsUseCase>(),
      getUserBookingsUseCase: Get.find<GetUserBookingsUseCase>(),
      cancelBookingUsecase: Get.find(tag: 'flight_cancel'),
      createBookingUseCase: Get.find(tag: 'flight_create'),
      createRoundTripBookingUseCase: Get.find<CreateRoundTripBookingUseCase>(),
    ),
    permanent: true,
  );

  // --- HOTELS  ---

  // Data sources
  Get.lazyPut<HotelRemoteDataSource>(
    () => HotelRemoteDataSource(firestore: Get.find<FirebaseFirestore>()),
  );

  // Repositories
  Get.lazyPut<HotelRepository>(
    () => HotelRepositoryImpl(
      remoteDataSource: Get.find<HotelRemoteDataSource>(),
    ),
  );

  // Use cases
  Get.lazyPut(() => GetAllHotelsUsecase(Get.find<HotelRepository>()));
  Get.lazyPut(() => GetHotelByIdUsecase(Get.find<HotelRepository>()));
  Get.lazyPut(() => GetHotelsByCityStreamUsecase(Get.find<HotelRepository>()));
  Get.lazyPut(() => GetHotelsByCityUsecase(Get.find<HotelRepository>()));
  Get.lazyPut(() => GetHotelsStreamUsecase(Get.find<HotelRepository>()));
  Get.lazyPut(() => HotelRefreshUsecase(Get.find<HotelRepository>()));

  // Bloc
  Get.put<HotelBloc>(
    HotelBloc(
      getAllHotelsUsecase: Get.find<GetAllHotelsUsecase>(),
      getHotelByIdUsecase: Get.find<GetHotelByIdUsecase>(),
      getHotelsByCityStreamUsecase: Get.find<GetHotelsByCityStreamUsecase>(),
      getHotelsByCityUsecase: Get.find<GetHotelsByCityUsecase>(),
      getHotelsStreamUsecase: Get.find<GetHotelsStreamUsecase>(),
      hotelRefreshUsecase: Get.find<HotelRefreshUsecase>(),
    ),
    permanent: true,
  );

  // --- HOTEL BOOKING  ---

  // Data sources
  Get.lazyPut<HotelBookingRemoteDataSource>(
    () =>
        HotelBookingRemoteDataSource(firestore: Get.find<FirebaseFirestore>()),
  );

  // Repositories
  Get.lazyPut<HotelBookingRepository>(
    () => HotelBookingRepositoryImpl(
      remoteDataSource: Get.find<HotelBookingRemoteDataSource>(),
    ),
  );

  // Use cases
  Get.lazyPut(
    () => HotelBookingUseCases.CreateBookingUseCase(
      Get.find<HotelBookingRepository>(),
    ),
    tag: 'hotel_create',
  );
  Get.lazyPut(
    () => GetBookingsByUserUseCase(Get.find<HotelBookingRepository>()),
  );
  Get.lazyPut(
    () => HotelBookingUseCases.CancelBookingUseCase(
      Get.find<HotelBookingRepository>(),
    ),
    tag: 'hotel_cancel',
  );

  // Bloc
  Get.put<HotelBookingBloc>(
    HotelBookingBloc(
      createBookingUseCase: Get.find(tag: 'hotel_create'),
      getBookingsByUserUseCase: Get.find<GetBookingsByUserUseCase>(),
      cancelBookingUseCase: Get.find(tag: 'hotel_cancel'),
    ),
    permanent: true,
  );

  // --- CAR ---

  // Data sources
  Get.lazyPut<CarRemoteDataSource>(
    () => CarRemoteDataSource(firestore: Get.find<FirebaseFirestore>()),
  );

  // Repositories
  Get.lazyPut<CarRepository>(
    () => CarRepositoryImpl(remoteDataSource: Get.find<CarRemoteDataSource>()),
  );

  // Use cases
  Get.lazyPut(() => GetCarByIdUseCase(Get.find<CarRepository>()));
  Get.lazyPut(() => GetCarsByCityUseCase(Get.find<CarRepository>()));
  Get.lazyPut(() => SearchCarsUseCase(Get.find<CarRepository>()));

  // Bloc
  Get.put<CarBloc>(
    CarBloc(
      getCarByIdUseCase: Get.find<GetCarByIdUseCase>(),
      getCarsByCityUseCase: Get.find<GetCarsByCityUseCase>(),
      searchCarsUseCase: Get.find<SearchCarsUseCase>(),
    ),
    permanent: true,
  );
}
