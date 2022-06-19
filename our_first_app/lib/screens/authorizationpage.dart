import 'dart:math';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:our_first_app/database/entities/account_entity.dart';
import 'package:our_first_app/database/entities/activity_entity.dart';
import 'package:our_first_app/database/entities/activity_timeseries_entity.dart';
import 'package:our_first_app/database/entities/heart_entity.dart';
import 'package:our_first_app/database/entities/sleep_entity.dart';
import 'package:our_first_app/database/repository/database_repository.dart';
import 'package:our_first_app/utils/client_credentials.dart';
import 'package:our_first_app/utils/queries_counter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthorizationPage extends StatelessWidget {
  const AuthorizationPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => Center(
                  child: Card(
                    elevation: 5,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      height: MediaQuery.of(context).size.height*0.35,
                      width: MediaQuery.of(context).size.width*0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('We\'re going to fetch your data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1, textAlign: TextAlign.center),
                          const SizedBox(height: 10),
                          const Text(
                            'They will be used just for visualization purposes and to retrieve simple possible solutions to improve your wellbeing to advice you with.\nOnly the data which is necessary for this purpose will be stored on the local storage of your smartphone, but never shared with any third-party.',
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 16)
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            child: const Text('Got it', style: TextStyle(fontSize: 18, color: Colors.blue)),
                            onTap: () async{
                              await _authorize(context);
                              await _fetch(context); 
                            }
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              child: const Text('Authorize and fetch', style: TextStyle(fontSize: 18)),
            )
          ]
        ),
      ),
    );
  }

  // data fetching method
  Future<void> _fetchData(BuildContext context) async{
    final sp = await SharedPreferences.getInstance();
    final userID = sp.getString('userID');
    for(var i=0; i<9; i++){
      await QueriesCounter.getInstance().check();
    }
    final stopQueries = await QueriesCounter.getInstance().check(); // x number of queries to do, in this way no data will be fetched if the total number of queries is too much, so it won't happen that some data are fetched and others not
    if(stopQueries){
      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Text('Limit rate of requests exceeded...', style: TextStyle(fontSize: 17, color: Colors.black))
        ),
        backgroundColor: Color.fromARGB(150, 195, 181, 236)
      ));
      return;
    } else {

      // ACCOUNT
      // fetch
      FitbitAccountDataManager fitbitAccountDataManager = FitbitAccountDataManager(
        clientID: Credentials.getCredentials().id,
        clientSecret: Credentials.getCredentials().secret
      );
      final accountData = await fitbitAccountDataManager.fetch(
        FitbitUserAPIURL.withUserID(
          userID: userID
        )
      );
      // save
      final Account account = Account(
        id: null,
        name: accountData[0].toJson()['fullName'],
        age: accountData[0].toJson()['age'],
        avatar: accountData[0].toJson()['avatar'],
        dateOfBirth: accountData[0].toJson()['dateOfBirth'],
        gender: accountData[0].toJson()['gender'],
        height: accountData[0].toJson()['height'],
        legalTermsAcceptRequired: accountData[0].toJson()['legalTermsAcceptRequired'],
        weight: accountData[0].toJson()['weight']
      );
      await Provider.of<DatabaseRepository>(context, listen: false).insertAccount(account);

      // ACTIVITY (only current day)
      // fetch
      FitbitActivityDataManager fitbitActivityDataManager = FitbitActivityDataManager(
        clientID: Credentials.getCredentials().id,
        clientSecret: Credentials.getCredentials().secret
      );
      final activityData = await fitbitActivityDataManager.fetch(
        FitbitActivityAPIURL.day(
          userID: userID,
          date: DateTime.now()
        )
      ) as List<FitbitActivityData>;
      // save
      List<Activity> activityDataList = [];
      for(var item in activityData){
        activityDataList.add(Activity(
          id: null,
          date: item.dateOfMonitoring?? DateTime.fromMillisecondsSinceEpoch(0),
          type: item.name,
          distance: item.distance,
          duration: item.duration,
          startTime: item.startTime?? DateTime.fromMillisecondsSinceEpoch(0),
          calories: item.calories
        ));
      }
      await Provider.of<DatabaseRepository>(context, listen: false).insertActivityData(activityDataList);

      // ACTIVITY TIMESERIES
      // fetch
      FitbitActivityTimeseriesDataManager stepsDataManager = FitbitActivityTimeseriesDataManager(
        clientID: Credentials.getCredentials().id,
        clientSecret: Credentials.getCredentials().secret,
        type: 'steps'
      );
      FitbitActivityTimeseriesDataManager floorsDataManager = FitbitActivityTimeseriesDataManager(
        clientID: Credentials.getCredentials().id,
        clientSecret: Credentials.getCredentials().secret,
        type: 'floors'
      );
      FitbitActivityTimeseriesDataManager minutesSedentaryDataManager = FitbitActivityTimeseriesDataManager(
        clientID: Credentials.getCredentials().id,
        clientSecret: Credentials.getCredentials().secret,
        type: 'minutesSedentary'
      );
      FitbitActivityTimeseriesDataManager minutesLightlyDataManager = FitbitActivityTimeseriesDataManager(
        clientID: Credentials.getCredentials().id,
        clientSecret: Credentials.getCredentials().secret,
        type: 'minutesLightlyActive'
      );
      FitbitActivityTimeseriesDataManager minutesFairlyDataManager = FitbitActivityTimeseriesDataManager(
        clientID: Credentials.getCredentials().id,
        clientSecret: Credentials.getCredentials().secret,
        type: 'minutesFairlyActive'
      );
      FitbitActivityTimeseriesDataManager minutesVeryDataManager = FitbitActivityTimeseriesDataManager(
        clientID: Credentials.getCredentials().id,
        clientSecret: Credentials.getCredentials().secret,
        type: 'minutesVeryActive'
      );
      final stepsData = await stepsDataManager.fetch(
        FitbitActivityTimeseriesAPIURL.weekWithResource(
          userID: userID,
          baseDate: DateTime.now(),
          resource: stepsDataManager.type
        )
      ) as List<FitbitActivityTimeseriesData>;
      final floorsData = await floorsDataManager.fetch(
        FitbitActivityTimeseriesAPIURL.weekWithResource(
          userID: userID,
          baseDate: DateTime.now(),
          resource: floorsDataManager.type
        )
      ) as List<FitbitActivityTimeseriesData>;
      final minutesSedentaryData = await minutesSedentaryDataManager.fetch(
        FitbitActivityTimeseriesAPIURL.weekWithResource(
          userID: userID,
          baseDate: DateTime.now(),
          resource: minutesSedentaryDataManager.type
        )
      ) as List<FitbitActivityTimeseriesData>;
      final minutesLightlyData = await minutesLightlyDataManager.fetch(
        FitbitActivityTimeseriesAPIURL.weekWithResource(
          userID: userID,
          baseDate: DateTime.now(),
          resource: minutesLightlyDataManager.type
        )
      ) as List<FitbitActivityTimeseriesData>;
      final minutesFairlyData = await minutesFairlyDataManager.fetch(
        FitbitActivityTimeseriesAPIURL.weekWithResource(
          userID: userID,
          baseDate: DateTime.now(),
          resource: minutesFairlyDataManager.type
        )
      ) as List<FitbitActivityTimeseriesData>;
      final minutesVeryData = await minutesVeryDataManager.fetch(
        FitbitActivityTimeseriesAPIURL.weekWithResource(
          userID: userID,
          baseDate: DateTime.now(),
          resource: minutesVeryDataManager.type
        )
      ) as List<FitbitActivityTimeseriesData>;
      // save
      List<ActivityTimeseries> activityTimeseriesList = [];
      for(var i=0; i<stepsData.length; i++){
        activityTimeseriesList.add(ActivityTimeseries(
          date: stepsData[i].dateOfMonitoring?? DateTime.fromMillisecondsSinceEpoch(0),
          steps: stepsData[i].value,
          floors: floorsData[i].value,
          minutesSedentary: minutesSedentaryData[i].value,
          minutesLightly: minutesLightlyData[i].value,
          minutesFairly: minutesFairlyData[i].value,
          minutesVery: minutesVeryData[i].value
        ));
      }
      await Provider.of<DatabaseRepository>(context, listen: false).insertActivityTimeseries(activityTimeseriesList);

      // HEART
      // fetch
      FitbitHeartDataManager fitbitHeartDataManager = FitbitHeartDataManager(
        clientID: Credentials.getCredentials().id,
        clientSecret: Credentials.getCredentials().secret
      );
      final heartData = await fitbitHeartDataManager.fetch(
        FitbitHeartAPIURL.weekWithUserID(
          userID: userID,
          baseDate: DateTime.now()
        )
      ) as List<FitbitHeartData>;
      // save
      List<Heart> heartDataList = [];
      for(var item in heartData){
        heartDataList.add(Heart(
          date: item.dateOfMonitoring?? DateTime.fromMillisecondsSinceEpoch(0),
          restingHR: item.restingHeartRate,
          minutesOutOfRange: item.minutesOutOfRange,
          minutesFatBurn: item.minutesFatBurn,
          minutesCardio: item.minutesCardio,
          minutesPeak: item.minutesPeak
        ));
      }
      await Provider.of<DatabaseRepository>(context, listen: false).insertHeartData(heartDataList);

      // SLEEP
      // fetch
      FitbitSleepDataManager fitbitSleepDataManager = FitbitSleepDataManager(
        clientID: Credentials.getCredentials().id,
        clientSecret: Credentials.getCredentials().secret
      );
      final sleepData = await fitbitSleepDataManager.fetch(
        FitbitSleepAPIURL.listWithUserIDAndAfterDate(
          userID: userID,
          afterDate: DateTime.now().subtract(const Duration(days: 7)),
          limit: 7
        )
      ) as List<FitbitSleepData>;
      // save
      List<Sleep> sleepDataList = [];
      for(var item in sleepData){
        sleepDataList.add(Sleep(
          date: item.dateOfSleep?? DateTime.fromMillisecondsSinceEpoch(0),
          entryDateTime: item.entryDateTime?? (item.dateOfSleep?? DateTime.fromMillisecondsSinceEpoch(0)),
          level: item.level
        ));
      }
      await Provider.of<DatabaseRepository>(context, listen: false).insertSleepData(sleepDataList);


      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/home/');
      return;
    }
  }

  // _authorize and _fetch methods
  Future<void> _authorize(BuildContext context)async{
    String? userID = await FitbitConnector.authorize(
      context: context,
      clientID: Credentials.getCredentials().id,
      clientSecret: Credentials.getCredentials().secret,
      redirectUri: 'example://fitbit/auth',
      callbackUrlScheme: 'example'
    );
    final sp = await SharedPreferences.getInstance();
    if(userID != null){
      sp.setString('userID', userID);
    }
  }

  Future<void> _fetch(BuildContext context)async{
    final sp = await SharedPreferences.getInstance();
    if(sp.getString('userID') != null){
      await showDialog(
        context: context,
        builder: (context) => FutureBuilder(
          future: _fetchData(context),
          builder: (context, snapshot){
            return Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Fetching your data...', style: TextStyle(fontSize: 16, color: Colors.black, decoration: TextDecoration.none, fontStyle: FontStyle.normal)),
                    SizedBox(height: 7),
                    Text('(it might take a while)', style: TextStyle(fontSize: 16, color: Colors.black, decoration: TextDecoration.none, fontStyle: FontStyle.normal))
                  ],
                ),
              )
            );
          }
        )
      );
    } else {
      ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Text('To fetch data, please authorize.', style: TextStyle(fontSize: 17, color: Colors.black))
        ),
        backgroundColor: Color.fromARGB(150, 195, 181, 236)
      ));
    }
  }
}
