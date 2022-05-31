import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// to finish after the creation of the database

class ActivitySettings extends StatefulWidget{
  const ActivitySettings({Key? key}) : super(key: key);

  @override
  State<ActivitySettings> createState() => _ActivitySettingsState();
}

class _ActivitySettingsState extends State<ActivitySettings> {
  double _stepsTarget = 5000;
  double _floorsTarget = 1;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Set your activity targets')
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width*0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Daily steps\' target:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 5),
              Slider(
                value: _stepsTarget,
                onChanged: (value) async{
                  setState(() {
                    _stepsTarget = value;
                  });
                  final sp = await SharedPreferences.getInstance();
                  sp.setDouble('steps', _stepsTarget);
                },
                min: 5000,
                max: 50000,
                divisions: 9,
                label: '${_stepsTarget.toInt()}'
              ),
              const SizedBox(height: 50),
              const Text('Daily floors\' target:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 5),
              Slider(
                value: _floorsTarget,
                onChanged: (value) async{
                  setState(() {
                    _floorsTarget = value;
                  });
                  final sp = await SharedPreferences.getInstance();
                  sp.setDouble('floors', _floorsTarget);
                },
                min: 1,
                max: 100,
                divisions: 10,
                label: '${_floorsTarget.toInt()}'
              )
            ],
          ),
        )
      )
    );
  }
}