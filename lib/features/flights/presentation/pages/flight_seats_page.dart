import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/appbar.dart';
import 'package:next_trip/features/flights/data/models/seat_model.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSearchPage/flight_card.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSeatsPage/confirm_button.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSeatsPage/seat_grid.dart';
import 'package:next_trip/features/flights/presentation/widgets/flightSeatsPage/seat_legends.dart';
import 'package:next_trip/features/flights/data/models/flight_model.dart';
import 'package:intl/intl.dart';

class FlightSeatsPage extends StatefulWidget {
  final Flight flight;
  final Flight? returnFlight;
  final bool isRoundTrip;

  const FlightSeatsPage({
    super.key,
    required this.flight,
    this.returnFlight,
    this.isRoundTrip = false,
  });

  @override
  State<FlightSeatsPage> createState() => _FlightSeatsPageState();
}

class _FlightSeatsPageState extends State<FlightSeatsPage>
    with SingleTickerProviderStateMixin {
  List<Seat> selectedOutboundSeats = [];
  List<Seat> selectedReturnSeats = [];
  late TabController _tabController;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    if (widget.isRoundTrip) {
      _tabController = TabController(length: 2, vsync: this);
      _tabController.addListener(() {
        setState(() {
          _currentTab = _tabController.index;
        });
      });
    }
  }

  @override
  void dispose() {
    if (widget.isRoundTrip) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: widget.isRoundTrip
            ? "Selecciona asientos (Ida y Vuelta)"
            : "Selecciona tu asiento",
      ),
      body: Container(
        decoration: AppConstantsColors.radialBackground,
        child: Stack(
          children: [
            if (widget.isRoundTrip)
              _buildRoundTripView()
            else
              _buildOneWayView(),

            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildOneWayView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          FlightCard(
            total: widget.flight.totalPriceLabelCop,
            flightDate: DateFormat(
              'dd/MM/yyyy',
            ).format(widget.flight.departureDateTime),
            departureTime: widget.flight.departureTimeStr,
            arrivalTime: widget.flight.arrivalTimeStr,
            originIata: widget.flight.originIata,
            destinationIata: widget.flight.destinationIata,
            durationLabel: widget.flight.durationLabel,
            isDirect: widget.flight.isDirect,
            navigateToSeatsOnTap: false,
            flight: widget.flight,
          ),
          const SizedBox(height: 10),
          SeatLegends(),
          const SizedBox(height: 20),
          SeatGrid(
            flightId: widget.flight.id,
            onSelectionChanged: (seats) {
              setState(() {
                selectedOutboundSeats = seats;
              });
            },
          ),
          const SizedBox(height: 90),
        ],
      ),
    );
  }

  Widget _buildRoundTripView() {
    return Column(
      children: [
        // Tabs para ida y vuelta
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.flight_takeoff),
                    const SizedBox(width: 8),
                    const Text('Ida'),
                    if (selectedOutboundSeats.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${selectedOutboundSeats.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.flight_land),
                    const SizedBox(width: 8),
                    const Text('Regreso'),
                    if (selectedReturnSeats.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${selectedReturnSeats.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            labelColor: _currentTab == 0 ? Colors.blue : Colors.orange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: _currentTab == 0 ? Colors.blue : Colors.orange,
          ),
        ),

        // Contenido de cada tab
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [_buildOutboundTab(), _buildReturnTab()],
          ),
        ),
        SizedBox(height: 90),
      ],
    );
  }

  Widget _buildOutboundTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          FlightCard(
            total: widget.flight.totalPriceLabelCop,
            flightDate: DateFormat(
              'dd/MM/yyyy',
            ).format(widget.flight.departureDateTime),
            departureTime: widget.flight.departureTimeStr,
            arrivalTime: widget.flight.arrivalTimeStr,
            originIata: widget.flight.originIata,
            destinationIata: widget.flight.destinationIata,
            durationLabel: widget.flight.durationLabel,
            isDirect: widget.flight.isDirect,
            navigateToSeatsOnTap: false,
            flight: widget.flight,
          ),
          const SizedBox(height: 10),
          SeatLegends(),
          const SizedBox(height: 20),
          SeatGrid(
            flightId: widget.flight.id,
            onSelectionChanged: (seats) {
              setState(() {
                selectedOutboundSeats = seats;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReturnTab() {
    if (widget.returnFlight == null) {
      return const Center(
        child: Text('No se ha seleccionado vuelo de regreso'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          FlightCard(
            total: widget.returnFlight!.totalPriceLabelCop,
            flightDate: DateFormat(
              'dd/MM/yyyy',
            ).format(widget.returnFlight!.departureDateTime),
            departureTime: widget.returnFlight!.departureTimeStr,
            arrivalTime: widget.returnFlight!.arrivalTimeStr,
            originIata: widget.returnFlight!.originIata,
            destinationIata: widget.returnFlight!.destinationIata,
            durationLabel: widget.returnFlight!.durationLabel,
            isDirect: widget.returnFlight!.isDirect,
            navigateToSeatsOnTap: false,
            flight: widget.returnFlight!,
          ),
          const SizedBox(height: 10),
          SeatLegends(),
          const SizedBox(height: 20),
          SeatGrid(
            flightId: widget.returnFlight!.id,
            onSelectionChanged: (seats) {
              setState(() {
                selectedReturnSeats = seats;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    if (widget.isRoundTrip) {
      return ConfirmButton(
        selectedSeats: _currentTab == 0
            ? selectedOutboundSeats
            : selectedReturnSeats,
        flight: _currentTab == 0 ? widget.flight : widget.returnFlight!,
        isRoundTrip: true,
        outboundSeats: selectedOutboundSeats,
        returnSeats: selectedReturnSeats,
        outboundFlight: widget.flight,
        returnFlight: widget.returnFlight,
      );
    } else {
      return ConfirmButton(
        selectedSeats: selectedOutboundSeats,
        flight: widget.flight,
      );
    }
  }
}
