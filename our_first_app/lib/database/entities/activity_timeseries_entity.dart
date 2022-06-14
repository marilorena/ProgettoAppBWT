import 'package:floor/floor.dart';

@Entity(primaryKeys: ['date'])
class ActivityTimeseries {
  @PrimaryKey()
  final DateTime date;

  final double? steps;
  final double? floors;
  final double? minutesSedentary;
  final double? minutesLightly;
  final double? minutesFairly;
  final double? minutesVery;

  ActivityTimeseries({required this.date, required this.steps, required this.floors, required this.minutesSedentary, required this.minutesLightly, required this.minutesFairly, required this.minutesVery});
}