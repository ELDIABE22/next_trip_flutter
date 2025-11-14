import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_trip/core/utils/helpers.dart';
import 'package:next_trip/core/widgets/custom_button.dart';
import 'package:next_trip/core/widgets/page_layout.dart';
import 'package:next_trip/features/bookings/application/bloc/flight_booking/flight_booking_bloc.dart';
import 'package:next_trip/features/bookings/application/bloc/flight_booking/flight_booking_event.dart';
import 'package:next_trip/features/bookings/application/bloc/flight_booking/flight_booking_state.dart';
import 'package:next_trip/features/bookings/application/bloc/hotel_booking/hotel_booking_bloc.dart';
import 'package:next_trip/features/bookings/application/bloc/hotel_booking/hotel_booking_event.dart';
import 'package:next_trip/features/bookings/application/bloc/hotel_booking/hotel_booking_state.dart';
import 'package:next_trip/features/bookings/data/controllers/car_booking_controller.dart';
import 'package:next_trip/features/bookings/data/models/car_booking_model.dart';
import 'package:next_trip/features/bookings/infrastructure/models/flight_booking_model.dart';
import 'package:next_trip/features/bookings/infrastructure/models/hotel_booking_model.dart';
import 'package:next_trip/features/bookings/presentation/widgets/booking_tabs.dart';
import 'package:next_trip/features/bookings/presentation/widgets/flight_booking_card.dart';
import 'package:next_trip/features/bookings/presentation/widgets/hotel_booking_card.dart';
import 'package:next_trip/features/bookings/presentation/widgets/car_booking_card.dart';
import 'package:next_trip/routes/app_routes.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  int selectedIndex = 3;
  int selectedTabIndex = 0;

  final currentUser = FirebaseAuth.instance.currentUser;

  final CarBookingController _carBookingController = CarBookingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (currentUser == null && mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      } else {
        final userId = currentUser!.uid;
        context.read<FlightBookingBloc>().add(GetUserBookingsRequested(userId));
        context.read<HotelBookingBloc>().add(
          GetBookingsByUserRequested(userId),
        );
        await _loadCarBookings(userId);
      }
    });
  }

  Future<void> _loadCarBookings(String userId) async {
    try {
      await _carBookingController.loadUserBookings(userId);
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error loading car bookings: $e');
    }
  }

  @override
  void dispose() {
    _carBookingController.dispose();
    super.dispose();
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void onTabChanged(int index) {
    setState(() {
      selectedTabIndex = index;
    });

    if (currentUser?.uid != null) {
      final userId = currentUser!.uid;

      switch (index) {
        case 0:
          context.read<FlightBookingBloc>().add(
            GetUserBookingsRequested(userId),
          );
          break;
        case 1:
          context.read<HotelBookingBloc>().add(
            GetBookingsByUserRequested(userId),
          );
          break;
        case 2:
          _loadCarBookings(userId);
          break;
      }
    }
  }

  Widget content() {
    switch (selectedTabIndex) {
      case 0:
        return flightBookings();
      case 1:
        return hotelBookings();
      case 2:
        return carBookings();
      default:
        return flightBookings();
    }
  }

  Map<String, List<HotelBookingModel>> _groupHotelBookingsByDate(
    List<HotelBookingModel> bookings,
  ) {
    final grouped = <String, List<HotelBookingModel>>{};
    final dateMap = <String, DateTime>{};

    for (var booking in bookings) {
      final dateTime = booking.checkInDate;
      final dateKey = formatDateFullMonth(dateTime);

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
        dateMap[dateKey] = dateTime;
      }
      grouped[dateKey]!.add(booking);
    }

    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => dateMap[b]!.compareTo(dateMap[a]!));

    return Map.fromEntries(
      sortedKeys.map((key) => MapEntry(key, grouped[key]!)),
    );
  }

  Map<String, List<CarBooking>> _groupCarBookingsByDate(
    List<CarBooking> bookings,
  ) {
    final grouped = <String, List<CarBooking>>{};
    final dateMap = <String, DateTime>{};

    for (var booking in bookings) {
      final dateTime = booking.pickupDate;
      final dateKey = formatDateFullMonth(dateTime);

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
        dateMap[dateKey] = dateTime;
      }
      grouped[dateKey]!.add(booking);
    }

    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => dateMap[b]!.compareTo(dateMap[a]!));

    return Map.fromEntries(
      sortedKeys.map((key) => MapEntry(key, grouped[key]!)),
    );
  }

  Map<String, List<FlightBookingModel>> _groupBookingsByDate(
    List<FlightBookingModel> bookings,
  ) {
    final grouped = <String, List<FlightBookingModel>>{};
    final dateMap = <String, DateTime>{};

    for (var booking in bookings) {
      final dateTime = booking.flight.departureDateTime;
      final dateKey = formatDateFullMonth(dateTime);

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
        dateMap[dateKey] = dateTime;
      }
      grouped[dateKey]!.add(booking);
    }

    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => dateMap[b]!.compareTo(dateMap[a]!));

    return Map.fromEntries(
      sortedKeys.map((key) => MapEntry(key, grouped[key]!)),
    );
  }

  Widget flightBookings() {
    return BlocBuilder<FlightBookingBloc, FlightBookingState>(
      builder: (context, state) {
        if (state is FlightBookingLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Cargando tus reservas de vuelos...'),
              ],
            ),
          );
        } else if (state is FlightBookingError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  state.error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  onPressed: () async {
                    if (currentUser?.uid != null) {
                      context.read<FlightBookingBloc>().add(
                        GetUserBookingsRequested(currentUser!.uid),
                      );
                    }
                  },
                  text: 'Reintentar',
                ),
              ],
            ),
          );
        } else if (state is UserBookingsLoaded) {
          if (state.bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.flight_outlined,
                    size: 64,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No tienes reservas de vuelos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Cuando hagas una reserva, aparecerá aquí.',
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: 'Explorar Vuelos',
                  ),
                ],
              ),
            );
          } else {
            final groupedBookings = _groupBookingsByDate(state.bookings);
            return RefreshIndicator(
              onRefresh: () async {
                if (currentUser?.uid != null) {
                  context.read<FlightBookingBloc>().add(
                    GetUserBookingsRequested(currentUser!.uid),
                  );
                }
              },
              child: Column(
                children: groupedBookings.entries.map((entry) {
                  final date = entry.key;
                  final bookings = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 218, 218, 218),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black,
                              ),
                              child: Text(
                                date.split(' ')[0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${date.split(' ')[1]} ${date.split(' ')[2]}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${bookings.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      ...bookings.map((booking) {
                        return FlightBookingCard(booking: booking);
                      }),

                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget hotelBookings() {
    return BlocBuilder<HotelBookingBloc, HotelBookingState>(
      builder: (context, state) {
        if (state is HotelBookingLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Cargando reservas de hoteles...'),
              ],
            ),
          );
        } else if (state is HotelBookingError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Error al cargar las reservas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  onPressed: () {
                    if (currentUser?.uid != null) {
                      context.read<HotelBookingBloc>().add(
                        GetBookingsByUserRequested(currentUser!.uid),
                      );
                    }
                  },
                  text: 'Reintentar',
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        } else if (state is HotelBookingsLoaded) {
          if (state.bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.hotel_outlined,
                    size: 64,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No tienes reservas de hoteles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Cuando hagas una reserva, aparecerá aquí.',
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: 'Explorar Hoteles',
                  ),
                ],
              ),
            );
          }

          final groupedBookings = _groupHotelBookingsByDate(state.bookings);

          return RefreshIndicator(
            onRefresh: () async {
              if (currentUser?.uid != null) {
                context.read<HotelBookingBloc>().add(
                  GetBookingsByUserRequested(currentUser!.uid),
                );
              }
            },
            child: Column(
              children: groupedBookings.entries.map((entry) {
                final date = entry.key;
                final bookings = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 218, 218, 218),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.black,
                            ),
                            child: Text(
                              date.split(' ')[0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${date.split(' ')[1]} ${date.split(' ')[2]}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    ...bookings.map((booking) {
                      return HotelBookingCard(
                        booking: booking,
                        onBookingChanged: () {
                          if (currentUser?.uid != null) {
                            context.read<HotelBookingBloc>().add(
                              GetBookingsByUserRequested(currentUser!.uid),
                            );
                          }
                        },
                      );
                    }),

                    const SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget carBookings() {
    // Estado de carga
    if (_carBookingController.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando reservas de carros...'),
          ],
        ),
      );
    }

    // Estado de error
    if (_carBookingController.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Error al cargar las reservas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _carBookingController.errorMessage ?? 'Error desconocido',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CustomButton(
              onPressed: () async {
                if (currentUser?.uid != null) {
                  await _loadCarBookings(currentUser!.uid);
                }
              },
              text: 'Reintentar',
            ),
          ],
        ),
      );
    }

    // Estado vacío
    if (_carBookingController.userBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.directions_car_outlined,
              size: 64,
              color: Colors.black,
            ),
            const SizedBox(height: 16),
            const Text(
              'No tienes reservas de carros',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cuando hagas una reserva, aparecerá aquí.',
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: 'Explorar Carros',
            ),
          ],
        ),
      );
    }

    final groupedBookings = _groupCarBookingsByDate(
      _carBookingController.userBookings,
    );

    return RefreshIndicator(
      onRefresh: () async {
        if (currentUser?.uid != null) {
          await _loadCarBookings(currentUser!.uid);
        }
      },
      child: Column(
        children: groupedBookings.entries.map((entry) {
          final date = entry.key;
          final bookings = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado de fecha
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 218, 218, 218),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black,
                      ),
                      child: Text(
                        date.split(' ')[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${date.split(' ')[1]} ${date.split(' ')[2]}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              ...bookings.map((booking) {
                return CarBookingCard(booking: booking);
              }),

              const SizedBox(height: 10),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      titleHeader: 'MIS RESERVAS',
      title:
          'Revive tus experiencias: encuentra todas tus reservas en un solo lugar.',
      selectedIndex: selectedIndex,
      onItemTapped: onItemTapped,
      children: [
        BookingTabs(
          selectedTabIndex: selectedTabIndex,
          onTabChanged: onTabChanged,
        ),
        const SizedBox(height: 20),
        content(),
      ],
    );
  }
}
