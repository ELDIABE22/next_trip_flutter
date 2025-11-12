import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:next_trip/core/dependency_injection.dart';
import 'package:next_trip/features/auth/application/bloc/auth_bloc.dart';
import 'package:next_trip/features/bookings/application/bloc/flight_booking_bloc.dart';
import 'package:next_trip/features/flights/application/bloc/flight_bloc.dart';
import 'package:next_trip/features/hotels/application/bloc/hotel_bloc.dart';
import 'package:next_trip/routes/app_pages.dart';
import 'package:next_trip/routes/app_routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setupDependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => Get.find<AuthBloc>()),
        BlocProvider<FlightBloc>(create: (_) => Get.find<FlightBloc>()),
        BlocProvider<FlightBookingBloc>(
          create: (_) => Get.find<FlightBookingBloc>(),
        ),
        BlocProvider<HotelBloc>(create: (_) => Get.find<HotelBloc>()),
      ],
      child: MaterialApp(
        title: 'NexTrip',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.promptTextTheme(),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.home,
        onGenerateRoute: AppPages.onGenerateRoute,
      ),
    );
  }
}
