import 'package:floor/floor.dart';

@Entity(primaryKeys: ['date'])
class ActivityTimeseries {
  @PrimaryKey()
  final DateTime date;

  final int? steps;
  final int? floors;
  final int? minutesSedentary;
  final int? minutesLightly;
  final int? minutesFairly;
  final int? minutesVery;

  ActivityTimeseries({required this.date, required this.steps, required this.floors, required this.minutesSedentary, required this.minutesLightly, required this.minutesFairly, required this.minutesVery});
}