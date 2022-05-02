import 'package:flutter/material.dart';
import 'package:our_first_app/model/darktheme.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget{
  const SettingsPage({Key? key}) : super(key:key);

@override
Widget build(BuildContext context){
  return Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: const Text(
        'Settings',
        style: TextStyle(
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
            const Text(
              'Dark theme',
              style: TextStyle(fontSize: 18),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(220, 0, 0, 0),
              child: Consumer<DarkTheme>(
                builder: (context, darkTheme, child){
                  return Switch(
                    value: darkTheme.dark,
                    onChanged: (newValue){
                      newValue=!(darkTheme.dark);
                      darkTheme.darkThemeOn(newValue);
                    },
                  );
                }
              ),
            )
          ]
        ),
        const Divider(thickness: 3)
      ],
    )
  );
}
}