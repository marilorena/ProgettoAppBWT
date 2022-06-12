import 'package:floor/floor.dart';
import 'package:our_first_app/database/entities/sleep_entity.dart';

@dao
abstract class SleepDao {
  @Query('SELECT * FROM Sleep WHERE date = :date')
  Future<List<Sleep>> getSleepDataByDate(DateTime date);

  @insert
  Future<void> insertSleepData(List<Sleep> sleepDataList);

  // no update method

  @Query('DELETE FROM Sleep')
  Future<void> deleteAllSleepData();  
}