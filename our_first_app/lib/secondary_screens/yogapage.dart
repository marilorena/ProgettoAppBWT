import 'dart:convert';
import 'package:fitbitter/fitbitter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:our_first_app/database/entities/heart_entity.dart';
import 'package:our_first_app/database/entities/sleep_entity.dart';
import 'package:our_first_app/database/repository/database_repository.dart';
import 'package:our_first_app/model/yogapose.dart';
import 'package:our_first_app/utils/client_credentials.dart';
import 'package:our_first_app/utils/queries_counter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YogaPage extends StatelessWidget {
  const YogaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _isTokenValid(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              final isTokenValid = snapshot.data as bool;
              return FutureBuilder(
                future: _fetchPose(context, isTokenValid),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    final poses = snapshot.data as List<YogaPose>;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Based on your today\'s data,\n here are 3 suggested yoga poses for you\n(swipe left to see all)',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16)
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height*0.5,
                            maxWidth: MediaQuery.of(context).size.width*0.8
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            cacheExtent: 0,
                            scrollDirection: Axis.horizontal,
                            itemCount: poses.length,
                            padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                            separatorBuilder: (context, index) => const SizedBox(width: 20),
                            itemBuilder: (context, index) => SizedBox(
                              height: MediaQuery.of(context).size.height*0.5,
                              width: MediaQuery.of(context).size.width*0.75,
                              child: Card(
                                shadowColor: const Color.fromARGB(0, 190, 228, 193),
                                color: const Color.fromARGB(255, 224, 245, 223),
                                elevation: 10,
                                child: FittedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(50),
                                    child: Column(
                                      children: [
                                        Text(poses[index].name, style: const TextStyle(fontSize: 16)),
                                        Text(
                                          poses[index].sanskritName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.green
                                          )
                                        ),
                                        const SizedBox(height: 15),
                                        Image.asset(
                                          'asset/yoga/${poses[index].id}.png',
                                          height: MediaQuery.of(context).size.height*0.2
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ),
                        )         
                      ]
                    );
                  } else {
                    if(!isTokenValid){
                      return _showIfNotAuthorized(context);
                    } else if(QueriesCounter.getInstance().getStopQueries()){
                      return const Text('Limit rate of requests exceeded...', style: TextStyle(fontSize: 16));
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }
                }
              );
            } else {
              return const CircularProgressIndicator();
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
  Future<List<YogaPose>?> _fetchPose(BuildContext context, bool isTokenValid) async{
    List<YogaPose>? poses;
    final steps = await _fetchSteps(context, isTokenValid);
    final sleepData = await _fetchSleep(context, isTokenValid);
    final heartData = await _fetchHeartData(context, isTokenValid);
    
    if(steps != null && steps.isNotEmpty){
      double? numOfSteps = steps[0].value;
      int? id;
      if(numOfSteps != null){
        if(numOfSteps > 20000){
          id = 18;
        } else if(numOfSteps <= 20000 && numOfSteps > 15000){
          id = 9;
        } else if(numOfSteps <= 15000 && numOfSteps > 10000){
          id = 21;
        } else if(numOfSteps <= 10000 && numOfSteps > 5000){
          id = 15;
        } else if(numOfSteps <= 5000){
          id = 10;
        }
      }

      if(id != null){
        poses = [];
        final url = 'https://lightning-yoga-api.herokuapp.com/yoga_poses/$id';
        final response = await http.get(Uri.parse(url));
        if(response.statusCode == 200){
          poses.add(YogaPose.fromJson(jsonDecode(response.body)));
        }
      }
    }

    if(sleepData != null && sleepData.isNotEmpty){
      DateTime? startDate = sleepData[0].entryDateTime;
      DateTime? endDate = sleepData[sleepData.length-1].entryDateTime;
      int? id;
      if(startDate != null && endDate != null){
        int duration = (endDate.millisecondsSinceEpoch - startDate.millisecondsSinceEpoch)~/1000~/60~/60; // hours
        if(duration > 10){
          id = 4;
        } else if(duration <= 10 && duration > 8){
          id = 6;
        } else if(duration <= 8 && duration > 6){
          id = 23;
        } else if(duration <= 6 && duration > 4){
          id = 20;
        } else if(duration <= 4){
          id = 28;
        }
      }

      if(id != null){
        poses ??= []; // if(poses == null){poses=[];}
        final url = 'https://lightning-yoga-api.herokuapp.com/yoga_poses/$id';
        final response = await http.get(Uri.parse(url));
        if(response.statusCode == 200){
          poses.add(YogaPose.fromJson(jsonDecode(response.body)));
        }
      }
    }

   if(heartData != null && heartData.isNotEmpty){
      int? minutesOfPeak = heartData[0].minutesPeak;
      int? id;
      if(minutesOfPeak != null){
        if(minutesOfPeak > 20){
          id = 12;
        } else if( minutesOfPeak <= 20 && minutesOfPeak > 15){
          id = 14;
        } else if(minutesOfPeak <= 15 && minutesOfPeak > 10){
          id = 41;
        } else if(minutesOfPeak <= 10 && minutesOfPeak > 5){
          id = 24;
        } else if(minutesOfPeak <= 5){
          id = 30;
        }
      }

      if(id != null){
        poses ??= [];
        final url = 'https://lightning-yoga-api.herokuapp.com/yoga_poses/$id';
        final response = await http.get(Uri.parse(url));
        if(response.statusCode == 200){
          poses.add(YogaPose.fromJson(jsonDecode(response.body)));
        }
      }
    }
    return poses;
  }

  Future<List<FitbitActivityTimeseriesData>?> _fetchSteps(BuildContext context, bool isTokenValid) async{
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final activityFromDB = await Provider.of<DatabaseRepository>(context, listen: false).getActivityTimeseriesByDate(now);
    if(activityFromDB != null){
      // if present in db
      return [FitbitActivityTimeseriesData(value: activityFromDB.steps)];
    } else {
      // otherwise fetch from API
      bool stopQueries = await QueriesCounter.getInstance().check();
      if(stopQueries || !isTokenValid){
        return null;
      } else {
        FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManager = FitbitActivityTimeseriesDataManager(
          clientID: Credentials.getCredentials().id,
          clientSecret: Credentials.getCredentials().secret,
          type: 'steps'
        );
        final sp = await SharedPreferences.getInstance();
        final userID = sp.getString('userID');
        return await fitbitActivityTimeseriesDataManager
          .fetch(FitbitActivityTimeseriesAPIURL.dayWithResource(
            date: DateTime.now(),
            userID: userID,
            resource: fitbitActivityTimeseriesDataManager.type
          )
        ) as List<FitbitActivityTimeseriesData>;
      }
    }
  }


  Future<List<FitbitSleepData>?> _fetchSleep(BuildContext context, bool isTokenValid) async{
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final sleepFromDB = await Provider.of<DatabaseRepository>(context, listen: false).getSleepDataByDate(now);
    if(sleepFromDB.isNotEmpty){
      // if present in db...
      List<FitbitSleepData> sleepData = [];
      for(var item in sleepFromDB){
        sleepData.add(FitbitSleepData(
          dateOfSleep: item.date,
          entryDateTime: item.entryDateTime,
          level: item.level
        ));
      }
      sleepData.sort((a,b) => a.entryDateTime!.compareTo(b.entryDateTime!)); // sort by ascending entryDateTime
      return sleepData;
    } else {
      // otherwise fetch from API
      final FitbitSleepDataManager fitbitSleepDataManager = FitbitSleepDataManager(
        clientID: Credentials.getCredentials().id,
        clientSecret: Credentials.getCredentials().secret,
      );
      final sp = await SharedPreferences.getInstance();
      final userID = sp.getString('userID');
      bool stopQueries = await QueriesCounter.getInstance().check();
      if(stopQueries || !isTokenValid){
        return null;
      } else {
        final fetchedData = await fitbitSleepDataManager.fetch(
          FitbitSleepAPIURL.withUserIDAndDay(
            date: DateTime.now(),
            userID: userID,
          )
        ) as List<FitbitSleepData>;
        if(fetchedData.isNotEmpty){
          List<Sleep> toBeInsert = [];
          for(var item in fetchedData){
            toBeInsert.add(Sleep(
              id: null,
              date: item.dateOfSleep!,
              entryDateTime: item.entryDateTime!,
              level: item.level
            ));
          }
          await Provider.of<DatabaseRepository>(context, listen: false).insertSleepData(toBeInsert);
        }
        return fetchedData;
      }
    }
  }

  Future<List<FitbitHeartData>?> _fetchHeartData(BuildContext context, bool isTokenValid) async {
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final heartFromDB = await Provider.of<DatabaseRepository>(context, listen: false).getHeartDataByDate(now);
    if(heartFromDB != null){
      return [FitbitHeartData(minutesPeak: heartFromDB.minutesPeak)];
    } else {
      bool stopQueries = await QueriesCounter.getInstance().check();
      if(stopQueries || !isTokenValid){
        return null;
      } else {
        FitbitHeartDataManager fitbitHeartDataManager = FitbitHeartDataManager(
          clientID: Credentials.getCredentials().id,
          clientSecret: Credentials.getCredentials().secret
        );
        final sp = await SharedPreferences.getInstance();
        final userID = sp.getString('userID');
        final fetchedData = await fitbitHeartDataManager.fetch(
          FitbitHeartAPIURL.dayWithUserID(
            date: DateTime.now(),
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

  // utils
  Future<bool> _isTokenValid() async{
    final stopQueries = await QueriesCounter.getInstance().check();
    if(stopQueries){
      return true;
    } else {
      return await FitbitConnector.isTokenValid();
    }
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
