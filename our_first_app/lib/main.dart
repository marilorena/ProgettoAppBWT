import 'package:flutter/material.dart';
import 'package:our_first_app/model/darktheme.dart';
import 'package:our_first_app/screens/loginpage.dart';
import 'package:our_first_app/screens/homepage.dart';
import 'package:our_first_app/screens/profilepage.dart';
import 'package:our_first_app/secondary_screens/setting.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DarkTheme(),
      builder: (context, child) {
        return Consumer<DarkTheme>(
          builder: (context, darkTheme, child){
            return MaterialApp(
              theme: ThemeData(
              brightness: darkTheme.brightness,
              primarySwatch: Colors.green,
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedItemColor: Colors.green,
                unselectedItemColor: Colors.green,
                selectedLabelStyle: TextStyle(fontSize: 14),
                unselectedLabelStyle: TextStyle(fontSize: 14))),
              initialRoute: '/login/',
              routes: {
                '/login/': (context) => const LoginPage(),
                '/home/': (context) => const HomePage(),
                '/profile/': (context) => const ProfilePage(),
                '/settings/':(context) => const SettingsPage()
              }
            );
          }
        );
      }
    );
  }
}
