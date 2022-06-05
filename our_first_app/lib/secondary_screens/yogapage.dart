import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:our_first_app/model/yogapose.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';



final FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManager = FitbitActivityTimeseriesDataManager(clientID: '238BR6', clientSecret: '447a1a825a0ff1846b3b3f35024dd7d4');
  

class YogaPage extends StatelessWidget{
  const YogaPage({Key? key}) : super(key: key);


 @override 
 Widget build(BuildContext context){

   
   return Scaffold(
     body: Center(
       child: FutureBuilder(
         
          future: _fetchPose(),
          builder: (context, snapshot){
            if (snapshot.hasData){
              final pose = snapshot.data as YogaPose;
              return Card(
                shadowColor: Color.fromARGB(0, 190, 228, 193),
                color: Color.fromARGB(255, 224, 245, 223),
                elevation: 5,
                child: Padding(
                padding: const EdgeInsets.all(50),
                child: FittedBox(
                  child: 
                     Column( 
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(pose.name),
                          Text(pose.sanskritName, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green)),
                          SizedBox(height: 15),
                          SvgPicture.network(pose.imageUrl, height: 250),
                        ],
                      ),
                  ),
                  )
                
              );
            } else {
              return CircularProgressIndicator();
            }
          }  
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back),
        backgroundColor: Colors.green
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
    
    
  }

  Future<YogaPose?> _fetchPose() async {
    final steps = await _fetchSteps();
    double NumOfSteps = steps[0].value?? 0;
    int? id;
    if(NumOfSteps > 20000){
        id = 2;
    }else if(NumOfSteps < 20000 && NumOfSteps > 15000){
      id = 8;
    }else if(NumOfSteps < 15000 && NumOfSteps > 10000){
      id = 27;
    } else if(NumOfSteps < 10000 && NumOfSteps > 5000){
      id = 39;
    } else if (NumOfSteps < 5000){
      id = 5;
    }

    if (id != null) {final url = 'https://lightning-yoga-api.herokuapp.com/yoga_poses/$id';
    final response = await http.get(Uri.parse(url));
    return response.statusCode == 200 ? YogaPose.fromJson(jsonDecode(response.body)): null;
    } 
    else { return null;}
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
}