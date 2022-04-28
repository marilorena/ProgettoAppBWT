import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 3
          )
        ),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              Navigator.popAndPushNamed(context, '/profile/');
            },
            icon: const CircleAvatar(child: Icon(MdiIcons.account))
          )
        ],
      )
    );
  }
}