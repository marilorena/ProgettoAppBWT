import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// to finish after the creation of the database

class ActivitySettings extends StatefulWidget{
  const ActivitySettings({Key? key}) : super(key: key);

  @override
  State<ActivitySettings> createState() => _ActivitySettingsState();
}

class _ActivitySettingsState extends State<ActivitySettings> {
  final double _stepsTarget = 5000;
  final double _floorsTarget = 1;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Set your activity targets')
      ),
      body: Center(
        child: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              final sp = snapshot.data as SharedPreferences;
              return SizedBox(
                width: MediaQuery.of(context).size.width*0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Daily steps\' target:', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 5),
                    Slider(
                      value: sp.getInt('steps') == null ? _stepsTarget : sp.getInt('steps')! + .0,
                      onChanged: (value){
                        sp.setInt('steps', value.toInt());
                        setState((){});
                      },
                      min: 5000,
                      max: 50000,
                      divisions: 9,
                      label: sp.getInt('steps').toString()
                    ),
                    const SizedBox(height: 50),
                    const Text('Daily floors\' target:', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 5),
                    Slider(
                      value: sp.getInt('floors') == null ? _floorsTarget : sp.getInt('floors')! + .0,
                      onChanged: (value){
                        sp.setInt('floors', value.toInt());
                        setState((){});
                      },
                      min: 1,
                      max: 100,
                      divisions: 10,
                      label: sp.getInt('floors').toString()
                    )
                  ],
                ),
              );
            } else {
              return Container();
            }
          }
        )
      )
    );
  }
}