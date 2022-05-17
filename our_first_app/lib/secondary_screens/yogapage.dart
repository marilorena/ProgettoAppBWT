import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:our_first_app/model/yogapose.dart';
import 'package:flutter_svg/flutter_svg.dart';

class YogaPage extends StatelessWidget{
  const YogaPage({Key? key}) : super(key: key);


 @override 
 Widget build(BuildContext context){
   
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
                        mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(pose.name),
                              Text(pose.sanskritname, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green),
                              ),
                              SizedBox(height: 15),
                              SvgPicture.network(pose.imageurl)
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

  //Future<void> _fetchImage() async {
  
 //final url = 'https://uc549dab9f5a20837e1793111b7b.dl.dropboxusercontent.com/cd/0/inline2/BlbzVO9n-ugBaXcqjezjxw3IKcrB1Zm2rU-Bnx_82xSf7szRATEvCCGYEsIf8pQLgIN4rRb2WSvPfxHutblHjpWYau-m8dmHsNRaj0hJoufi9hzZHq7q5c6ZEgj5x39xekx9-P6-67aUBG4GSRh552v75sE91KghsGknR6buf6t3Rxz8Z9hPCfrYZAZ6htxyMSPP6yxOt3_P7jd-gOM4OfwxAT5TFcrf4BjSKSDJByKJarjFCg-8NZJGz5Q-kHUJI_e0k4wgF_w25BVWL6aiF1FlEiwde2fS2NNgbLVaqf6kXE1IziVllnGO7BQkUryp9A1IZ1mgz-DLdM8gGF4tfxE6yLe7EydvrbI2cFUtTwnkZVErT05FUg7TSiW68Q8ZHS2evQu0Z6Mrzaz2PrXiGkrkPBBew6k-f7_ORi_7ekK7pg/file';
 // final response = await http.get(Uri.parse(url));
 // print(response.body);

//}

}