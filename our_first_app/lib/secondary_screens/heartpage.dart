import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:our_first_app/utils/queries_counter.dart';
import 'package:our_first_app/utils/client_credentials.dart';
import 'package:pie_chart/pie_chart.dart';

class HeartPage extends StatefulWidget{
  const HeartPage({Key? key}) : super(key: key);

  @override
  State<HeartPage> createState() => _HeartPageState();
}

class _HeartPageState extends State<HeartPage>{
  final FitbitHeartDataManager _fitbitHeartDataManager = FitbitHeartDataManager(clientID: Credentials.getCredentials().id, clientSecret: Credentials.getCredentials().secret);

  @override
  Widget build(BuildContext context){
  int subtractedDays = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Heart'),
        actions: [
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
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => const HeartPage(),
                    transitionDuration: Duration.zero, // in this way there is no animation
                    settings: RouteSettings(arguments: -difference)
                  ),
                );
              }
            },
            icon: const Icon(Icons.calendar_month)
          ),
          Visibility(
            visible: false,
            maintainSize: false,
            child: IconButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const HeartPage(),
                  transitionDuration: Duration.zero, // in this way there is no animation
                  settings: const RouteSettings(arguments: 0)
                ),
              ),
              icon: const Icon(Icons.update)
            ),
          )
        ],
      ),
      body: Center(
        child: FutureBuilder(
          initialData: null,
          future: _fetchHeartData(subtractedDays),
          builder: (context, snapshot){
            if(snapshot.hasData){
              final heartData = snapshot.data as List<FitbitHeartData>;
              final dataMap = {
                'Minutes out of activity range [${heartData[0].minimumOutOfRange}-${heartData[0].minimumFatBurn}]: ${_intToTime(heartData[0].minutesOutOfRange!)}': heartData[0].minutesOutOfRange! + .0,
                'Minutes in fat-burn range [${heartData[0].minimumFatBurn}-${heartData[0].minimumCardio}]: ${_intToTime(heartData[0].minutesFatBurn!)}': heartData[0].minutesFatBurn! + .0,
                'Minutes in cardio range [${heartData[0].minimumCardio}-${heartData[0].minimumPeak}]: ${_intToTime(heartData[0].minutesCardio!)}': heartData[0].minutesCardio! + .0,
                'Minutes in peak range [${heartData[0].minimumPeak}-220]: ${_intToTime(heartData[0].minutesPeak!)}': heartData[0].minutesPeak! + .0
              };
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: (){
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) => const HeartPage(),
                              transitionDuration: Duration.zero, // in this way there is no page animation
                              settings: RouteSettings(arguments: subtractedDays-1)
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_back_ios)
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width*0.7,
                        child: Column(
                          children: [
                            Text(
                              subtractedDays == 0 ? 'last 24 hours' : _toDate(heartData[0].dateOfMonitoring!),
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
                          onPressed: (){
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation1, animation2) => const HeartPage(),
                                transitionDuration: Duration.zero, // in this way there is no animation
                                settings: RouteSettings(arguments: subtractedDays+1)
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward_ios)
                        ),
                      )
                    ]
                  ),
                  const SizedBox(height: 20),
                  Text('Resting heart rate: ${heartData[0].restingHeartRate} bpm', style: const TextStyle(fontSize: 16),),
                  const SizedBox(height: 40),
                  PieChart(
                    dataMap: dataMap,
                    chartType: ChartType.ring,
                    chartRadius: 220,
                    ringStrokeWidth: 40,
                    colorList: const [Colors.blue, Colors.green, Colors.yellow, Colors.red],
                    legendOptions: const LegendOptions(
                      legendPosition: LegendPosition.bottom,
                      legendTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)
                    )
                  ),
                ],
              );
            } else {
              final queriesCounter = QueriesCounter.getInstance();
              return queriesCounter.getStopQueries()
              ? const Text('Rate limit of requests exceeded...', style: TextStyle(fontSize: 16))
              : const CircularProgressIndicator();
            }
          }
        ),
      ),
    );
  }

  Future<List<FitbitHeartData>?> _fetchHeartData(int subtracted) async {
    final queriesCounter = QueriesCounter.getInstance();
    final now = DateTime.now();
    if(queriesCounter.check()){
      return null;
    } else {
      return await _fitbitHeartDataManager.fetch(
        FitbitHeartAPIURL.dayWithUserID(
          date: DateTime.utc(now.year, now.month, now.day+subtracted),
          userID: '7ML2XV',
        )
      ) as List<FitbitHeartData>;  
    }
  }

  String _toDate(DateTime date){
    return '${date.day}/${date.month}/${date.year}';
  }

  String _intToTime(int value){
    int h = value ~/ 60;
    int m = value - (h * 60);
    return '$h h $m m';
  }
}