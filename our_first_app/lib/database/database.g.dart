// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AccountDao? _accountDaoInstance;

  ActivityDao? _activityDaoInstance;

  ActivityTimeseriesDao? _activityTimeseriesDaoInstance;

  HeartDao? _heartDaoInstance;

  SleepDao? _sleepDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Account` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `age` INTEGER, `dateOfBirth` TEXT, `gender` TEXT, `height` REAL, `weight` REAL, `legalTermsAcceptRequired` INTEGER, `avatar` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Activity` (`date` INTEGER NOT NULL, `type` TEXT, `distance` REAL, `duration` REAL, `startTime` INTEGER NOT NULL, `calories` REAL, PRIMARY KEY (`date`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ActivityTimeseries` (`date` INTEGER NOT NULL, `steps` INTEGER, `floors` INTEGER, `minutesSedentary` INTEGER, `minutesLightly` INTEGER, `minutesFairly` INTEGER, `minutesVery` INTEGER, PRIMARY KEY (`date`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Heart` (`date` INTEGER NOT NULL, `restingHR` INTEGER, `minutesOutOfRange` INTEGER, `minutesFatBurn` INTEGER, `minutesCardio` INTEGER, `minutesPeak` INTEGER, PRIMARY KEY (`date`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Sleep` (`date` INTEGER NOT NULL, `entryDateTime` INTEGER NOT NULL, `level` TEXT, PRIMARY KEY (`date`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AccountDao get accountDao {
    return _accountDaoInstance ??= _$AccountDao(database, changeListener);
  }

  @override
  ActivityDao get activityDao {
    return _activityDaoInstance ??= _$ActivityDao(database, changeListener);
  }

  @override
  ActivityTimeseriesDao get activityTimeseriesDao {
    return _activityTimeseriesDaoInstance ??=
        _$ActivityTimeseriesDao(database, changeListener);
  }

  @override
  HeartDao get heartDao {
    return _heartDaoInstance ??= _$HeartDao(database, changeListener);
  }

  @override
  SleepDao get sleepDao {
    return _sleepDaoInstance ??= _$SleepDao(database, changeListener);
  }
}

class _$AccountDao extends AccountDao {
  _$AccountDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _accountInsertionAdapter = InsertionAdapter(
            database,
            'Account',
            (Account item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'age': item.age,
                  'dateOfBirth': item.dateOfBirth,
                  'gender': item.gender,
                  'height': item.height,
                  'weight': item.weight,
                  'legalTermsAcceptRequired':
                      item.legalTermsAcceptRequired == null
                          ? null
                          : (item.legalTermsAcceptRequired! ? 1 : 0),
                  'avatar': item.avatar
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Account> _accountInsertionAdapter;

  @override
  Future<List<Account>> getAccount() async {
    return _queryAdapter.queryList('SELECT * FROM Account',
        mapper: (Map<String, Object?> row) => Account(
            id: row['id'] as int?,
            name: row['name'] as String?,
            age: row['age'] as int?,
            avatar: row['avatar'] as String?,
            dateOfBirth: row['dateOfBirth'] as String?,
            gender: row['gender'] as String?,
            height: row['height'] as double?,
            legalTermsAcceptRequired: row['legalTermsAcceptRequired'] == null
                ? null
                : (row['legalTermsAcceptRequired'] as int) != 0,
            weight: row['weight'] as double?));
  }

  @override
  Future<void> deleteAccount() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Account');
  }

  @override
  Future<void> insertAccount(Account account) async {
    await _accountInsertionAdapter.insert(account, OnConflictStrategy.abort);
  }
}

class _$ActivityDao extends ActivityDao {
  _$ActivityDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _activityInsertionAdapter = InsertionAdapter(
            database,
            'Activity',
            (Activity item) => <String, Object?>{
                  'date': _dateTimeConverter.encode(item.date),
                  'type': item.type,
                  'distance': item.distance,
                  'duration': item.duration,
                  'startTime': _dateTimeConverter.encode(item.startTime),
                  'calories': item.calories
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Activity> _activityInsertionAdapter;

  @override
  Future<List<Activity>> getActivityDataByDate(DateTime date) async {
    return _queryAdapter.queryList('SELECT * FROM Activity WHERE date = ?1',
        mapper: (Map<String, Object?> row) => Activity(
            date: _dateTimeConverter.decode(row['date'] as int),
            type: row['type'] as String?,
            distance: row['distance'] as double?,
            duration: row['duration'] as double?,
            startTime: _dateTimeConverter.decode(row['startTime'] as int),
            calories: row['calories'] as double?),
        arguments: [_dateTimeConverter.encode(date)]);
  }

  @override
  Future<void> deleteRecentActivityData() async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM ActivityTimeseries WHERE date = (SELECT MAX(date) FROM ActivityTimeseries)');
  }

  @override
  Future<void> deleteAllActivity() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Activity');
  }

  @override
  Future<void> insertActivityData(List<Activity> activityDataList) async {
    await _activityInsertionAdapter.insertList(
        activityDataList, OnConflictStrategy.abort);
  }
}

class _$ActivityTimeseriesDao extends ActivityTimeseriesDao {
  _$ActivityTimeseriesDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _activityTimeseriesInsertionAdapter = InsertionAdapter(
            database,
            'ActivityTimeseries',
            (ActivityTimeseries item) => <String, Object?>{
                  'date': _dateTimeConverter.encode(item.date),
                  'steps': item.steps,
                  'floors': item.floors,
                  'minutesSedentary': item.minutesSedentary,
                  'minutesLightly': item.minutesLightly,
                  'minutesFairly': item.minutesFairly,
                  'minutesVery': item.minutesVery
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ActivityTimeseries>
      _activityTimeseriesInsertionAdapter;

  @override
  Future<ActivityTimeseries?> getActivityTimeseriesByDate(DateTime date) async {
    return _queryAdapter.query(
        'SELECT * FROM ActivityTimeseries WHERE date = ?1',
        mapper: (Map<String, Object?> row) => ActivityTimeseries(
            date: _dateTimeConverter.decode(row['date'] as int),
            steps: row['steps'] as int?,
            floors: row['floors'] as int?,
            minutesSedentary: row['minutesSedentary'] as int?,
            minutesLightly: row['minutesLightly'] as int?,
            minutesFairly: row['minutesFairly'] as int?,
            minutesVery: row['minutesVery'] as int?),
        arguments: [_dateTimeConverter.encode(date)]);
  }

  @override
  Future<void> deleteRecentActivityTimeseries() async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM ActivityTimeseries WHERE date = (SELECT MAX(date) FROM ActivityTimeseries)');
  }

  @override
  Future<void> deleteAllActivityTimeseries() async {
    await _queryAdapter.queryNoReturn('DELETE FROM ActivityTimeseries');
  }

  @override
  Future<void> insertActivityTimeseries(
      List<ActivityTimeseries> activityTimeseriesList) async {
    await _activityTimeseriesInsertionAdapter.insertList(
        activityTimeseriesList, OnConflictStrategy.abort);
  }
}

class _$HeartDao extends HeartDao {
  _$HeartDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _heartInsertionAdapter = InsertionAdapter(
            database,
            'Heart',
            (Heart item) => <String, Object?>{
                  'date': _dateTimeConverter.encode(item.date),
                  'restingHR': item.restingHR,
                  'minutesOutOfRange': item.minutesOutOfRange,
                  'minutesFatBurn': item.minutesFatBurn,
                  'minutesCardio': item.minutesCardio,
                  'minutesPeak': item.minutesPeak
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Heart> _heartInsertionAdapter;

  @override
  Future<Heart?> getHeartDataByDate(DateTime date) async {
    return _queryAdapter.query('SELECT * FROM Heart WHERE date = ?1',
        mapper: (Map<String, Object?> row) => Heart(
            date: _dateTimeConverter.decode(row['date'] as int),
            restingHR: row['restingHR'] as int?,
            minutesOutOfRange: row['minutesOutOfRange'] as int?,
            minutesFatBurn: row['minutesFatBurn'] as int?,
            minutesCardio: row['minutesCardio'] as int?,
            minutesPeak: row['minutesPeak'] as int?),
        arguments: [_dateTimeConverter.encode(date)]);
  }

  @override
  Future<DateTime?> getRecentHeartDate() async {
    await _queryAdapter.queryNoReturn('SELECT MAX(date) FROM Heart');
  }

  @override
  Future<void> deleteRecentHeartData() async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM Heart WHERE date = (SELECT MAX(date) FROM Heart)');
  }

  @override
  Future<void> deleteAllHeartData() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Heart');
  }

  @override
  Future<void> insertHeartData(List<Heart> heartDataList) async {
    await _heartInsertionAdapter.insertList(
        heartDataList, OnConflictStrategy.abort);
  }
}

class _$SleepDao extends SleepDao {
  _$SleepDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _sleepInsertionAdapter = InsertionAdapter(
            database,
            'Sleep',
            (Sleep item) => <String, Object?>{
                  'date': _dateTimeConverter.encode(item.date),
                  'entryDateTime':
                      _dateTimeConverter.encode(item.entryDateTime),
                  'level': item.level
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Sleep> _sleepInsertionAdapter;

  @override
  Future<List<Sleep>> getSleepDataByDate(DateTime date) async {
    return _queryAdapter.queryList('SELECT * FROM Sleep WHERE date = ?1',
        mapper: (Map<String, Object?> row) => Sleep(
            date: _dateTimeConverter.decode(row['date'] as int),
            entryDateTime:
                _dateTimeConverter.decode(row['entryDateTime'] as int),
            level: row['level'] as String?),
        arguments: [_dateTimeConverter.encode(date)]);
  }

  @override
  Future<void> deleteAllSleepData() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Sleep');
  }

  @override
  Future<void> insertSleepData(List<Sleep> sleepDataList) async {
    await _sleepInsertionAdapter.insertList(
        sleepDataList, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
