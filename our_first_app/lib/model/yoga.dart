import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:our_first_app/secondary_screens/yogapage.dart';
import 'package:fitbitter/fitbitter.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:our_first_app/model/yogapose.dart';
import 'package:our_first_app/secondary_screens/yogapage.dart';

final FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManager = FitbitActivityTimeseriesDataManager(clientID: '238BR6', clientSecret: '447a1a825a0ff1846b3b3f35024dd7d4');
  


class Yoga extends ChangeNotifier{
  
  Future<YogaPose?> showImageNew(int steps) async {
       if (steps > 20000){
         return await _fetchPose(1);
       }else if(steps < 20000 && steps > 15000){
         return await _fetchPose(2);
       }

  }

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

   Future<YogaPose?> _fetchPose(int id) async {
    final url = 'https://lightning-yoga-api.herokuapp.com/yoga_poses/$id';
    final response = await http.get(Uri.parse(url));
    return response.statusCode == 200 ? YogaPose.fromJson(jsonDecode(response.body)): null;
  }






  