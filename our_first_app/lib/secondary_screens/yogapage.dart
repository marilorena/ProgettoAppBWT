import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:our_first_app/model/yogapose.dart';

class YogaPage extends StatelessWidget{
  const YogaPage({Key? key}) : super(key: key);

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _fetchPose(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              final pose = snapshot.data as YogaPose;
              return Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: FittedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          pose.name!,
                          style: const TextStyle(fontSize: 18)
                        ),
                        const SizedBox(height: 3),
                        Text(
                          pose.sanskritName!,
                          style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.green)
                        ),
                        const SizedBox(height: 15),
                        SvgPicture.network(pose.imageUrl!, height: 250)
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const CircularProgressIndicator();
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

  Future<YogaPose?> _fetchPose() async {
    final int id = Random().nextInt(10)+1;
    final url = 'https://lightning-yoga-api.herokuapp.com/yoga_poses/$id';
    final response = await http.get(Uri.parse(url));
    return response.statusCode==200 ? YogaPose.fromJson(jsonDecode(response.body)): null;
  }
}