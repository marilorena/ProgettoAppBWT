import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:our_first_app/utils/queries_counter.dart';
import 'package:our_first_app/utils/client_credentials.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  child: ListTile(
                    title: const Text('Logout'),
                    leading: const Icon(Icons.logout),
                    onTap: () => _toLoginPage(context), 
                  ),
                ),
              ],
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
                label: 'Profile'
              )
            ],
            currentIndex: 1,
            selectedItemColor: Colors.green,
            unselectedLabelStyle: const TextStyle(fontSize: 14)
          )
      );
  }
  
  void _toLoginPage(BuildContext context) async{ 
    final sp = await SharedPreferences.getInstance();
    sp.remove('username');
    sp.remove('userID');

    Navigator.pop(context);
    Navigator.popAndPushNamed(context, '/login/');
    final credentials = Credentials.getCredentials();
    await FitbitConnector.unauthorize(
      clientID: credentials.id,
      clientSecret: credentials.secret
    );

    QueriesCounter.getInstance().stop();
  }
}