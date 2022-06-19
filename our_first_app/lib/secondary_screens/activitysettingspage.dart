import 'package:flutter/material.dart';
import 'package:our_first_app/model/targets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// to finish after the creation of the database

class ActivitySettings extends StatelessWidget{
  const ActivitySettings({Key? key}) : super(key: key);

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
                child: Consumer<Targets>(
                  builder: (context, targets, child) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Daily steps\' target:', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 5),
                      Slider(
                        value: targets.steps,
                        onChanged: (value){
                          targets.updateSteps(value);
                        },
                        min: 5000,
                        max: 50000,
                        divisions: 9,
                        label: targets.steps.toString()
                      ),
                      const SizedBox(height: 50),
                      const Text('Daily floors\' target:', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 5),
                      Slider(
                        value: targets.floors,
                        onChanged: (value){
                          targets.updateFloors(value);
                        },
                        min: 1,
                        max: 100,
                        divisions: 10,
                        label: targets.floors.toString()
                      )
                    ],
                  ),
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