import 'dart:convert';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:our_first_app/model/yogapose.dart';
import 'package:our_first_app/utils/client_credentials.dart';
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
              return ListView.builder(
                cacheExtent: 0,
                scrollDirection: Axis.horizontal,
                itemCount: poses.length,
                itemBuilder: (context, index) => Column( 
                  crossAxisAlignment: CrossAxisAlignment.center, 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Based on your recent activity, here are 3 suggested yoga poses for you',
                      textAlign: TextAlign.center,
                      style: TextStyle(height: 10)
                    ),
                    Card(
                      margin: const EdgeInsets.only(left: 25, top: 50, bottom: 100, right: 30),
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

  Future<List<YogaPose>> _fetchPose() async{
    final steps = await _fetchSteps();
    double numOfSteps = steps[0].value ?? 0;
    List<int> id = [];
    if (numOfSteps > 20000){
      id = [18, 4, 12];
    } else if (numOfSteps <= 20000 && numOfSteps > 15000){
      id = [9, 6, 14];
    } else if (numOfSteps <= 15000 && numOfSteps > 10000){
      id = [21, 23, 41];
    } else if (numOfSteps <= 10000 && numOfSteps > 5000){
      id = [15, 20, 24];
    } else if (numOfSteps <= 5000){
      id = [10, 28, 30];
    }

    List<YogaPose> poses = [];
    for(var item in id){
      final url = 'https://lightning-yoga-api.herokuapp.com/yoga_poses/$item';
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        poses.add(YogaPose.fromJson(jsonDecode(response.body)));
      }
    }
    return poses;
  }

  Future<List<FitbitActivityTimeseriesData>> _fetchSteps() async {
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
