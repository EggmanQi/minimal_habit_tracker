import 'package:flutter/material.dart';
import 'package:minimal_habit_tracker/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays
      .any((date) => date.year == today.year && date.month == today.month && date.day == today.day);
}

Map<DateTime, int> prepHeatmapDataset(List<Habit> habits) {
  Map<DateTime, int> dateset = {};
  for (var habit in habits) {
    for (var date in habit.completedDays) {
      final keyDateTime = DateTime(date.year, date.month, date.day);
      if (dateset.containsKey(keyDateTime)) {
        dateset[keyDateTime] = dateset[keyDateTime]! + 1;
      } else {
        dateset[keyDateTime] = 1;
      }
    }
  }
  return dateset;
}

Map<int, Color> prepHearmapColorset() {
  return {
    1: Colors.red,
    3: Colors.orange,
    5: Colors.yellow,
    7: Colors.green,
    9: Colors.blue,
    11: Colors.indigo,
    13: Colors.purple,
  };
}
