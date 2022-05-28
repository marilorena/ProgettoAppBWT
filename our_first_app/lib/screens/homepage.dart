import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:our_first_app/model/language.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color col = Color.fromARGB(150, 53, 196, 84);

  final FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManager = FitbitActivityTimeseriesDataManager(clientID: '238BR6', clientSecret: '447a1a825a0ff1846b3b3f35024dd7d4');
  
  
  final FitbitHeartDataManager fitbitHeartDataManager = FitbitHeartDataManager(clientID: '238BR6', clientSecret: '447a1a825a0ff1846b3b3f35024dd7d4');

  final FitbitSleepDataManager fitbitSleepDataManager = FitbitSleepDataManager(clientID: '238BR6', clientSecret: '447a1a825a0ff1846b3b3f35024dd7d4');
  
  
  @override
  Widget build(BuildContext context) {
    return Consumer<Language>(
      builder: (context, language, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(150, 195, 181, 236),
          centerTitle: true,
          title: const Text(
            'Home',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 27,
              letterSpacing: 1,
            )
          )
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('asset/sfondo5.jpg'),
              fit: BoxFit.fitHeight
            )
          ),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(25, 50, 25, 25),
            children: [
              GestureDetector(
                child: Container(
                  width: 320,
                  height: 100,
                  child: const Icon(
                    MdiIcons.heartPulse,
                    size: 50, color: Colors.white
                  ),
                  decoration: BoxDecoration(
                    color: col,
                    borderRadius: BorderRadius.circular(45),
                  ),
                ),
                onTap: () async {
                  final heart = await _fetchRate();
                  
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: Container(
                          height: 450,
                          width: 350,
                          color: Color.fromARGB(255, 225, 255, 203),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              const Text(
                                'Heart Rate',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black,
                                  decoration: TextDecoration.none
                                ),
                              ),
                              Text(
                                'Your resting heart rate is ${heart[0].restingHeartRate} bpm',
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black,
                                  decoration: TextDecoration.none
                                )
                              ),
                              Text(
                                'Minutes Out of Range ${heart[0].minutesOutOfRange} ',
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black,
                                  decoration: TextDecoration.none
                                )
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  );
                }
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 3,
                ),
              ),
              GestureDetector(
                child: Container(
                  width: 320,
                  height: 100,
                  child: const Icon(
                    MdiIcons.run,
                    size: 50,
                    color: Colors.white
                  ),
                  decoration: BoxDecoration(
                    color: col,
                    borderRadius: BorderRadius.circular(45),
                  ),
                ),
                onTap: () async {
                  final steps = await _fetchSteps();
                  final floors = await _fetchFloors();
                  final calories = await _fetchCalories();
                  final distance = await _fetchDistance();
                  final minutesSedentary = await _fetchSedentary();
                  final minutesLight= await _fetchLight();
                  final minutesFairly= await _fetchFairly();
                  final minutesVery = await _fetchVery();
              
          
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: Container(
                          height: 450,
                          width: 350,
                          color: Color.fromARGB(255, 225, 255, 203),
                          child: Column(
                            children: [
                            const SizedBox(height: 20),
                            const Text(
                              'Activity',
                              style: TextStyle(
                                fontSize: 30,
                                fontStyle: FontStyle.italic,
                                color: Colors.black,
                                decoration: TextDecoration.none
                              ),
                            ),
                            Text(
                              'Today you walked ${steps[0].value} steps',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                decoration: TextDecoration.none
                              ),
                            ),
                            Text(
                                'Today you walked for ${distance[0].value} km',
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black,
                                  decoration: TextDecoration.none
                                )
                              )
                        
                          ],
                        ),
                      ),
                    );
                  }
                );
              }
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                thickness: 3,
              ),
            ),
            GestureDetector(
              child: Container(
                width: 320,
                height: 100,
                child: const Icon(
                  MdiIcons.bed,
                  size: 50,
                  color: Colors.white
                ),
                decoration: BoxDecoration(
                  color: col,
                  borderRadius: BorderRadius.circular(45),
                ),
              ),
              onTap: () async {
                final sleep = await _fetchSleep();
                
                showDialog(
                  context: context,
                  builder: (context) {
                  return Center(
                    child: Container(
                      height: 450,
                      width: 350,
                      color: Color.fromARGB(255, 225, 255, 203),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          const Text(
                            'Sleep',
                            style: TextStyle(
                              fontSize: 30,
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                              decoration: TextDecoration.none
                            ),
                          ),
                          Text(
                            'You slept for ${sleep[0].dateOfSleep}'
                          )
                        ],
                      ),
                    ),
                  );
                }
              );
            }
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(
              thickness: 3,
            ),
          ),
          GestureDetector(
            child: Container(
              width: 320,
              height: 100,
              decoration: BoxDecoration(
                color: col,
                borderRadius: BorderRadius.circular(45),
                image: const DecorationImage(
                  image: AssetImage(
                    'asset/icons/icon_launcher_adaptive_fore.png'
                  ),
                  fit: BoxFit.none,
                  scale: 3.5
                )
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/yoga/');
            }
          ),
        ]
      ),
    ),
    bottomNavigationBar: BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: IconButton(
            icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.popAndPushNamed(context, '/home/');
              },
            ),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/profile/');
                },
              ),
              label: language.language[3]
            )
          ],
          currentIndex: 0,
          selectedItemColor: Colors.green,
          unselectedLabelStyle: const TextStyle(fontSize: 14)
        )
      ),
    );
  }

  Future<List<FitbitActivityTimeseriesData>> _fetchSteps() async {
    return await fitbitActivityTimeseriesDataManager.fetch(
      FitbitActivityTimeseriesAPIURL.dayWithResource(
        date: DateTime.now().subtract(Duration(days: 0)),
        userID: '7ML2XV',
        resource: 'steps',
      )
    ) as List<FitbitActivityTimeseriesData>;
  }

   Future<List<FitbitActivityTimeseriesData>> _fetchFloors() async {
    return await fitbitActivityTimeseriesDataManager.fetch(
      FitbitActivityTimeseriesAPIURL.dayWithResource(
        date: DateTime.now().subtract(Duration(days: 0)),
        userID: '7ML2XV',
        resource: 'floors',
      )
    ) as List<FitbitActivityTimeseriesData>;
  }

   Future<List<FitbitActivityTimeseriesData>> _fetchCalories() async {
    return await fitbitActivityTimeseriesDataManager.fetch(
      FitbitActivityTimeseriesAPIURL.dayWithResource(
        date: DateTime.now().subtract(Duration(days: 0)),
        userID: '7ML2XV',
        resource: 'activityCalories',
      )
    ) as List<FitbitActivityTimeseriesData>;
  }
     Future<List<FitbitActivityTimeseriesData>> _fetchDistance() async {
    return await fitbitActivityTimeseriesDataManager.fetch(
      FitbitActivityTimeseriesAPIURL.dayWithResource(
        date: DateTime.now().subtract(Duration(days: 0)),
        userID: '7ML2XV',
        resource: 'distance',
      )
    ) as List<FitbitActivityTimeseriesData>;
  }
     Future<List<FitbitActivityTimeseriesData>> _fetchSedentary() async {
    return await fitbitActivityTimeseriesDataManager.fetch(
      FitbitActivityTimeseriesAPIURL.dayWithResource(
        date: DateTime.now().subtract(Duration(days: 0)),
        userID: '7ML2XV',
        resource: 'minutesSedentary',
      )
    ) as List<FitbitActivityTimeseriesData>;
  }
     Future<List<FitbitActivityTimeseriesData>> _fetchLight() async {
    return await fitbitActivityTimeseriesDataManager.fetch(
      FitbitActivityTimeseriesAPIURL.dayWithResource(
        date: DateTime.now().subtract(Duration(days: 0)),
        userID: '7ML2XV',
        resource: 'minutesLightlyActive',
      )
    ) as List<FitbitActivityTimeseriesData>;
  }
     Future<List<FitbitActivityTimeseriesData>> _fetchFairly() async {
    return await fitbitActivityTimeseriesDataManager.fetch(
      FitbitActivityTimeseriesAPIURL.dayWithResource(
        date: DateTime.now().subtract(Duration(days: 0)),
        userID: '7ML2XV',
        resource: 'minutesFairlyActive',
      )
    ) as List<FitbitActivityTimeseriesData>;
  }
     Future<List<FitbitActivityTimeseriesData>> _fetchVery() async {
    return await fitbitActivityTimeseriesDataManager.fetch(
      FitbitActivityTimeseriesAPIURL.dayWithResource(
        date: DateTime.now().subtract(Duration(days: 0)),
        userID: '7ML2XV',
        resource: 'minutesVeryActive',
      )
    ) as List<FitbitActivityTimeseriesData>;
  }
  Future<List<FitbitHeartData>> _fetchRate() async {
    return await fitbitHeartDataManager.fetch(
      FitbitHeartAPIURL.dayWithUserID(
        date: DateTime.now().subtract(Duration(days: 0)),
        userID: '7ML2XV',
      )
    ) as List<FitbitHeartData>;  
  }

  Future<List<FitbitSleepData>> _fetchSleep() async {
    return await fitbitSleepDataManager.fetch(
      FitbitSleepAPIURL.withUserIDAndDay(
        date: DateTime.now().subtract(Duration(days: 1)),
      userID: '7ML2XV',
      )
    ) as List<FitbitSleepData>;
  }
}
