import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:minimal_habit_tracker/models/app_settings.dart';
import 'package:minimal_habit_tracker/models/habit.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  // setup
  // initialize
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([HabitSchema, AppSettingsSchema], directory: dir.path);
  }

  // save first date when first open app
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      settings.calendarMode = true;
      await isar.writeTxn(() => isar.appSettings.put(settings)); // 等价于下方的注释代码
      // await isar.writeTxn(() async {
      //   await isar.appSettings.put(settings);
      // });
    }
  }

  // get first date
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    // if (settings == null) {
    //   saveFirstLaunchDate();
    // }
    return settings?.firstLaunchDate;
  }

  late bool currenCalendarModeIsWeek = true;
  Future<void> switchCalendarMode() async {
    final settings = await isar.appSettings.where().findFirst();
    if (settings != null) {
      settings.calendarMode = !settings.calendarMode;
      currenCalendarModeIsWeek = settings.calendarMode;
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
    readHabits();
  }

  // CRUD x operations
  // - List of habits
  final List<Habit> currenHabits = [];
  //  - Create
  Future<void> addHabit(String habitName) async {
    final newHabit = Habit()..name = habitName;

    await isar.writeTxn(() => isar.habits.put(newHabit));

    readHabits();
  }

  //  - Read
  Future<void> readHabits() async {
    List<Habit> fetchedHabits = await isar.habits.where().findAll();
    currenHabits.clear();
    currenHabits.addAll(fetchedHabits);
    notifyListeners();
  }

  //  - Update
  //// - update complete status
  Future<void> updateHabits(int id, bool isCompleted) async {
    final habit = await loadHabit(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        final today = DateTime.now();
        final todayDateTime = DateTime(today.year, today.month, today.day);
        if (isCompleted && !habit.completedDays.contains(today)) {
          habit.completedDays.add(todayDateTime);
        } else {
          habit.completedDays.removeWhere((date) =>
              date.year == todayDateTime.year &&
              date.month == todayDateTime.month &&
              date.day == todayDateTime.day);
        }
        await isar.habits.put(habit);
      });
    }

    readHabits();
  }

  //// - update name
  Future<void> updateHabitName(int id, String newName) async {
    final habit = await loadHabit(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
    }
    readHabits();
  }

  //  - Delete
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    readHabits();
  }

  Future<Habit?> loadHabit(int id) async {
    return await isar.habits.get(id);
  }

  // void change
}
