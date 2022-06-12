import 'package:floor/floor.dart';

@Entity(primaryKeys: ['date'])
class Sleep {
  @PrimaryKey()
  final DateTime? date;

  final DateTime? entryDateTime;
  final String? level;

  Sleep({required this.date, required this.entryDateTime, required this.level});
}