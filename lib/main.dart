import 'package:flutter/material.dart';
import 'package:minimal_habit_tracker/database/habit_database.dart';
import 'package:minimal_habit_tracker/pages/home_page.dart';
import 'package:minimal_habit_tracker/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();
  await HabitDatabase().getFirstLaunchDate();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => HabitDatabase()),
    ChangeNotifierProvider(create: (context) => ThemeProvider())
  ], child: const MainApp()));

  // ChangeNotifierProvider(create: (context) => ThemeProvider(), child: const MainApp())
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeDate,
    );
  }
}
