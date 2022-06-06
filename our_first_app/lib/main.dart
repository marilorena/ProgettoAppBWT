import 'package:flutter/material.dart';
import 'package:our_first_app/screens/authorizationpage.dart';
import 'package:our_first_app/screens/loginpage.dart';
import 'package:our_first_app/screens/homepage.dart';
import 'package:our_first_app/screens/profilepage.dart';
import 'package:our_first_app/secondary_screens/activitypage.dart';
import 'package:our_first_app/secondary_screens/activitysettingspage.dart';
import 'package:our_first_app/secondary_screens/heartpage.dart';
import 'package:our_first_app/secondary_screens/sleeppage.dart';
import 'package:our_first_app/secondary_screens/yogapage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _whenOpening(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          final sp = snapshot.data as SharedPreferences;
          return MaterialApp(
            theme: ThemeData(
              colorSchemeSeed: const Color.fromARGB(255, 153, 254, 185),
            ),
            initialRoute: sp.getString('username') != null ? '/home/' : '/login/',
            routes: {
              '/login/': (context) => const LoginPage(),
              '/home/': (context) => const HomePage(),
              '/profile/': (context) => const ProfilePage(),
              '/authorization/': (context) => const AuthorizationPage(),
              '/yoga/': (context) => const YogaPage(),
              '/heart/': (context) => const HeartPage(),
              '/activity/': (context) => const ActivityPage(),
              '/sleep/': (context) => const SleepPage(),
              '/activitysettings/': (context) => const ActivitySettings()
            }
          );
        } else {
          return Container(color:Colors.white, child: Center(child: Image.asset('asset/icons/icon_launcher.png', height: 100)));
        }
      }
    );
  }

  Future<SharedPreferences> _whenOpening() async{
    await Future.delayed(const Duration(milliseconds: 1500));
    return await SharedPreferences.getInstance();
  }
}
