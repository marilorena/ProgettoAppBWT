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
            'CREATE TABLE IF NOT EXISTS `accountTable` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `dateOfBirth` TEXT, `gender` TEXT, `height` REAL, `weight` REAL, `legalTermsAcceptRequired` INTEGER, `avatar` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `activityTable` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` INTEGER NOT NULL, `type` TEXT, `distance` REAL, `duration` REAL, `startTime` INTEGER NOT NULL, `calories` REAL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `activityTimeseriesTable` (`date` INTEGER NOT NULL, `steps` REAL, `floors` REAL, `minutesSedentary` REAL, `minutesLightly` REAL, `minutesFairly` REAL, `minutesVery` REAL, PRIMARY KEY (`date`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `heartTable` (`date` INTEGER NOT NULL, `restingHR` INTEGER, `minimumOutOfRange` INTEGER, `minutesOutOfRange` INTEGER, `minimumFatBurn` INTEGER, `minutesFatBurn` INTEGER, `minimumCardio` INTEGER, `minutesCardio` INTEGER, `minimumPeak` INTEGER, `minutesPeak` INTEGER, PRIMARY KEY (`date`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `sleepTable` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` INTEGER NOT NULL, `entryDateTime` INTEGER NOT NULL, `level` TEXT)');

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
            'accountTable',
            (Account item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
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
    return _queryAdapter.queryList('SELECT * FROM accountTable',
        mapper: (Map<String, Object?> row) => Account(
            id: row['id'] as int?,
            name: row['name'] as String?,
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
    await _queryAdapter.queryNoReturn('DELETE FROM accountTable');
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
            'activityTable',
            (Activity item) => <String, Object?>{
                  'id': item.id,
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
    return _queryAdapter.queryList(
        'SELECT * FROM activityTable WHERE date = ?1',
        mapper: (Map<String, Object?> row) => Activity(
            id: row['id'] as int?,
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
        'DELETE FROM activityTable WHERE date = (SELECT MAX(date) FROM activityTable)');
  }

  @override
  Future<void> deleteAllActivity() async {
    await _queryAdapter.queryNoReturn('DELETE FROM activityTable');
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
            'activityTimeseriesTable',
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
        'SELECT * FROM activityTimeseriesTable WHERE date = ?1',
        mapper: (Map<String, Object?> row) => ActivityTimeseries(
            date: _dateTimeConverter.decode(row['date'] as int),
            steps: row['steps'] as double?,
            floors: row['floors'] as double?,
            minutesSedentary: row['minutesSedentary'] as double?,
            minutesLightly: row['minutesLightly'] as double?,
            minutesFairly: row['minutesFairly'] as double?,
            minutesVery: row['minutesVery'] as double?),
        arguments: [_dateTimeConverter.encode(date)]);
  }

  @override
  Future<void> deleteRecentActivityTimeseries() async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM activityTimeseriesTable WHERE date = (SELECT MAX(date) FROM activityTimeseriesTable)');
  }

  @override
  Future<void> deleteAllActivityTimeseries() async {
    await _queryAdapter.queryNoReturn('DELETE FROM activityTimeseriesTable');
  }

  @override
  Future<void> insertActivityTimeseries(
      List<ActivityTimeseries> activityTimeseriesList) async {
    await _activityTimeseriesInsertionAdapter.insertList(
        activityTimeseriesList, OnConflictStrategy.abort);
  }

  @override
  Future<List<double>> getSteps() {
    return _queryAdapter.queryList('SELECT steps FROM activityTimeseriesTable',
      mapper: (Map<String, Object?> row) => row['steps'] as double
    );
  }
}

class _$HeartDao extends HeartDao {
  _$HeartDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _heartInsertionAdapter = InsertionAdapter(
            database,
            'heartTable',
            (Heart item) => <String, Object?>{
                  'date': _dateTimeConverter.encode(item.date),
                  'restingHR': item.restingHR,
                  'minimumOutOfRange': item.minimumOutOfRange,
                  'minutesOutOfRange': item.minutesOutOfRange,
                  'minimumFatBurn': item.minimumFatBurn,
                  'minutesFatBurn': item.minutesFatBurn,
                  'minimumCardio': item.minimumCardio,
                  'minutesCardio': item.minutesCardio,
                  'minimumPeak': item.minimumPeak,
                  'minutesPeak': item.minutesPeak
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Heart> _heartInsertionAdapter;

  @override
  Future<Heart?> getHeartDataByDate(DateTime date) async {
    return _queryAdapter.query('SELECT * FROM heartTable WHERE date = ?1',
        mapper: (Map<String, Object?> row) => Heart(
            date: _dateTimeConverter.decode(row['date'] as int),
            restingHR: row['restingHR'] as int?,
            minimumOutOfRange: row['minimumOutOfRange'] as int?,
            minutesOutOfRange: row['minutesOutOfRange'] as int?,
            minimumFatBurn: row['minimumFatBurn'] as int?,
            minutesFatBurn: row['minutesFatBurn'] as int?,
            minimumCardio: row['minimumCardio'] as int?,
            minutesCardio: row['minutesCardio'] as int?,
            minimumPeak: row['minimumPeak'] as int?,
            minutesPeak: row['minutesPeak'] as int?),
        arguments: [_dateTimeConverter.encode(date)]);
  }

  @override
  Future<DateTime?> getRecentHeartDate() async {
    return await _queryAdapter.query('SELECT MAX(date) FROM heartTable',
      mapper: (Map<String, Object?> row){
        return row['date'] == null ? DateTime.fromMillisecondsSinceEpoch(0) : _dateTimeConverter.decode(row['date'] as int);
      }
    );
  }

  @override
  Future<void> deleteRecentHeartData() async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM heartTable WHERE date = (SELECT MAX(date) FROM heartTable)');
  }

  @override
  Future<void> deleteAllHeartData() async {
    await _queryAdapter.queryNoReturn('DELETE FROM heartTable');
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
            'sleepTable',
            (Sleep item) => <String, Object?>{
                  'id': item.id,
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
    return _queryAdapter.queryList('SELECT * FROM sleepTable WHERE date = ?1',
        mapper: (Map<String, Object?> row) => Sleep(
            id: row['id'] as int?,
            date: _dateTimeConverter.decode(row['date'] as int),
            entryDateTime:
                _dateTimeConverter.decode(row['entryDateTime'] as int),
            level: row['level'] as String?),
        arguments: [_dateTimeConverter.encode(date)]);
  }

  @override
  Future<void> deleteAllSleepData() async {
    await _queryAdapter.queryNoReturn('DELETE FROM sleepTable');
  }

  @override
  Future<void> insertSleepData(List<Sleep> sleepDataList) async {
    await _sleepInsertionAdapter.insertList(
        sleepDataList, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
