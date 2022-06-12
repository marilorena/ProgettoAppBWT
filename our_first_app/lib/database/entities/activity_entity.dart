import 'package:floor/floor.dart';

@Entity(primaryKeys: ['date'])
class Activity {
  @PrimaryKey()
  final DateTime? date;

  final String? type;
  final double? distance;
  final double? duration;
  final DateTime? startTime;
  final double? calories;

  Activity({required this.date, required this.type, required this.distance, required this.duration, required this.startTime, required this.calories});
}