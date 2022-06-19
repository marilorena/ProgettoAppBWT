import 'dart:async';
import 'package:floor/floor.dart';
import 'package:our_first_app/database/type_converter/datetime_converter.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'daos/account_dao.dart';
import 'daos/activity_dao.dart';
import 'daos/activity_timeseries_dao.dart';
import 'daos/heart_dao.dart';
import 'daos/sleep_dao.dart';
import 'entities/account_entity.dart';
import 'entities/activity_entity.dart';
import 'entities/activity_timeseries_entity.dart';
import 'entities/heart_entity.dart';
import 'entities/sleep_entity.dart';

part 'database.g.dart';

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [Account, Activity, ActivityTimeseries, Heart, Sleep])
abstract class AppDatabase extends FloorDatabase {
  AccountDao get accountDao;
  ActivityDao get activityDao;
  ActivityTimeseriesDao get activityTimeseriesDao;
  HeartDao get heartDao;
  SleepDao get sleepDao;
}
