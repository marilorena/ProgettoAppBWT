import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Targets extends ChangeNotifier{
  double steps;
  double floors;

  Targets({required this.steps, required this.floors});

  void updateSteps(double value) async{
    steps = value;
    final sp = await SharedPreferences.getInstance();
    sp.setInt('steps', value.toInt());
    notifyListeners();
  }

  void updateFloors(double value) async{
    floors = value;
    final sp = await SharedPreferences.getInstance();
    sp.setInt('floors', value.toInt());
    notifyListeners();
  }
}