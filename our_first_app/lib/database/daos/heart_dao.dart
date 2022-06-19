import 'package:floor/floor.dart';
import 'package:our_first_app/database/entities/heart_entity.dart';

@dao
abstract class HeartDao {
  @Query('SELECT * FROM heartTable WHERE date = :date')
  Future<Heart?> getHeartDataByDate(DateTime date);

  @Query('SELECT MAX(date) FROM heartTable')
  Future<DateTime?> getRecentHeartDate();

  @insert
  Future<void> insertHeartData(List<Heart> heartDataList);

  // delete the most recent data
  // to do when DateTime.now() > getRecentHeartDate()
  @Query('DELETE FROM heartTable WHERE date = (SELECT MAX(date) FROM heartTable)')
  Future<void> deleteRecentHeartData();

  @Query('DELETE FROM heartTable')
  Future<void> deleteAllHeartData();
}