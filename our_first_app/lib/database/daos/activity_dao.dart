import 'package:floor/floor.dart';
import 'package:our_first_app/database/entities/activity_entity.dart';

@dao
abstract class ActivityDao {
  @Query('SELECT * FROM activityTable WHERE date = :date')
  Future<List<Activity>> getActivityDataByDate(DateTime date);

  @insert
  Future<void> insertActivityData(List<Activity> activityDataList);

  // delete the most recent data
  // also to update today's data
  @Query('DELETE FROM activityTable WHERE date = (SELECT MAX(date) FROM activityTable)')
  Future<void> deleteRecentActivityData();

  @Query('DELETE FROM activityTable')
  Future<void> deleteAllActivity();
}