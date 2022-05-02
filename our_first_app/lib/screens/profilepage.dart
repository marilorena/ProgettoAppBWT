import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfilePage extends StatelessWidget{
  const ProfilePage({Key? key}) : super(key: key);

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
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Settings'),
                      leading: const Icon(Icons.settings),
                      onTap: (){Navigator.pushNamed(context, '/settings/');},
                    ),
                    const Divider(color: Colors.black)
                  ],
                )
              ),
              PopupMenuItem(
                child: ListTile(
                  title: const Text('Logout'),
                  leading: const Icon(Icons.logout),
                  onTap: () => Navigator.popAndPushNamed(context, '/login/'),
                )
              )
            ]
          )
        ],
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