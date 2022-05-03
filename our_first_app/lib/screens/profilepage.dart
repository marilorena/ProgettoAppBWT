import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:our_first_app/model/bottomnavigationbar.dart';
import 'package:our_first_app/model/darktheme.dart';
import 'package:our_first_app/model/language.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget{
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Consumer<Language>(
      builder: (context, language, child) =>  Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            language.language[3],
            style: const TextStyle(
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
                        title: Text(language.language[4]),
                        leading: const Icon(Icons.settings),
                        onTap: (){
                          Navigator.popAndPushNamed(context, '/profile/');
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/settings/');
                        },
                      ),
                      const Divider(color: Colors.black)
                    ],
                  )
                ),
                PopupMenuItem(
                  child: Consumer<DarkTheme>(
                    builder: (context, darkTheme, child) {
                      return ListTile(
                        title: const Text('Logout'),
                        leading: const Icon(Icons.logout),
                        onTap: (){
                          Navigator.pop(context);
                          Navigator.popAndPushNamed(context, '/login/');
                          darkTheme.darkThemeSwitch(false);
                        }
                      );
                    }
                  )
                )
              ]
            )
          ],
        ),
        bottomNavigationBar: const BottomNavBar()
      ),
    );
  }
}