import 'package:flutter/material.dart';

class Language extends ChangeNotifier{
  bool cond = false;
  final List<String> eng = ['Login to continue', 'username', 'Wrong credentials', 'Profile', 'Settings', 'Night mode', 'Language'];
  final List<String> ita = ['Accedi per continuare', 'nome utente', 'Credenziali errate', 'Profilo', 'Impostazioni', 'Modalità notte', 'Lingua'];
  List<String> language = ['Login to continue', 'username', 'Wrong credentials', 'Profile', 'Settings', 'Night mode', 'Language'];

  void switchLanguage(bool newCond){
    cond = newCond;
    if(cond==false){
      language = eng;
    }else{
      language = ita;
    }
    notifyListeners();
  }
}