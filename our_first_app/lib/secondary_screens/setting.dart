import 'package:flutter/material.dart';
import 'package:our_first_app/model/darktheme.dart';
import 'package:our_first_app/model/language.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget{
  const SettingsPage({Key? key}) : super(key:key);

@override
Widget build(BuildContext context){
  return Consumer<Language>(
    builder: (context, language, child) => Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          language.language[4],
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              letterSpacing: 1
          )
        )
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Row(
            children: [
              SizedBox(
                width: 311.7,
                child: Text(
                  language.language[5],
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Consumer<DarkTheme>(
                builder: (context, darkTheme, child){
                  return Switch(
                    value: darkTheme.dark,
                    onChanged: (bool newValue){
                      newValue=!(darkTheme.dark);
                      darkTheme.darkThemeSwitch(newValue);
                    },
                  );
                }
              )
            ]
          ),
          const Divider(thickness: 1),
          Text(language.language[6], style: const TextStyle(fontSize: 18),),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: Row(
              children: [
                const SizedBox(
                  width: 311.7,
                  child: Text(
                    'English',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Radio(
                  value: language.cond,
                  groupValue: false,
                  toggleable: true,
                  onChanged: (newCond){
                    language.switchLanguage(false);
                  },
                ),
              ]
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              children: [
                const SizedBox(
                  width: 311.7,
                  child: Text(
                    'Italiano',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Radio(
                  value: !language.cond,
                  groupValue: false,
                  toggleable: true,
                  onChanged: (newCond){
                    language.switchLanguage(true);
                  },
                ),
              ]
            ),
          )
        ],
      )
    ),
  );
}
}