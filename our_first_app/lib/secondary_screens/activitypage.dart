import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:our_first_app/utils/client_credentials.dart';
import 'package:our_first_app/utils/queries_counter.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityPage extends StatefulWidget{
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  late final FitbitActivityTimeseriesDataManager _fitbitActivityTimeseriesDataManager;
  late final FitbitActivityDataManager _fitbitActivityDataManager;

  @override
  void initState() {
    _fitbitActivityTimeseriesDataManager = FitbitActivityTimeseriesDataManager(clientID: Credentials.getCredentials().id, clientSecret: Credentials.getCredentials().secret);
    _fitbitActivityDataManager = FitbitActivityDataManager(clientID: Credentials.getCredentials().id, clientSecret: Credentials.getCredentials().secret);
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    int subtractedDays = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Activity'),
        actions: [
          Visibility(
            visible: subtractedDays == 0 ? true : false,
            child: IconButton(
              icon: const Icon(Icons.update),
              onPressed: () => Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const ActivityPage(),
                  transitionDuration: Duration.zero, // in this way there is no page animation
                  settings: const RouteSettings(arguments: 0)
                ),
              ),
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
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => const ActivityPage(),
                    transitionDuration: Duration.zero, // in this way there is no animation
                    settings: RouteSettings(arguments: -difference)
                  ),
                );
              }
            },
            icon: const Icon(Icons.calendar_month)
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/activitysettings/');
            }
          )
        ],
      ),
      body: Center(
        child: FutureBuilder(
          initialData: null,
          future: _fetchSteps(subtractedDays),
          builder: (context, snapshot){
            if(snapshot.hasData){
              final stepsData = snapshot.data as List<FitbitActivityTimeseriesData>;
              final stepsDataMap = {'Steps: ${stepsData[0].value!.toInt()}': stepsData[0].value?? 0};
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
                              pageBuilder: (context, animation1, animation2) => const ActivityPage(),
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
                              _toDate(stepsData[0].dateOfMonitoring!),
                              style: const TextStyle(fontSize: 16),
                            ),
                            Column(
                              children: [
                                const SizedBox(height: 2),
                                Text(
                                  subtractedDays == 0
                                  ? '00:00 - ${_toTime(DateTime.now())}'
                                  : '00:00 - 23:59',
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
                          onPressed: (){
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation1, animation2) => const ActivityPage(),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPieChart(context, true, stepsDataMap),
                      const SizedBox(width: 30),
                      FutureBuilder(
                        initialData: null,
                        future: _fetchFloors(subtractedDays),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            final floorsData = snapshot.data as List<FitbitActivityTimeseriesData>;
                            final floorsDataMap = {'Floors: ${floorsData[0].value!.toInt()}': floorsData[0].value?? 0};
                            return _buildPieChart(context, false, floorsDataMap);
                          } else {
                            return Container();
                          }
                        }
                      )
                    ]
                  )
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          }
        )
      )
    );
  }

  Future<List<FitbitActivityTimeseriesData>?> _fetchSteps(int subtracted) async {
    final sp = await SharedPreferences.getInstance();
    final userID = sp.getString('userID');
    final now = DateTime.now();
    if(userID == null || QueriesCounter.getInstance().check()){
      return null;
    } else {
      return await _fitbitActivityTimeseriesDataManager.fetch(
        FitbitActivityTimeseriesAPIURL.dayWithResource(
          date: DateTime.utc(now.year, now.month, now.day+subtracted),
          userID: userID,
          resource: 'steps',
        )
      ) as List<FitbitActivityTimeseriesData>;  
    }
  }

  Future<List<FitbitActivityTimeseriesData>?> _fetchFloors(int subtracted) async {
    final sp = await SharedPreferences.getInstance();
    final userID = sp.getString('userID');
    final now = DateTime.now();
    if(userID == null || QueriesCounter.getInstance().check()){
      return null;
    } else {
      return await _fitbitActivityTimeseriesDataManager.fetch(
        FitbitActivityTimeseriesAPIURL.dayWithResource(
          date: DateTime.utc(now.year, now.month, now.day+subtracted),
          userID: userID,
          resource: 'floors',
        )
      ) as List<FitbitActivityTimeseriesData>;
    }
  }

  Future<List<FitbitActivityData>?> _fetchActivity() async {
    final sp = await SharedPreferences.getInstance();
    final userID = sp.getString('userID');
    final now = DateTime.now();
    if(userID == null || QueriesCounter.getInstance().check()){
      return null;
    } else {
      return await _fitbitActivityDataManager.fetch(
        FitbitActivityAPIURL.day(
          date: DateTime.utc(now.year, now.month, now.day),
          userID: userID
        )
      ) as List<FitbitActivityData>;
    }
  }

  Future<List<FitbitActivityTimeseriesData>?> _fetchSedentary() async {
    final sp = await SharedPreferences.getInstance();
    final userID = sp.getString('userID');
    final now = DateTime.now();
    if(userID == null || QueriesCounter.getInstance().check()){
      return null;
    } else {
      return await _fitbitActivityTimeseriesDataManager.fetch(
        FitbitActivityTimeseriesAPIURL.dayWithResource(
          date: DateTime.utc(now.year, now.month, now.day),
          userID: userID,
          resource: 'minutesSedentary',
        )
      ) as List<FitbitActivityTimeseriesData>;
    }
  }

  Future<List<FitbitActivityTimeseriesData>?> _fetchLight() async {
    final sp = await SharedPreferences.getInstance();
    final userID = sp.getString('userID');
    final now = DateTime.now();
    if(userID == null || QueriesCounter.getInstance().check()){
      return null;
    } else {
      return await _fitbitActivityTimeseriesDataManager.fetch(
      FitbitActivityTimeseriesAPIURL.dayWithResource(
        date: DateTime.utc(now.year, now.month, now.day),
        userID: userID,
        resource: 'minutesLightlyActive',
      )
    ) as List<FitbitActivityTimeseriesData>;
    }
  }

  Future<List<FitbitActivityTimeseriesData>?> _fetchFairly() async {
    final sp = await SharedPreferences.getInstance();
    final userID = sp.getString('userID');
    final now = DateTime.now();
    if(userID == null || QueriesCounter.getInstance().check()){
      return null;
    } else {
      return await _fitbitActivityTimeseriesDataManager.fetch(
        FitbitActivityTimeseriesAPIURL.dayWithResource(
          date: DateTime.utc(now.year, now.month, now.day),
          userID: userID,
          resource: 'minutesFairlyActive',
        )
      ) as List<FitbitActivityTimeseriesData>;
    }
  }

  Future<List<FitbitActivityTimeseriesData>?> _fetchVery() async {
    final sp = await SharedPreferences.getInstance();
    final userID = sp.getString('userID');
    final now = DateTime.now();
    if(userID == null || QueriesCounter.getInstance().check()){
      return null;
    } else {
      return await _fitbitActivityTimeseriesDataManager.fetch(
        FitbitActivityTimeseriesAPIURL.dayWithResource(
          date: DateTime.utc(now.year, now.month, now.day),
          userID: userID,
          resource: 'minutesVeryActive',
        )
      ) as List<FitbitActivityTimeseriesData>;
    }
  }

  String _toDate(DateTime date){
    return '${date.day}/${date.month}/${date.year}';
  }

  String _toTime(DateTime date){
    return '${date.hour}:${date.minute}';
  }

  Widget _buildPieChart(BuildContext context, bool isSteps, Map<String,double> dataMap){
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          final sp = snapshot.data as SharedPreferences;
          if(sp.getDouble('steps')==null){sp.setDouble('steps', 5000.0);}
          if(sp.getDouble('floors')==null){sp.setDouble('floors', 1.0);}
          final steps = sp.getDouble('steps');
          final floors = sp.getDouble('floors');
          return PieChart(
            dataMap: dataMap,
            chartType: ChartType.ring,
            chartRadius: 120,
            totalValue: isSteps ? steps : floors, // to be changed after the creation of the database
            legendOptions: const LegendOptions(
              legendPosition: LegendPosition.bottom,
              legendTextStyle: TextStyle(fontSize: 15)
            ),
            chartLegendSpacing: 20,
            colorList: const [Colors.blue],
            baseChartColor: const Color.fromARGB(147, 158, 158, 158),
            centerText: 'target: ${isSteps ? steps!.toInt() : floors!.toInt()}',
            chartValuesOptions: const ChartValuesOptions(showChartValuesInPercentage: true),
            initialAngleInDegree: 360.0
          );
        } else {
          return Container();
        }
      }
    );
  }
}