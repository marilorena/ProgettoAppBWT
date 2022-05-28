import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:our_first_app/model/darktheme.dart';
import 'package:our_first_app/model/language.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                        onTap: () => _toLoginPage(context), 
                      );
                    }
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
                  icon: const Icon(Icons.home),
                  onPressed: (){
                    Navigator.popAndPushNamed(context, '/home/');
                  },
                ),
                label: 'Home'
              ),
              BottomNavigationBarItem(
                icon: IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: (){
                    Navigator.popAndPushNamed(context, '/profile/');
                  },
                ),
                label: language.language[3]
              )
            ],
            currentIndex: 1,
            selectedItemColor: Colors.green,
            unselectedLabelStyle: const TextStyle(fontSize: 14)
          )
      ),
    );
  }
  
  void _toLoginPage(BuildContext context) async{ 
    final sp = await SharedPreferences.getInstance();
    sp.remove('username');    
    Navigator.pop(context);
    Navigator.popAndPushNamed(context, '/login/');
    await FitbitConnector.unauthorize(
                    clientID:'238BR6',
                    clientSecret: '447a1a825a0ff1846b3b3f35024dd7d4');
  }
}