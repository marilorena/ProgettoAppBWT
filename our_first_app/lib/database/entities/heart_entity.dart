import 'package:floor/floor.dart';

@Entity(primaryKeys: ['date'], tableName: 'heartTable')
class Heart {
  final DateTime date;
  final int? restingHR;
  final int? minimumOutOfRange;
  final int? minutesOutOfRange;
  final int? minimumFatBurn;
  final int? minutesFatBurn;
  final int? minimumCardio;
  final int? minutesCardio;
  final int? minimumPeak;
  final int? minutesPeak;

  Heart({required this.date, required this.restingHR, required this.minimumOutOfRange, required this.minutesOutOfRange, required this.minimumFatBurn, required this.minutesFatBurn, required this.minimumCardio, required this.minutesCardio, required this.minimumPeak, required this.minutesPeak});
}