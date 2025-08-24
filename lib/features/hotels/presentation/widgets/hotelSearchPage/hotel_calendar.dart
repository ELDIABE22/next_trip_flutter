import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HotelCalendar extends StatefulWidget {
  const HotelCalendar({super.key});

  @override
  State<HotelCalendar> createState() => _HotelCalendarState();
}

class _HotelCalendarState extends State<HotelCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      calendarFormat: CalendarFormat.month,
      availableCalendarFormats: const {CalendarFormat.month: 'Mes'},
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      calendarStyle: CalendarStyle(
        rangeHighlightColor: Colors.blue.shade100,
        rangeStartDecoration: BoxDecoration(
          color: Colors.blue.shade700,
          shape: BoxShape.circle,
        ),
        rangeEndDecoration: BoxDecoration(
          color: Colors.blue.shade700,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.grey.shade700,
          shape: BoxShape.circle,
        ),
        defaultTextStyle: TextStyle(color: Colors.black),
        weekendTextStyle: TextStyle(color: Colors.grey.shade600),
      ),
      onRangeSelected: (start, end, focusedDay) {
        setState(() {
          _rangeStart = start;
          _rangeEnd = end;
          _focusedDay = focusedDay;
        });
      },
      selectedDayPredicate: (day) => day == _rangeStart || day == _rangeEnd,
      rangeSelectionMode: RangeSelectionMode.enforced,
    );
  }
}
