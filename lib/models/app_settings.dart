import 'package:isar/isar.dart';
part 'app_settings.g.dart';

@collection
class AppSettings {
  Id id = Isar.autoIncrement;
  DateTime? firstLaunchDate;

  @enumerated
  late bool calendarMode;
}

// enum CalendarModeEnum {
//   day(1),
//   week(2),
//   month(3);

//   const CalendarModeEnum(this.myValue);

//   final short myValue;
// }
