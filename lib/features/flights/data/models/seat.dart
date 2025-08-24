enum SeatStatus { available, selected, unavailable }

class Seat {
  final String id;
  SeatStatus status;

  Seat({required this.id, required this.status});
}
