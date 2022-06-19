import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:our_first_app/database/entities/heart_entity.dart';
import 'package:our_first_app/database/repository/database_repository.dart';
import 'package:our_first_app/utils/queries_counter.dart';
import 'package:our_first_app/utils/client_credentials.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeartPage extends StatelessWidget{
  const HeartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){    
    int subtractedDays = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Heart'),
        actions: _showActions(context)
      ),
      body: Center(
        child: FutureBuilder(
          initialData: null,
          future: _fetchHeartData(context, subtractedDays),
          builder: (context, snapshot){
            if(snapshot.hasData){
              final heartData = snapshot.data as List<FitbitHeartData>;
              return Column(
                children: [
                  const SizedBox(height: 20),
                  _showHeader(context, subtractedDays, heartData.isEmpty ? null : heartData[0].dateOfMonitoring),
                  const SizedBox(height: 20),
                  Text(
                    'Resting heart rate: ${heartData.isEmpty || heartData[0].restingHeartRate == null ? '--' : heartData[0].restingHeartRate} bpm',
                    style: const TextStyle(fontSize: 16)
                  ),
                  const SizedBox(height: 40),
                  _showPieChart(heartData)
                ],
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
        ),
      ),
    );
  }

  // fetch method
  Future<List<FitbitHeartData>?> _fetchHeartData(BuildContext context, int subtracted) async {
    DateTime date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+subtracted);
    DateTime? mostRecentDate = await Provider.of<DatabaseRepository>(context, listen: false).getRecentHeartDate();
    if(mostRecentDate != null && date.compareTo(mostRecentDate) > 0){
      //delete the most recent data
      await Provider.of<DatabaseRepository>(context, listen: false).deleteRecentHeartData();
    }
    final heartFromDB = await Provider.of<DatabaseRepository>(context, listen: false).getHeartDataByDate(date);
    print(heartFromDB);
    if(heartFromDB != null){
      return [FitbitHeartData(
        dateOfMonitoring: heartFromDB.date,
        restingHeartRate: heartFromDB.restingHR,
        minimumOutOfRange: heartFromDB.minimumOutOfRange,
        minutesOutOfRange: heartFromDB.minutesOutOfRange,
        minimumFatBurn: heartFromDB.minimumFatBurn,
        minutesFatBurn: heartFromDB.minutesFatBurn,
        minimumCardio: heartFromDB.minimumCardio,
        minutesCardio: heartFromDB.minutesCardio,
        minimumPeak: heartFromDB.minimumPeak,
        minutesPeak: heartFromDB.minutesPeak
      )];
    } else{
      FitbitHeartDataManager fitbitHeartDataManager = FitbitHeartDataManager(
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
        final isTokenValid = await FitbitConnector.isTokenValid();
        if(!isTokenValid){
          return null;
        }
        stopQueries = await QueriesCounter.getInstance().check();
        if(stopQueries){
          return null;
        } else {
          final fetchedData = await fitbitHeartDataManager.fetch(
            FitbitHeartAPIURL.dayWithUserID(
              date: DateTime.utc(now.year, now.month, now.day+subtracted),
              userID: userID,
            )
          ) as List<FitbitHeartData>;
          if(fetchedData.isNotEmpty){
            await Provider.of<DatabaseRepository>(context, listen: false).insertHeartData([Heart(
              date: fetchedData[0].dateOfMonitoring?? DateTime.fromMillisecondsSinceEpoch(0),
              restingHR: fetchedData[0].restingHeartRate,
              minimumOutOfRange: fetchedData[0].minimumOutOfRange,
              minutesOutOfRange: fetchedData[0].minutesOutOfRange,
              minimumFatBurn: fetchedData[0].minimumFatBurn,
              minutesFatBurn: fetchedData[0].minutesFatBurn,
              minimumCardio: fetchedData[0].minimumCardio,
              minutesCardio: fetchedData[0].minutesCardio,
              minimumPeak: fetchedData[0].minimumPeak,
              minutesPeak: fetchedData[0].minutesPeak
            )]);
          }
          return fetchedData;
        }
      }
    }
  }

  // utils
  String _toDate(DateTime? date){
    return date != null
    ? DateFormat('EEE, dd/MM/y').format(date)
    : '--/--/----';
  }

  String _intToTime(int? value){
    if(value == null){
      return '0 h 0 m';
    } else {
      int h = value ~/ 60;
      int m = value - (h * 60);
      return '$h h $m m';
    }
  }

  void _navigate(BuildContext context, int subtractedDays){
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => const HeartPage(),
        transitionDuration: Duration.zero, // in this way there is no animation
        settings: RouteSettings(arguments: subtractedDays)
      ),
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
  List<Widget> _showActions(BuildContext context){
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
      ),
      Visibility(
        visible: false,
        maintainSize: false,
        child: IconButton(
          onPressed: () => _navigate(context, 0),
          icon: const Icon(Icons.update)
        ),
      )
    ];
  }

  Widget _showHeader(BuildContext context, int subtractedDays, DateTime? date){
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
                subtractedDays == 0 ? 'last 24 hours' : _toDate(date),
                style: const TextStyle(fontSize: 16),
              ),
              Visibility(
                visible: subtractedDays == 0 ? false : true,
                maintainSize: false,
                child: Column(
                  children: const [
                    SizedBox(height: 2),
                    Text(
                      '00:00 - 23:59',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                )
              )
            ],
          )
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
      ]
    );
  }

  Widget _showPieChart(List<FitbitHeartData> heartData){
    if(heartData.isEmpty){
      return Container();
    } else {
      final dataMap = {
        'Minutes out of activity range [${heartData[0].minimumOutOfRange}-${heartData[0].minimumFatBurn}]: ${_intToTime(heartData[0].minutesOutOfRange)}': heartData[0].minutesOutOfRange == null ? 0.0 : heartData[0].minutesOutOfRange! + .0,
        'Minutes in fat-burn range [${heartData[0].minimumFatBurn}-${heartData[0].minimumCardio}]: ${_intToTime(heartData[0].minutesFatBurn)}': heartData[0].minutesFatBurn == null ? 0.0 : heartData[0].minutesFatBurn! + .0,
        'Minutes in cardio range [${heartData[0].minimumCardio}-${heartData[0].minimumPeak}]: ${_intToTime(heartData[0].minutesCardio)}': heartData[0].minutesCardio == null ? 0.0 : heartData[0].minutesCardio! + .0,
        'Minutes in peak range [${heartData[0].minimumPeak}-220]: ${_intToTime(heartData[0].minutesPeak)}': heartData[0].minutesPeak == null ? 0.0 : heartData[0].minutesPeak! + .0
      };
      return PieChart(
        dataMap: dataMap,
        chartType: ChartType.ring,
        chartRadius: 220,
        ringStrokeWidth: 40,
        colorList: const [Colors.blue, Colors.green, Colors.yellow, Colors.red],
        legendOptions: const LegendOptions(
          legendPosition: LegendPosition.bottom,
          legendTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)
        ),
        chartValuesOptions: const ChartValuesOptions(showChartValuesInPercentage: true),
      );
    }
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