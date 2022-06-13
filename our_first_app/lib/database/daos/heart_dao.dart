import 'package:floor/floor.dart';
import 'package:our_first_app/database/entities/heart_entity.dart';

@dao
abstract class HeartDao {
  @Query('SELECT * FROM Heart WHERE date = :date')
  Future<Heart?> getHeartDataByDate(DateTime date);

  @Query('SELECT MAX(date) FROM Heart')
  Future<DateTime?> getRecentHeartDate();

  @insert
  Future<void> insertHeartData(List<Heart> heartDataList);

  // delete the most recent data
  // to do when DateTime.now() > getRecentHeartDate()
  @Query('DELETE FROM Heart WHERE date = (SELECT MAX(date) FROM Heart)')
  Future<void> deleteRecentHeartData();

  @Query('DELETE FROM Heart')
  Future<void> deleteAllHeartData();
}