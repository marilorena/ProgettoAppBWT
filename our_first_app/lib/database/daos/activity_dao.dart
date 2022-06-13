import 'package:floor/floor.dart';
import 'package:our_first_app/database/entities/activity_entity.dart';

@dao
abstract class ActivityDao {
  @Query('SELECT * FROM Activity WHERE date = :date')
  Future<List<Activity>> getActivityDataByDate(DateTime date);

  @insert
  Future<void> insertActivityData(List<Activity> activityDataList);

  // delete the most recent data
  // also to update today's data
  @Query('DELETE FROM ActivityTimeseries WHERE date = (SELECT MAX(date) FROM ActivityTimeseries)')
  Future<void> deleteRecentActivityData();

  @Query('DELETE FROM Activity')
  Future<void> deleteAllActivity();
}