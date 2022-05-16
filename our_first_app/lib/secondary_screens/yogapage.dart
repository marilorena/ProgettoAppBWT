import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:our_first_app/model/yogapose.dart';

class YogaPage extends StatelessWidget{
  const YogaPage({Key? key}) : super(key: key);


 @override 
 Widget build(BuildContext context){
   _fetchImage();
   return Scaffold(
     body: Center(
       child: 
          FutureBuilder(
            future: _fetchPose(1),
            builder: (context, snapshot){
              if (snapshot.hasData){
                final pose = snapshot.data as YogaPose;
                return Card(
                      child: Column( 
                            children: [
                              Text(pose.name),
                              Text(pose.sanskritname, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green),
                              ),
                              Image.network(pose.imageurl)
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

 Future<YogaPose?> _fetchPose(int id) async {
  
  final url = 'https://lightning-yoga-api.herokuapp.com/yoga_poses/$id';
  final response = await http.get(Uri.parse(url));
  return response.statusCode == 200 ? YogaPose.fromJson(jsonDecode(response.body)): null;
  
 }
  Future<void> _fetchImage() async {
  
  final url = 'https://www.dropbox.com/s/4m64ztxkj8a4dab/boatstraightlegs.svg?raw=1';
  final response = await http.get(Uri.parse(url));
  print(response.body);

}

}