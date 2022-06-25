import 'package:flutter/cupertino.dart';
import 'package:our_first_app/database/database.dart';
import 'package:our_first_app/database/entities/account_entity.dart';
import 'package:our_first_app/database/entities/activity_entity.dart';
import 'package:our_first_app/database/entities/activity_timeseries_entity.dart';
import 'package:our_first_app/database/entities/heart_entity.dart';
import 'package:our_first_app/database/entities/sleep_entity.dart';

class DatabaseRepository extends ChangeNotifier{
  final AppDatabase database;

  DatabaseRepository({required this.database});

  // account
  Future<List<Account>> getAccount() async{
    return await database.accountDao.getAccount();
  }

  Future<void> insertAccount(Account account) async{
    await database.accountDao.insertAccount(account);
    notifyListeners();
  }

  Future<void> deleteAccount() async{
    await database.accountDao.deleteAccount();
    notifyListeners();
  }

  // activity
  Future<List<Activity>> getActivityDataByDate(DateTime date) async{
    return await database.activityDao.getActivityDataByDate(date);
  }

  Future<void> insertActivityData(List<Activity> activityDataList) async{
    await database.activityDao.insertActivityData(activityDataList);
    notifyListeners();
  }

  Future<void> deleteRecentActivityData() async{
    await database.activityDao.deleteRecentActivityData();
    notifyListeners();
  }

  Future<void> deleteAllActivity() async{
    await database.activityDao.deleteAllActivity();
    notifyListeners();
  }

  // activity timeseries
  Future<ActivityTimeseries?> getActivityTimeseriesByDate(DateTime date) async{
    return await database.activityTimeseriesDao.getActivityTimeseriesByDate(date);
  }

  Future<List<double>> getSteps() async{
    return await database.activityTimeseriesDao.getSteps();
  }

  Future<void> insertActivityTimeseries(List<ActivityTimeseries> activityTimeseriesList) async{
    await database.activityTimeseriesDao.insertActivityTimeseries(activityTimeseriesList);
    notifyListeners();
  }

  Future<void> deleteRecentActivityTimeseries() async{
    await database.activityTimeseriesDao.deleteRecentActivityTimeseries();
    notifyListeners();
  }

  Future<void> deleteAllActivityTimeseries() async{
    await database.activityTimeseriesDao.deleteAllActivityTimeseries();
    notifyListeners();
  }

  // heart
  Future<Heart?> getHeartDataByDate(DateTime date) async{
    return await database.heartDao.getHeartDataByDate(date);
  }

  Future<DateTime?> getRecentHeartDate() async{
    return await database.heartDao.getRecentHeartDate();
  }

  Future<void> insertHeartData(List<Heart> heartDataList) async{
    await database.heartDao.insertHeartData(heartDataList);
    notifyListeners();
  }

  Future<void> deleteRecentHeartData() async{
    await database.heartDao.deleteRecentHeartData();
    notifyListeners();
  }

  Future<void> deleteAllHeartData() async{
    await database.heartDao.deleteAllHeartData();
    notifyListeners();
  }

  // sleep
  Future<List<Sleep>> getSleepDataByDate(DateTime date) async{
    return await database.sleepDao.getSleepDataByDate(date);
  }

  Future<void> insertSleepData(List<Sleep> sleepDataList) async{
    await database.sleepDao.insertSleepData(sleepDataList);
    notifyListeners();
  }

  Future<void> deleteAllSleepData() async{
    await database.sleepDao.deleteAllSleepData();
    notifyListeners();
  }
}