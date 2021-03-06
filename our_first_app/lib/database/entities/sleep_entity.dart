import 'package:floor/floor.dart';

@Entity(tableName: 'sleepTable')
class Sleep {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final DateTime date;
  final DateTime entryDateTime;
  final String? level;

  Sleep({required this.id, required this.date, required this.entryDateTime, required this.level});
}