import 'package:floor/floor.dart';
import 'package:our_first_app/database/entities/activity_timeseries_entity.dart';

@dao
abstract class ActivityTimeseriesDao {
  @Query('SELECT * FROM activityTimeseriesTable WHERE date = :date')
  Future<ActivityTimeseries?> getActivityTimeseriesByDate(DateTime date);

  @insert
  Future<void> insertActivityTimeseries(List<ActivityTimeseries> activityTimeseriesList);

  // delete the most recent data
  // also to update today's data
  @Query('DELETE FROM activityTimeseriesTable WHERE date = (SELECT MAX(date) FROM activityTimeseriesTable)')
  Future<void> deleteRecentActivityTimeseries();

  @Query('DELETE FROM activityTimeseriesTable')
  Future<void> deleteAllActivityTimeseries();
}