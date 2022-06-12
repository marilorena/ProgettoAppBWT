import 'package:floor/floor.dart';

@Entity(primaryKeys: ['date'])
class Heart {
  @PrimaryKey()
  final DateTime? date;

  final int? restingHR;
  final int? minutesOutOfRange;
  final int? minutesFatBurn;
  final int? minutesCardio;
  final int? minutesPeak;

  Heart({required this.date, required this.restingHR, required this.minutesOutOfRange, required this.minutesFatBurn, required this.minutesCardio, required this.minutesPeak});
}