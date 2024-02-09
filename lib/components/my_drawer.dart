import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimal_habit_tracker/database/habit_database.dart';
import 'package:minimal_habit_tracker/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            const Spacer(),
            Row(children: [
              const Text('Change Display Mode'),
              CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context).isDarkMode,
                  onChanged: (value) =>
                      Provider.of<ThemeProvider>(context, listen: false).toggleTheme()),
            ]),
            Row(
              children: [
                const Text('Change Calendar Mode'),
                CupertinoSwitch(
                    value: Provider.of<HabitDatabase>(context).currenCalendarModeIsWeek,
                    onChanged: (value) =>
                        Provider.of<HabitDatabase>(context, listen: false).switchCalendarMode()),
              ],
            ),
            const Spacer()
          ],
        ));
  }
}
