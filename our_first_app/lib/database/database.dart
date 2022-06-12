import 'dart:async';
import 'package:floor/floor.dart';
import 'package:our_first_app/database/type_converter/datetime_converter.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'daos/account_dao.dart';
import 'entities/account_entity.dart';

part 'database.g.dart';

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [Account])
abstract class AppDatabase extends FloorDatabase {
  AccountDao get accountDao;
}
