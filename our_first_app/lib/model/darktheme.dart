import 'package:flutter/material.dart';

class DarkTheme extends ChangeNotifier{
  bool dark = false;
  Brightness brightness = Brightness.light;

  void darkThemeSwitch(bool newValue){
    dark = newValue;
    if(dark==false){
      brightness=Brightness.light;
    }else{
      brightness=Brightness.dark;
    }
    notifyListeners();
  }
}