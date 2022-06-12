import 'package:floor/floor.dart';

@Entity(primaryKeys: ['date'])
class HeartData {
  @PrimaryKey()
  final DateTime? date;

  final int? restingHR;
  final int? minutesOutOfRange;
  final int? minutesFatBurn;
  final int? minutesCardio;
  final int? minutesPeak;

  HeartData({required this.date, required this.restingHR, required this.minutesOutOfRange, required this.minutesFatBurn, required this.minutesCardio, required this.minutesPeak});
}