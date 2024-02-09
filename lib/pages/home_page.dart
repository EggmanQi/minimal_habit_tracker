import 'package:flutter/material.dart';
import 'package:minimal_habit_tracker/components/my_drawer.dart';
import 'package:minimal_habit_tracker/components/my_habit_tile.dart';
import 'package:minimal_habit_tracker/components/my_heat_map.dart';
import 'package:minimal_habit_tracker/database/habit_database.dart';
import 'package:minimal_habit_tracker/models/habit.dart';
import 'package:minimal_habit_tracker/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();

  Widget _buildHeadmap() {
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currenHabits;

    return FutureBuilder<DateTime?>(
        future: habitDatabase.getFirstLaunchDate(),
        builder: (context, shapshot) {
          // when fitst launch date is ready, build heat map
          if (shapshot.hasData) {
            return MyHeatMap(
              startDate: shapshot.data!,
              datesets: prepHeatmapDataset(currentHabits),
              colorsets: prepHearmapColorset(),
            );
          } else {
            return Container();
          }
        });
  }

  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currenHabits;
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: currentHabits.length,
        itemBuilder: (context, index) {
          final habit = currentHabits[index];
          bool isCompletedToday = isHabitCompletedToday(habit.completedDays);
          return MyHabitTile(
            text: habit.name,
            isCompleted: isCompletedToday,
            onChanged: (value) => checkHabitOnOff(value, habit),
            editHabit: (p0) => editHabit(habit),
            deleteHabit: (p0) => deleteHabit(habit),
          );
        });
  }

  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
                decoration: const InputDecoration(hintText: "Create a new habit"),
              ),
              actions: [
                // Save
                MaterialButton(
                  onPressed: () {
                    String newHabitName = textController.text;
                    context.read<HabitDatabase>().addHabit(newHabitName);
                    cleanContext();
                  },
                  child: const Text("Save"),
                ),
                //Cancel
                MaterialButton(
                  onPressed: () {
                    cleanContext();
                  },
                  child: const Text("Cancel"),
                ),
              ],
            ));
  }

  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      setState(() {
        context.read<HabitDatabase>().updateHabits(habit.id, value);
      });
    }
    // final today = DateTime.now();
  }

  void cleanContext() {
    Navigator.pop(context);
    textController.clear();
  }

  void deleteHabit(Habit habit) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delete it"),
              actions: [
                // Save
                MaterialButton(
                  onPressed: () {
                    context.read<HabitDatabase>().deleteHabit(habit.id);
                    cleanContext();
                  },
                  child: const Text("Confirm"),
                ),
                //Cancel
                MaterialButton(
                  onPressed: () {
                    cleanContext();
                  },
                  child: const Text("Cancel"),
                ),
              ],
            ));
  }

  void editHabit(Habit habit) {
    textController.text = habit.name;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
              ),
              actions: [
                // Save
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      String newHabitName = textController.text;
                      context.read<HabitDatabase>().updateHabitName(habit.id, newHabitName);
                      cleanContext();
                    });
                  },
                  child: const Text("Save"),
                ),
                //Cancel
                MaterialButton(
                  onPressed: () {
                    cleanContext();
                  },
                  child: const Text("Cancel"),
                ),
              ],
            ));
  }

  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ListView(children: [_buildHeadmap(), _buildHabitList()]),
      ),
    );
  }
}
