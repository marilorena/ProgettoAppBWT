import 'package:floor/floor.dart';
import 'package:our_first_app/database/entities/heart_entity.dart';

@dao
abstract class HeartDao {
  @Query('SELECT * FROM HeartData WHERE date = :date')
  Future<Heart?> getHeartDataByDate(DateTime date);

  @insert
  Future<void> insertHeartData(List<Heart> heartDataList);

  @update
  Future<void> updateHeartData(Heart heartDataList);

  @Query('DELETE FROM Heart')
  Future<void> deleteAllHeartData();
}