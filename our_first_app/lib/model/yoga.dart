import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:our_first_app/secondary_screens/yogapage.dart';
import 'package:fitbitter/fitbitter.dart';
import 'dart:math';


final FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManager = FitbitActivityTimeseriesDataManager(clientID: '238BR6', clientSecret: '447a1a825a0ff1846b3b3f35024dd7d4');
  


class yoga extends ChangeNotifier{
  List<YogaPage> PoseImg = [];
  Future <void> showImage(YogaPage tooAdd) async {
       final steps = await _fetchSteps();
       int NumOfSteps = steps as int;
       if (NumOfSteps > 20000){
         PoseImg.add(tooAdd);
        notifyListeners();
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






  