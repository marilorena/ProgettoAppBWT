import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:our_first_app/model/yogapose.dart';

class YogaPage extends StatelessWidget{
  const YogaPage({Key? key}) : super(key: key);

get https => null;

 @override 
 Widget build(BuildContext context){
   return Scaffold(
     body: Center(
       child: 
          FutureBuilder(
            future: _fetchPose(),
            builder: (context, snapshot){
              if (snapshot.hasData){
                final pose = snapshot.data as YogaPose;
                return Card(
                      child: Column( 
                            children: [
                              Text(pose.name),
                              Text(pose.sanskrit_name, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green),
                              ),
                              Image.network(pose.image_url)
                            ],
                      ),
                    );
              } else {
                return CircularProgressIndicator();
              }
            }

          )
        
       
      )

   );

 }


Future<YogaPose?> _fetchPose() async {
  final int id = Random().nextInt(10)+1;
  final url = 'https://lightning-yoga-api.herokuapp.com/yoga_poses/:$id';
  final response = await http.get(Uri.parse(url));
  return response.statusCode == 200 ? YogaPose.fromJson(jsonDecode(response.body)): null;
     
}

}