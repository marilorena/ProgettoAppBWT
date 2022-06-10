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
    final sleepData = await _fetchSleep(0);
    final heartData = await _fetchHeartData(0);
    final startDate = sleepData![0].entryDateTime;
    final endDate = sleepData[sleepData.length-1].entryDateTime;
    final time = (endDate!.millisecondsSinceEpoch - startDate!.millisecondsSinceEpoch)~/1000; //dovrebbe essere in secondi
    final heart = heartData![0].minutesPeak;
    if(steps != null){
      double? numOfSteps = steps[0].value;
      List<int> id = [];
      if(numOfSteps != null){
        if(numOfSteps > 20000){
          id = [18];
        } else if(numOfSteps <= 20000 && numOfSteps > 15000){
          id = [9];
        } else if(numOfSteps <= 15000 && numOfSteps > 10000){
          id = [21];
        } else if(numOfSteps <= 10000 && numOfSteps > 5000){
          id = [15];
        } else if(numOfSteps <= 5000){
          id = [10];
        }
      }

      poses = [];
        final url = 'https://lightning-yoga-api.herokuapp.com/yoga_poses/${id[0]}';
        final response = await http.get(Uri.parse(url));
        if(response.statusCode == 200){
          poses.add(YogaPose.fromJson(jsonDecode(response.body)));
        }
    }

    if(sleepData != null){

      int duration = time;
      List<int> id = [];

      if(duration != null){
        if(duration > 36000){ //10 ore
          id = [4];
        } else if(duration <= 36000 && duration> 28800){ //10 a 8 ore
          id = [6];
        } else if(duration <= 28800 && duration> 21600){ //8 a 6 ore
          id = [23];
        } else if(duration <= 21600 && duration> 14400){ //6 a 4 ore
          id = [20];
        } else if(duration <= 14400){ //sotto le 4 ore
          id = [28];
        }
      }

      if (poses == null){
         poses = [];
      }else{
      
        final url = 'https://lightning-yoga-api.herokuapp.com/yoga_poses/${id[0]}';
        final response = await http.get(Uri.parse(url));
        if(response.statusCode == 200){
          poses.add(YogaPose.fromJson(jsonDecode(response.body)));
        }
      }
    }

   if(heartData != null){
      int? minutesOfPeak = heart;
      List<int> id = [];
      if(minutesOfPeak != null){
        if(minutesOfPeak > 20){ //minuti di peak rate
          id = [12];
        } else if( minutesOfPeak <= 20 && minutesOfPeak > 15){
          id = [14];
        } else if(minutesOfPeak <= 15 && minutesOfPeak > 10){
          id = [41];
        } else if(minutesOfPeak <= 10 && minutesOfPeak > 5){
          id = [24];
        } else if(minutesOfPeak <= 5){
          id = [30];
        }
      }

      if (poses == null) {
        poses = [];
      }else{
        final url = 'https://lightning-yoga-api.herokuapp.com/yoga_poses/${id[0]}';
        final response = await http.get(Uri.parse(url));
        if(response.statusCode == 200){
          poses.add(YogaPose.fromJson(jsonDecode(response.body)));
        }
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
          date: DateTime.utc(now.year, now.month, now.day-subtracted),
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
