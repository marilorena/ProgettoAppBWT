import 'package:floor/floor.dart';

@Entity(primaryKeys: ['id'])
class Activity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final DateTime date;
  final String? type;
  final double? distance;
  final double? duration;
  final DateTime startTime;
  final double? calories;

  Activity({required this.id, required this.date, required this.type, required this.distance, required this.duration, required this.startTime, required this.calories});
}