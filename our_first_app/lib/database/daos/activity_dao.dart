import 'package:floor/floor.dart';
import 'package:our_first_app/database/entities/activity_entity.dart';

@dao
abstract class ActivityDao {
  @Query('SELECT * FROM Activity WHERE date = :date')
  Future<List<Activity>> getActivityDataByDate(DateTime date);

  @insert
  Future<void> insertActivityData(List<Activity> activityDataList);

  // no update, but delete and then insert
  @Query('DELETE FROM Activity WHERE date = :date')
  Future<void> deleteActivityByDate(DateTime date);

  @Query('DELETE FROM Activity')
  Future<void> deleteAllActivity();
}