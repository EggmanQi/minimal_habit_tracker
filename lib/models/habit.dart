import 'package:isar/isar.dart';
part 'habit.g.dart';

// 等价 @Collection(), 为这个类添加“注解”，id 会自动绑定到 collection 中的对象
@collection
class Habit {
  Id id = Isar.autoIncrement;
  late String name;
  List<DateTime> completedDays = [
    // y/m/d
  ];
}
