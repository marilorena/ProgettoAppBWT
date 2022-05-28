import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:our_first_app/utils/client_credentials.dart';
import 'package:pie_chart/pie_chart.dart';

class HeartPage extends StatefulWidget{
  const HeartPage({Key? key}) : super(key: key);

  @override
  State<HeartPage> createState() => _HeartPageState();
}

class _HeartPageState extends State<HeartPage>{
  final FitbitHeartDataManager? _fitbitHeartDataManager = FitbitHeartDataManager(clientID: Credentials.getCredentials().id, clientSecret: Credentials.getCredentials().secret);

  @override
  Widget build(BuildContext context){
  int subtractedDays = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Heart'),
        actions: [
          subtractedDays != 0
          ? Container()
          : IconButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => const HeartPage(),
                transitionDuration: Duration.zero, // in this way there is no animation
                settings: const RouteSettings(arguments: 0)
              ),
            ),
            icon: const Icon(Icons.update)
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
                'Minutes out of activity range [${heartData[0].minimumOutOfRange}-${heartData[0].minimumFatBurn}]: ${heartData[0].minutesOutOfRange!}': heartData[0].minutesOutOfRange! + .0,
                'Minutes in fat-burn range [${heartData[0].minimumFatBurn}-${heartData[0].minimumCardio}]: ${heartData[0].minutesFatBurn!}': heartData[0].minutesFatBurn! + .0,
                'Minutes in cardio range [${heartData[0].minimumCardio}-${heartData[0].minimumPeak}]: ${heartData[0].minutesCardio!}': heartData[0].minutesCardio! + .0,
                'Minutes in peak range [${heartData[0].minimumPeak}-220]: ${heartData[0].minutesPeak!}': heartData[0].minutesPeak! + .0
              };
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) => const HeartPage(),
                              transitionDuration: Duration.zero, // in this way there is no animation
                              settings: RouteSettings(arguments: subtractedDays-1)
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_back_ios)
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width-100,
                        child: Text(_toDate(heartData[0].dateOfMonitoring!), style: const TextStyle(fontSize: 16),)
                      ),
                      subtractedDays == 0
                      ? Container()
                      : IconButton(
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
              return const CircularProgressIndicator();
            }
          }
        ),
      ),
    );
  }

  Future<List<FitbitHeartData>> _fetchHeartData(int subtracted) async {
    return await _fitbitHeartDataManager?.fetch(
      FitbitHeartAPIURL.dayWithUserID(
        date: DateTime.now().subtract(Duration(days: -subtracted)),
        userID: '7ML2XV',
      )
    ) as List<FitbitHeartData>;  
  }

  String _toDate(DateTime date){
    return '${date.day}/${date.month}/${date.year}';
  }
}