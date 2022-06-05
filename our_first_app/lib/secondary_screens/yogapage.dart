import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:our_first_app/model/yogapose.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

final FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManager =
    FitbitActivityTimeseriesDataManager(
        clientID: '238BR6', clientSecret: '447a1a825a0ff1846b3b3f35024dd7d4');

class YogaPage extends StatelessWidget {
  const YogaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: FutureBuilder(
                future: _fetchPose(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final poses = snapshot.data as List<YogaPose?>;
                    return ListView.builder(
                      
                      cacheExtent: 0,
                      scrollDirection: Axis.horizontal,
                      itemCount: poses.length,
                      itemBuilder: (context, index) => Column( 
                        crossAxisAlignment: CrossAxisAlignment.center, 
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [ Text('Based on your activity these are the 3 poses for you', textAlign: TextAlign.center, style: TextStyle(height: 10)),
                          Card(
                              margin: EdgeInsets.only(
                                  left: 25, top: 50, bottom: 100, right: 30),
                              shadowColor: Color.fromARGB(0, 190, 228, 193),
                              color: Color.fromARGB(255, 224, 245, 223),
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(50),
                                child: FittedBox(
                                  child: Column(
                                   // mainAxisAlignment: MainAxisAlignment.center,
                                   // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(poses[index]!.name),
                                      Text(poses[index]!.sanskritName,
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.green)),
                                      SizedBox(height: 15),
                                      SvgPicture.network(poses[index]!.imageUrl,
                                          height: 250),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                })),
        floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back),
            backgroundColor: Colors.green),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  Future<List<YogaPose?>> _fetchPose() async {
    final steps = await _fetchSteps();
    double NumOfSteps = steps[0].value ?? 0;
    List<int?> id = [];
    if (NumOfSteps > 20000) {
      id = [18, 4, 12];
    } else if (NumOfSteps < 20000 && NumOfSteps > 15000) {
      id = [9, 6, 14];
    } else if (NumOfSteps < 15000 && NumOfSteps > 10000) {
      id = [21, 23, 41];
    } else if (NumOfSteps < 10000 && NumOfSteps > 5000) {
      id = [15, 20, 24];
    } else if (NumOfSteps < 5000) {
      id = [10, 28, 30];
    }

    if (id.isEmpty) {
      return [];
    } else {
      final url1 =
          'https://lightning-yoga-api.herokuapp.com/yoga_poses/${id[0]}';
      final url2 =
          'https://lightning-yoga-api.herokuapp.com/yoga_poses/${id[1]}';
      final url3 =
          'https://lightning-yoga-api.herokuapp.com/yoga_poses/${id[2]}';
      final response = await http.get(Uri.parse(url1));
      final response1 = await http.get(Uri.parse(url2));
      final response2 = await http.get(Uri.parse(url3));
      final r1 = response.statusCode == 200
          ? YogaPose.fromJson(jsonDecode(response.body))
          : null;
      final r2 = response1.statusCode == 200
          ? YogaPose.fromJson(jsonDecode(response1.body))
          : null;
      final r3 = response2.statusCode == 200
          ? YogaPose.fromJson(jsonDecode(response2.body))
          : null;
      return [r1, r2, r3];
    }
  }

  Future<List<FitbitActivityTimeseriesData>> _fetchSteps() async {
    return await fitbitActivityTimeseriesDataManager
        .fetch(FitbitActivityTimeseriesAPIURL.dayWithResource(
      date: DateTime.now().subtract(Duration(days: 0)),
      userID: '7ML2XV',
      resource: 'steps',
    )) as List<FitbitActivityTimeseriesData>;
  }
}
