import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:our_first_app/model/yogapose.dart';

class YogaPage extends StatelessWidget{
  const YogaPage({Key? key}) : super(key: key);

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: 
          FutureBuilder(
            future: _fetchPose(),
            builder: (context, snapshot){
              if(snapshot.hasData){
                final pose = snapshot.data as YogaPose;
                return Card(
                  child: Column( 
                    children: [
                      Text(pose.name!),
                      Text(
                        pose.sanskritName!,
                        style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.green)
                      ),
                      
                    ],
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            }
          )
        )
    );
  }

  Future<YogaPose?> _fetchPose() async {
    final int id = Random().nextInt(10)+1;
    final url = 'https://lightning-yoga-api.herokuapp.com/yoga_poses/$id';
    final response = await http.get(Uri.parse(url));
    return response.statusCode==200 ? YogaPose.fromJson(jsonDecode(response.body)): null;
  }
}