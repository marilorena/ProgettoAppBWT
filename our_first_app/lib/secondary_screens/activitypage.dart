import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:our_first_app/database/entities/activity_entity.dart';
import 'package:our_first_app/database/entities/activity_timeseries_entity.dart';
import 'package:our_first_app/database/repository/database_repository.dart';
import 'package:our_first_app/model/targets.dart';
import 'package:our_first_app/utils/client_credentials.dart';
import 'package:our_first_app/utils/queries_counter.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_lane_chart/simple_lane_chart.dart';

class ActivityPage extends StatefulWidget{
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  DateTime? dateOfMonitoring;
  double? steps;
  double? floors;
  
  @override
  Widget build(BuildContext context){
    int subtractedDays = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Activity'),
        actions: _showActions(context, subtractedDays)
      ),
      body: Center(
        child: FutureBuilder(
          future: _fetchSteps(context, subtractedDays),
          builder: (context, snapshot){
            if(snapshot.hasData){
              final stepsData = snapshot.data as List<FitbitActivityTimeseriesData>;
              return ListView(
                children: [
                  const SizedBox(height: 20),
                  _showHeader(context, subtractedDays, stepsData[0].dateOfMonitoring),
                  const SizedBox(height: 20),
                  _showStepsAndFloors(context, subtractedDays, stepsData),
                  const SizedBox(height: 20),
                  _showMinutes(context, subtractedDays),
                  const SizedBox(height: 40),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Activities of the day:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      _showActivity(context, subtractedDays),
                    ],
                  )
                ]
              );
            } else {
              return FutureBuilder(
                future: _isTokenValid(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    final isTokenValid = snapshot.data as bool;
                    if(!isTokenValid){
                      return _showIfNotAuthorized(context);
                    } else if(QueriesCounter.getInstance().getStopQueries()){
                      return const Text('Limit rate of requests exceeded...', style: TextStyle(fontSize: 16));
                    } else {
                      return const CircularProgressIndicator();
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                }
              );
            }
          }
        )
      )
    );
  }

  // fetch methods
  Future<List<FitbitActivityTimeseriesData>?> _fetchSteps(BuildContext context, int subtracted) async {
    DateTime date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+subtracted);
    final activityFromDB = await Provider.of<DatabaseRepository>(context, listen: false).getActivityTimeseriesByDate(date);
    if(activityFromDB != null){
      return [FitbitActivityTimeseriesData(dateOfMonitoring: activityFromDB.date, value: activityFromDB.steps)];
    } else {
      final FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManagerSteps = FitbitActivityTimeseriesDataManager(
        clientID: Credentials.getCredentials().id,
        clientSecret: Credentials.getCredentials().secret,
        type: 'steps'
      );
      final sp = await SharedPreferences.getInstance();
      final userID = sp.getString('userID');
      final now = DateTime.now();
      bool stopQueries = await QueriesCounter.getInstance().check();
      if(stopQueries){
        return null;
      } else {
        final isTokenValid = await FitbitConnector.isTokenValid();
        if(!isTokenValid){
          return null;
        }
        stopQueries = await QueriesCounter.getInstance().check();
        if(stopQueries){
          return null;
        } else {
          final fetchedData = await fitbitActivityTimeseriesDataManagerSteps.fetch(
            FitbitActivityTimeseriesAPIURL.dayWithResource(
              date: DateTime.utc(now.year, now.month, now.day+subtracted),
              userID: userID,
              resource: fitbitActivityTimeseriesDataManagerSteps.type
            )
          ) as List<FitbitActivityTimeseriesData>;
          if(fetchedData.isNotEmpty){
            dateOfMonitoring = fetchedData[0].dateOfMonitoring;
            steps = fetchedData[0].value;
          }
          return fetchedData;
        }
      }
    }
  }

  Future<List<FitbitActivityTimeseriesData>?> _fetchFloors(BuildContext context, int subtracted) async {
    DateTime date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+subtracted);
    final activityFromDB = await Provider.of<DatabaseRepository>(context, listen: false).getActivityTimeseriesByDate(date);
    if(activityFromDB != null){
      return [FitbitActivityTimeseriesData(value: activityFromDB.floors)];
    }
    final FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManagerFloors = FitbitActivityTimeseriesDataManager(
      clientID: Credentials.getCredentials().id,
      clientSecret: Credentials.getCredentials().secret,
      type: 'floors'
    );
    final sp = await SharedPreferences.getInstance();
    final userID = sp.getString('userID');
    final now = DateTime.now();
    bool stopQueries = await QueriesCounter.getInstance().check();
    if(stopQueries){
      return null;
    } else {
      final fetchedData = await fitbitActivityTimeseriesDataManagerFloors.fetch(
        FitbitActivityTimeseriesAPIURL.dayWithResource(
          date: DateTime.utc(now.year, now.month, now.day+subtracted),
          userID: userID,
          resource: fitbitActivityTimeseriesDataManagerFloors.type
        )
      ) as List<FitbitActivityTimeseriesData>;
      if(fetchedData.isNotEmpty){
        floors = fetchedData[0].value;
      }
      return fetchedData;
    }
  }

  Future<List<FitbitActivityData>?> _fetchActivity(BuildContext context, int subtracted) async {
    if(subtracted==0){
      // delete most recent data
      await Provider.of<DatabaseRepository>(context, listen: false).deleteRecentActivityData();
      await Provider.of<DatabaseRepository>(context, listen: false).deleteRecentActivityTimeseries();
    }

    DateTime date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+subtracted);
    final activityFromDB = await Provider.of<DatabaseRepository>(context, listen: false).getActivityDataByDate(date);
    if(activityFromDB.isNotEmpty){
      List<FitbitActivityData> activityData = [];
      for(var item in activityFromDB){
        activityData.add(FitbitActivityData(
          calories: item.calories,
          distance: item.distance,
          duration: item.duration,
          name: item.type,
          startTime: item.startTime
        ));
      }
      return activityData;
    } else {
      final FitbitActivityDataManager fitbitActivityDataManager = FitbitActivityDataManager(
        clientID: Credentials.getCredentials().id,
        clientSecret: Credentials.getCredentials().secret
      );
      final sp = await SharedPreferences.getInstance();
      final userID = sp.getString('userID');
      final now = DateTime.now();
      bool stopQueries = await QueriesCounter.getInstance().check();
      if(stopQueries){
        return null;
      } else {
        final fetchedData = await fitbitActivityDataManager.fetch(
          FitbitActivityAPIURL.day(
            date: DateTime.utc(now.year, now.month, now.day+subtracted),
            userID: userID
          )
        ) as List<FitbitActivityData>;
        if(fetchedData.isNotEmpty){
          await Provider.of<DatabaseRepository>(context, listen: false).insertActivityData([Activity(
            id: null,
            date: fetchedData[0].dateOfMonitoring!,
            type: fetchedData[0].name,
            distance: fetchedData[0].distance,
            duration: fetchedData[0].duration,
            startTime: fetchedData[0].startTime!,
            calories: fetchedData[0].calories
          )]);
        }
        return fetchedData;
      }
    }
  }

  Future<Map<String, double>?> _fetchMinutes(BuildContext context, int subtracted) async{
    DateTime date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+subtracted);
    final activityFromDB = await Provider.of<DatabaseRepository>(context, listen: false).getActivityTimeseriesByDate(date);
    if(activityFromDB != null){
      return {
        'Minutes sedentary: ${(activityFromDB.minutesSedentary?? 0).toInt()}' : activityFromDB.minutesSedentary?? 0,
        'Minutes lightly active: ${(activityFromDB.minutesLightly?? 0).toInt()}' : activityFromDB.minutesLightly?? 0,
        'Minutes fairly active: ${(activityFromDB.minutesFairly?? 0).toInt()}' : activityFromDB.minutesFairly?? 0,
        'Minutes very active: ${(activityFromDB.minutesVery?? 0).toInt()}' : activityFromDB.minutesVery?? 0
      };
    }
    final sp = await SharedPreferences.getInstance();
    final userID = sp.getString('userID');
    final now = DateTime.now();
    
    // sedentary
    final FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManagerSedentary = FitbitActivityTimeseriesDataManager(
      clientID: Credentials.getCredentials().id,
      clientSecret: Credentials.getCredentials().secret,
      type: 'minutesSedentary'
    );
    bool stopQueries = await QueriesCounter.getInstance().check();
    List<FitbitActivityTimeseriesData> sedentary;
    if(stopQueries){
      return null;
    } else {
      sedentary = await fitbitActivityTimeseriesDataManagerSedentary.fetch(
        FitbitActivityTimeseriesAPIURL.dayWithResource(
          date: DateTime.utc(now.year, now.month, now.day+subtracted),
          userID: userID,
          resource: fitbitActivityTimeseriesDataManagerSedentary.type
        )
      ) as List<FitbitActivityTimeseriesData>;
    }

    // lightly active
    final FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManagerLightly = FitbitActivityTimeseriesDataManager(
      clientID: Credentials.getCredentials().id,
      clientSecret: Credentials.getCredentials().secret,
      type: 'minutesLightlyActive'
    );
    stopQueries = await QueriesCounter.getInstance().check();
    List<FitbitActivityTimeseriesData> lightly;
    if(stopQueries){
      return null;
    } else {
      lightly = await fitbitActivityTimeseriesDataManagerLightly.fetch(
        FitbitActivityTimeseriesAPIURL.dayWithResource(
          date: DateTime.utc(now.year, now.month, now.day+subtracted),
          userID: userID,
          resource: fitbitActivityTimeseriesDataManagerLightly.type
        )
      ) as List<FitbitActivityTimeseriesData>;
    }

    // fairly active
    final FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManagerFairly = FitbitActivityTimeseriesDataManager(
      clientID: Credentials.getCredentials().id,
      clientSecret: Credentials.getCredentials().secret,
      type: 'minutesFairlyActive'
    );
    stopQueries = await QueriesCounter.getInstance().check();
    List<FitbitActivityTimeseriesData> fairly;
    if(stopQueries){
      return null;
    } else {
      fairly = await fitbitActivityTimeseriesDataManagerFairly.fetch(
        FitbitActivityTimeseriesAPIURL.dayWithResource(
          date: DateTime.utc(now.year, now.month, now.day+subtracted),
          userID: userID,
          resource: fitbitActivityTimeseriesDataManagerFairly.type
        )
      ) as List<FitbitActivityTimeseriesData>;
    }

    // very
    final FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManagerVery = FitbitActivityTimeseriesDataManager(
      clientID: Credentials.getCredentials().id,
      clientSecret: Credentials.getCredentials().secret,
      type: 'minutesVeryActive'
    );
    stopQueries = await QueriesCounter.getInstance().check();
    List<FitbitActivityTimeseriesData> very;
    if(stopQueries){
      return null;
    } else {
      very = await fitbitActivityTimeseriesDataManagerVery.fetch(
        FitbitActivityTimeseriesAPIURL.dayWithResource(
          date: DateTime.utc(now.year, now.month, now.day+subtracted),
          userID: userID,
          resource: fitbitActivityTimeseriesDataManagerVery.type
        )
      ) as List<FitbitActivityTimeseriesData>;
    }

    double minSedentary = sedentary.isEmpty || sedentary[0].value == null ? 0 : sedentary[0].value!;
    double minLightly = lightly.isEmpty || lightly[0].value == null ? 0 : lightly[0].value!;
    double minFairly = fairly.isEmpty || fairly[0].value == null ? 0 : fairly[0].value!;
    double minVery = very.isEmpty || very[0].value == null ? 0 : very[0].value!;

    if(dateOfMonitoring != null){
      await Provider.of<DatabaseRepository>(context, listen: false).insertActivityTimeseries([ActivityTimeseries(
        date: dateOfMonitoring!,
        steps: steps,
        floors: floors,
        minutesSedentary: minSedentary,
        minutesLightly: minLightly,
        minutesFairly: minFairly,
        minutesVery: minVery
      )]);
    }

    return {
      'Minutes sedentary: ${minSedentary.toInt()}' : minSedentary,
      'Minutes lightly active: ${minLightly.toInt()}' : minLightly,
      'Minutes fairly active: ${minFairly.toInt()}' : minFairly,
      'Minutes very active: ${minVery.toInt()}' : minVery
    };
  }

  // utils
  String _toDate(DateTime? date){
    return date != null
    ? DateFormat('EEE, dd/MM/y').format(date)
    : '--/--/----';
  }

  String _toTime(DateTime date){
    return DateFormat.Hm().format(date);
  }

  String _intToTime(double? value){
    if(value == null){
      return '0 h 0 m';
    } else {
      final valueToMinutes = value~/1000~/60;
      int h = valueToMinutes ~/ 60;
      int m = valueToMinutes - (h * 60);
      return '$h h $m m';
    }
  }

  void _navigate(BuildContext context, int subtractedDays){
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => const ActivityPage(),
        transitionDuration: Duration.zero, // in this way there is no page animation
        settings: RouteSettings(arguments: subtractedDays)
      )
    );
  }

  Future<bool> _isTokenValid() async{
    final stopQueries = await QueriesCounter.getInstance().check();
    if(stopQueries){
      return true;
    } else {
      return await FitbitConnector.isTokenValid();
    }
  }

  // UI blocks
  List<Widget> _showActions(BuildContext context, int subtractedDays){
    return [
      Visibility(
        visible: subtractedDays == 0 ? true : false,
        child: IconButton(
          icon: const Icon(Icons.update),
          onPressed: () async{
            await Future.delayed(const Duration(seconds: 8));
            _navigate(context, 0);
          }
        ),
      ),
      IconButton(
        onPressed: () async{
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100)
          );
          if(pickedDate != null){
            final now = DateTime.now();
            final int difference = (DateTime.utc(now.year, now.month, now.day).millisecondsSinceEpoch - pickedDate.millisecondsSinceEpoch)~/1000~/60~/60~/24;
            if(difference>=0){
              await Future.delayed(const Duration(seconds: 8));
              _navigate(context, -difference);
            }
          }
        },
        icon: const Icon(Icons.calendar_month)
      ),
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: (){
          Navigator.pushNamed(context, '/activitysettings/');
        }
      )
    ];
  }

  Widget _showHeader(BuildContext context, int subtractedDays, DateTime? date){
    final String time;
    if(date == null){
      time = '';
    } else {
      time = subtractedDays == 0
      ? '00:00 - ${_toTime(DateTime.now())}'
      : '00:00 - 23:59';
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async{
                await Future.delayed(const Duration(seconds: 8));
                _navigate(context, subtractedDays-1);
              },
              icon: const Icon(Icons.arrow_back_ios)
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width*0.7,
              child: Column(
                children: [
                  Text(
                    _toDate(date),
                    style: const TextStyle(fontSize: 16),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 2),
                      Text(
                        time,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              )
            ),
            Visibility(
              visible: subtractedDays == 0 ? false : true,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: IconButton(
                onPressed: () async{
                  await Future.delayed(const Duration(seconds: 8));
                  _navigate(context, subtractedDays+1);
                },
                icon: const Icon(Icons.arrow_forward_ios)
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildLaneChart(bool isSteps, List<FitbitActivityTimeseriesData> data){
    return Consumer<Targets>(
      builder: (context, targets, child) => FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            int? total;
            if(isSteps){
              total = targets.steps.toInt();
            } else {
              total = targets.floors.toInt();
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
              child: Column(
                children: [
                  Text(isSteps ? 'Steps' : 'Floors', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  SimpleLaneChart(
                    data[0].value == null ? 0 : data[0].value!.toInt(),
                    total,
                    calFrom100Perc: true,
                    bgColor: Colors.green.withOpacity(0.3),
                    gradientForChart: const LinearGradient(colors: [Colors.green, Color.fromARGB(255, 157, 225, 159)]),
                    height: 20
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        }
      ),
    );
  }

  Widget _showStepsAndFloors(BuildContext context, int subtractedDays, List<FitbitActivityTimeseriesData> stepsData){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLaneChart(true, stepsData),
        FutureBuilder(
          future: _fetchFloors(context, subtractedDays),
          builder: (context, snapshot){
            if(snapshot.hasData){
              final floorsData = snapshot.data as List<FitbitActivityTimeseriesData>;
              return _buildLaneChart(false, floorsData);
            } else {
              return Container();
            }
          }
        ),
        const SizedBox(height: 20)
      ]
    );
  }

  Widget _showMinutes(BuildContext context, int subtractedDays){
    return FutureBuilder(
      future: _fetchMinutes(context, subtractedDays),
      builder: (context, snapshot){
        if(snapshot.hasData){
          final dataMap = snapshot.data as Map<String, double>;
          return PieChart(
            dataMap: dataMap,
            chartType: ChartType.ring,
            chartRadius: 150,
            legendOptions: const LegendOptions(
              legendPosition: LegendPosition.bottom,
              legendTextStyle: TextStyle(fontSize: 14)
            ),
            chartLegendSpacing: 20,
            colorList: const [Colors.blue, Colors.green, Colors.yellow, Colors.red],
            chartValuesOptions: const ChartValuesOptions(showChartValuesInPercentage: true)
          );
        } else {
          return Container();
        }
      }
    );
  }

  Widget _showActivity(BuildContext context, int subtractedDays){
    return FutureBuilder(
      future: _fetchActivity(context, subtractedDays),
      builder: (context, snapshot){
        if(snapshot.hasData){
          final activityData = snapshot.data as List<FitbitActivityData>;
          return Container(
            alignment: Alignment.center,
            height: 200,
            child: activityData.isEmpty
            ? const Text('none', style: TextStyle(fontSize: 14))
            : ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(10),
              cacheExtent: 0,
              itemCount: activityData.length,
              itemBuilder: (context, index){
                final dynamic distance;
                if(activityData[index].distance == null){
                  distance = '---';
                } else {
                  distance = (activityData[index].distance!*100).toInt()/100;
                }
                final dynamic duration;
                if(activityData[index].distance == null){
                  duration = '---';
                } else {
                  duration = _intToTime(activityData[index].duration);
                }
                final dynamic startTime = activityData[index].startTime == null ? '--:--' : _toTime(activityData[index].startTime!);
                final dynamic calories;
                if(activityData[index].calories == null){
                  calories = '---';
                } else {
                  calories = activityData[index].calories!.toInt();
                }

                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(1,1))]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(activityData[index].name?? '---', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text('distance: $distance km', style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 5),
                      Text('duration: $duration', style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 5),
                      Text('start time: $startTime', style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 5),
                      Text('calories: $calories kcal', style: const TextStyle(fontSize: 14))
                    ]
                  ),
                );
              }
            ),
          );
        } else {
          return Container();
        }
      }
    );
  }

  Widget _showIfNotAuthorized(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('To get data, please authorize', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        ElevatedButton(
          onPressed: () async{
            final credentials = Credentials.getCredentials();
            String? userID = await FitbitConnector.authorize(
              context: context,
              clientID: credentials.id,
              clientSecret: credentials.secret,
              redirectUri: 'example://fitbit/auth',
              callbackUrlScheme: 'example'
            );
            final sp = await SharedPreferences.getInstance();
            if(userID != null){
              sp.setString('userID', userID);
            }
            _navigate(context, 0);
          },
          child: const Text('Authorize'),
        )
      ],
    );
  }
}