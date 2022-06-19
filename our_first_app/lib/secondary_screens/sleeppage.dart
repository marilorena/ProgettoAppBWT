import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:our_first_app/database/repository/database_repository.dart';
import 'package:our_first_app/utils/client_credentials.dart';
import 'package:our_first_app/utils/queries_counter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class SleepPage extends StatelessWidget{
  const SleepPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    int subtractedDays = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sleep'),
        actions: _showActions(context, subtractedDays)
      ),
      body: Center(
        child: _showSleep(context, subtractedDays)
      )
    );
  }

  // fetch method
  Future<List<FitbitSleepData>?> _fetchSleep(BuildContext context, int subtracted) async {
    DateTime date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+subtracted);
    final sleepFromDB = await Provider.of<DatabaseRepository>(context, listen: false).getSleepDataByDate(date);
    print(sleepFromDB);
    if(sleepFromDB.isNotEmpty){
      sleepFromDB.sort((a,b) => a.entryDateTime.compareTo(b.entryDateTime)); // sort by ascending entryDateTime
      List<FitbitSleepData> sleepData = [];
      for(var item in sleepFromDB){
        sleepData.add(FitbitSleepData(entryDateTime: item.entryDateTime));
      }
      return sleepData;
    } else {
      final FitbitSleepDataManager fitbitSleepDataManager = FitbitSleepDataManager(
        clientID: Credentials.getCredentials().id,
        clientSecret: Credentials.getCredentials().secret,
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
        return stopQueries
        ? null
        : await fitbitSleepDataManager.fetch(
          FitbitSleepAPIURL.withUserIDAndDay(
            date: DateTime.utc(now.year, now.month, now.day+subtracted),
            userID: userID,
          )
        ) as List<FitbitSleepData>; 
      }
    }
  }

  // utils
  String _toDateAndTime(DateTime? date){
    return date != null
    ? '${DateFormat('EEE, dd/MM/y').format(date)}, ${DateFormat.Hm().format(date)}'
    : '--/--/----, --:--';
  }

  String _getSleepDuration(DateTime? startDate, DateTime? endDate){
    if(startDate == null || endDate == null){
      return '---';
    } else {
      final duration = (endDate.millisecondsSinceEpoch - startDate.millisecondsSinceEpoch)~/1000~/60;
      int h = duration ~/ 60;
      int m = duration - (h * 60);
      return h == 0 ? '$m m' : '$h h $m m';
    }
  }

  void _navigate(BuildContext context, int subtractedDays){
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => const SleepPage(),
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
            _navigate(context, -difference);
          }
        },
        icon: const Icon(Icons.calendar_month)
      )
    ];
  }

  Widget _showHeader(BuildContext context, {required int subtractedDays, required DateTime? startDate, required DateTime? endDate}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => _navigate(context, subtractedDays-1),
          icon: const Icon(Icons.arrow_back_ios)
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width*0.7,
          child: Column(
            children: [
              Text(
                'from ${_toDateAndTime(startDate)}',
                style: const TextStyle(fontSize: 16)
              ),
              const SizedBox(height: 2),
              Text(
                'to ${_toDateAndTime(endDate)}',
                style: const TextStyle(fontSize: 16)
              )
            ],
          ),
        ),
        Visibility(
          visible: subtractedDays == 0 ? false : true,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: IconButton(
            onPressed: () => _navigate(context, subtractedDays+1),
            icon: const Icon(Icons.arrow_forward_ios)
          ),
        )
      ],
    );
  }

  Widget _showChart(BuildContext context, int subtractedDays, List<FitbitSleepData> sleepData){
    Map<String, int> levels = {};
    List<_SleepDatum> data = [];
    List<String> times = [];
    int iterCounter = 0;
    for(FitbitSleepData item in sleepData){
      iterCounter = iterCounter + 1;
      if(item.level != null){
        if(!levels.keys.contains(item.level)){
          levels.addEntries({item.level! : 1}.entries);
        } else {
          levels[item.level!] = levels[item.level]! + 1;
        }

        if(item.entryDateTime != null && item.level != null){
          final level = item.level!;
          final time = item.entryDateTime!;
          data.add(_SleepDatum(DateFormat.Hm().format(time), level));
          times.add(DateFormat.Hm().format(time));
        }
      }
    }

    List<Widget> timesInPercentage = [];
    for(String item in levels.keys){
      final time = levels[item]!*30~/60; // minutes
      int h = time ~/ 60;
      int m = time - (h * 60);
      final percentage = (levels[item]!/levels.values.sum*100*100).toInt()/100;
      timesInPercentage.add(
        Text(item == 'wake' ? 'time awake: ${h == 0 ? '$m m' : '$h h $m m'} ($percentage %)' : 'time in $item sleep: ${h == 0 ? '$m m' : '$h h $m m'} ($percentage %)', style: const TextStyle(fontSize: 16))
      );
      timesInPercentage.add(const SizedBox(height: 10));
    }

    Map<String, int> levelsValues = {'deep': 0, 'light': 1, 'rem': 2, 'wake': 3};
    List<Color> colors = [Colors.deepPurple, Colors.pink, Colors.orange, Colors.yellow];
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.9,
      child: Column(
        children: [
          _Chart(data: data, levelsValues: levelsValues, colors: colors, times: times),
          const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 10, width: 10, color: colors[0]),
            const SizedBox(width: 10),
            const Text('0: deep sleep'),
            const SizedBox(width: 20),
            Container(height: 10, width: 10, color: colors[1]),
            const SizedBox(width: 10),
            const Text('1: light sleep')
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(height: 10, width: 10, color: colors[2]),
              const SizedBox(width: 10),
              const Text('2: rem sleep'),
              const SizedBox(width: 20),
              Container(height: 10, width: 10, color: colors[3]),
              const SizedBox(width: 10),
              const Text('3: awake')
            ],
          ),
          const SizedBox(height: 30),
          Column(children: timesInPercentage)
        ],
      ),
    );
  }

  Widget _showSleep(BuildContext context, int subtractedDays){
    return FutureBuilder(
      future: _fetchSleep(context, subtractedDays),
      builder: (context, snapshot){
        if(snapshot.hasData){
          final sleepData = snapshot.data as List<FitbitSleepData>;
          final startDate = sleepData.isEmpty ? null : sleepData[0].entryDateTime;
          final endDate = sleepData.isEmpty ? null : sleepData[sleepData.length-1].entryDateTime;
          return Column(
            children: [
              const SizedBox(height: 20),
              _showHeader(
                context,
                subtractedDays: subtractedDays,
                startDate: startDate,
                endDate: endDate
              ),
              const SizedBox(height: 30),
              Text('sleep duration: ${_getSleepDuration(startDate, endDate)}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 30),
              _showChart(context, subtractedDays, sleepData)
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

class _SleepDatum {
  final String time;
  final String level;

  _SleepDatum(this.time, this.level);
}

class _Chart extends StatelessWidget{
  final List<_SleepDatum> data;
  final Map<String, int> levelsValues;
  final List<Color> colors;
  final List<String> times;
  const _Chart({Key? key, required this.data, required this.levelsValues, required this.colors, required this.times}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: 200,
      child: SfCartesianChart(
        trackballBehavior: TrackballBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
          tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
          markerSettings: const TrackballMarkerSettings(
            markerVisibility: TrackballVisibilityMode.visible,
            color: Colors.black,
            shape: DataMarkerType.circle,
            height: 8,
            width: 8
          ),
          tooltipAlignment: ChartAlignment.center,
          lineWidth: 1.5,
          builder: (BuildContext context, TrackballDetails details){
            final time = details.pointIndex == null ? '' : times[details.pointIndex!];
            final String level;
            if(details.point == null || details.point!.yValue == null){
              level = '';
            } else {
              level = levelsValues.keys.toList()[details.point!.yValue];
            }
            return Card(
              elevation: 5,
              child: Container(
                padding: const EdgeInsets.all(5),
                child: Text('$time - $level', style: const TextStyle(fontSize: 16)),
                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black)),
              ),
            );
          }
        ),
        enableAxisAnimation: true,
        primaryXAxis: CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
          maximumLabels: 2,
          minimum: 0,
          maximum: 3
        ),
        series: [
          LineSeries(
            dataSource: data,
            xValueMapper: (_SleepDatum datum, _) => datum.time,
            yValueMapper: (_SleepDatum datum, _) => levelsValues[datum.level],
            markerSettings: const MarkerSettings(isVisible: true),
            pointColorMapper: (_SleepDatum datum, _) => colors[levelsValues[datum.level]!],
            width: 1
          )
        ],
      ),
    );
  }
}