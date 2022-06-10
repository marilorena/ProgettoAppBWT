import 'dart:convert';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:our_first_app/model/yogapose.dart';
import 'package:our_first_app/utils/client_credentials.dart';
import 'package:our_first_app/utils/queries_counter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YogaPage extends StatelessWidget {
  const YogaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _fetchPose(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              final poses = snapshot.data as List<YogaPose>;
              return Column(
                children: [
                  const Text(
                    'Based on your recent activity,\n here are 3 suggested yoga poses for you',
                    maxLines: 20,
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 1)
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    cacheExtent: 0,
                    scrollDirection: Axis.horizontal,
                    itemCount: poses.length,
                    itemBuilder: (context, index) => Column( 
                      crossAxisAlignment: CrossAxisAlignment.center, 
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          margin: const EdgeInsets.only(left: 20, top: 70, bottom: 100, right: 30),
                          shadowColor: const Color.fromARGB(0, 190, 228, 193),
                          color: const Color.fromARGB(255, 224, 245, 223),
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(50),
                            child: FittedBox(
                              child: Column(
                                children: [
                                  Text(poses[index].name),
                                  Text(
                                    poses[index].sanskritName,
                                    style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                      color: Colors.green
                                    )
                                  ),
                                  const SizedBox(height: 15),
                                  SvgPicture.network(
                                    poses[index].imageUrl,
                                    height: 250
                                  ),
                                ],
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
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
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back),
        backgroundColor: Colors.green
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }

  // fetch methods
  Future<List<YogaPose>?> _fetchPose() async{
    List<YogaPose>? poses;
    final steps = await _fetchSteps();
    final sleep = await _fetchSleep(1);
    if(steps != null){
      double? numOfSteps = steps[0].value;
      List<int> id = [];
      if(numOfSteps != null){
        if(numOfSteps > 20000){
          id = [18];
        } else if(numOfSteps <= 20000 && numOfSteps > 15000){
          id = [9, 6, 14];
        } else if(numOfSteps <= 15000 && numOfSteps > 10000){
          id = [21, 23, 41];
        } else if(numOfSteps <= 10000 && numOfSteps > 5000){
          id = [15, 20, 24];
        } else if(numOfSteps <= 5000){
          id = [10, 28, 30];
        }
      }

      poses = [];
        final url = 'https://lightning-yoga-api.herokuapp.com/yoga_poses/${id[0]}';
        final response = await http.get(Uri.parse(url));
        if(response.statusCode == 200){
          poses.add(YogaPose.fromJson(jsonDecode(response.body)));
        }
    }

    if(sleep != null){
      List<int>? dura = [];
      double? duration = dura as double ;
      List<int> id = [];

      if(duration != null){
        if(duration > 20000){
          id = [18];
        } else if(duration <= 20000 && duration> 15000){
          id = [9, 6, 14];
        } else if(duration <= 15000 && duration> 10000){
          id = [21, 23, 41];
        } else if(duration <= 10000 && duration> 5000){
          id = [15, 20, 24];
        } else if(duration <= 5000){
          id = [10, 28, 30];
        }
      }

      poses = [];
        final url = 'https://lightning-yoga-api.herokuapp.com/yoga_poses/${id[0]}';
        final response = await http.get(Uri.parse(url));
        if(response.statusCode == 200){
          poses.add(YogaPose.fromJson(jsonDecode(response.body)));
        }
    }

    return poses;
  }

  Future<List<FitbitActivityTimeseriesData>?> _fetchSteps() async {
    FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManager = FitbitActivityTimeseriesDataManager(
      clientID: Credentials.getCredentials().id,
      clientSecret: Credentials.getCredentials().secret,
      type: 'steps'
    );
    final sp = await SharedPreferences.getInstance();
    final userID = sp.getString('userID');
    final stopQueries = await QueriesCounter.getInstance().check();
    final isTokenValid = await FitbitConnector.isTokenValid();
    if(!isTokenValid || stopQueries){
      return null;
    } else {
      return await fitbitActivityTimeseriesDataManager
        .fetch(FitbitActivityTimeseriesAPIURL.dayWithResource(
          date: DateTime.now(),
          userID: userID,
          resource: fitbitActivityTimeseriesDataManager.type
        )
      ) as List<FitbitActivityTimeseriesData>;
    }
  }


  Future<List<FitbitSleepData>?> _fetchSleep(int subtracted) async {
    final FitbitSleepDataManager fitbitSleepDataManager = FitbitSleepDataManager(
      clientID: Credentials.getCredentials().id,
      clientSecret: Credentials.getCredentials().secret,
    );
    final sp = await SharedPreferences.getInstance();
    final userID = sp.getString('userID');
    final now = DateTime.now();
    final stopQueries = await QueriesCounter.getInstance().check();
    final isTokenValid = await FitbitConnector.isTokenValid();
    if(!isTokenValid || stopQueries){
      return null;
    } else {
      return await fitbitSleepDataManager.fetch(
        FitbitSleepAPIURL.withUserIDAndDay(
          date: DateTime.utc(now.year, now.month, now.day+subtracted),
          userID: userID,
        )
      ) as List<FitbitSleepData>; 
    }
  }

  Future<List<FitbitHeartData>?> _fetchHeartData(int subtracted) async {
    FitbitHeartDataManager fitbitHeartDataManager = FitbitHeartDataManager(
      clientID: Credentials.getCredentials().id,
      clientSecret: Credentials.getCredentials().secret
    );
    final sp = await SharedPreferences.getInstance();
    final userID = sp.getString('userID');
    final now = DateTime.now();
    final stopQueries = await QueriesCounter.getInstance().check();
    final isTokenValid = await FitbitConnector.isTokenValid();
    if(!isTokenValid || stopQueries){
      return null;
    } else {
      return await fitbitHeartDataManager.fetch(
        FitbitHeartAPIURL.dayWithUserID(
          date: DateTime.utc(now.year, now.month, now.day+subtracted),
          userID: userID,
        )
      ) as List<FitbitHeartData>;
    }
  }


   List<int>? _getSleepDuration(DateTime? startDate, DateTime? endDate){
    if(startDate == null || endDate == null){
      return null;
    } else {
      final duration = (endDate.millisecondsSinceEpoch - startDate.millisecondsSinceEpoch)~/1000~/60;
      int h = duration ~/ 60;
      int m = duration - (h * 60);
      return [h,m];
    }
  }


  // utils
  Future<bool> _isTokenValid() async{
    return await FitbitConnector.isTokenValid();
  }

  // UI blocks
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
            Navigator.pushReplacementNamed(context, '/yoga/');
          },
          child: const Text('Authorize'),
        )
      ],
    );
  }
}
