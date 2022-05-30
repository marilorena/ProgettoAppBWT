import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:our_first_app/model/yogapose.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../model/yoga.dart';

class YogaPage extends StatelessWidget{
  const YogaPage({Key? key}) : super(key: key);


 @override 
 Widget build(BuildContext context){

   
   return Scaffold(
     body: Center(
       child: FutureBuilder(
         
          future: _fetchPose(${id}),
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
                  child: Consumer<Yoga>( builder: (context, Yoga, child) => 
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }

  Future<YogaPose?> _fetchPose(int id) async {
    final url = 'https://lightning-yoga-api.herokuapp.com/yoga_poses/$id';
    final response = await http.get(Uri.parse(url));
    return response.statusCode == 200 ? YogaPose.fromJson(jsonDecode(response.body)): null;
  }
}