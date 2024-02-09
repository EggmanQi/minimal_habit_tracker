import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:provider/provider.dart';

import '../database/habit_database.dart';

class MyHeatMap extends StatelessWidget {
  final DateTime startDate;
  final Map<DateTime, int> datesets;
  const MyHeatMap(
      {super.key, required this.startDate, required this.datesets, required this.colorsets});
  final Map<int, Color> colorsets;

  @override
  Widget build(BuildContext context) {
    final habitDatabase = context.watch<HabitDatabase>();
    bool currenCalendarModeIsWeek = habitDatabase.currenCalendarModeIsWeek;
    if (currenCalendarModeIsWeek) {
      return HeatMap(
          startDate: startDate,
          endDate: DateTime.now(),
          colorMode: ColorMode.color,
          defaultColor: Theme.of(context).colorScheme.secondary,
          textColor: Colors.white,
          size: 30,
          showText: true,
          scrollable: true,
          datasets: datesets,
          colorsets: colorsets);
    } else {
      return HeatMapCalendar(
          flexible: true,
          colorMode: ColorMode.color,
          defaultColor: Theme.of(context).colorScheme.secondary,
          textColor: Colors.white,
          size: 30,
          datasets: datesets,
          colorsets: colorsets);
    }
  }
}
