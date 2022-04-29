import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfilePage extends StatefulWidget{
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 1
          )
        ),
      ),
      body: GestureDetector(
        child: Container(
          child: const Text('Logout', style: TextStyle(fontSize: 18)),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 2),
            borderRadius: BorderRadius.circular(12)
          ),
        ),
        onTap: (){
          Navigator.popAndPushNamed(context, '/login/');
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(MdiIcons.home),
              onPressed: (){
                Navigator.popAndPushNamed(context, '/home/');
              },
            ),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(MdiIcons.account),
              onPressed: (){
                Navigator.popAndPushNamed(context, '/profile/');
              },
            ),
            label: 'Profile'
          )
        ]
      )
    );
  }
}