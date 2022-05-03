import 'package:flutter/material.dart';
import 'package:our_first_app/model/darktheme.dart';
import 'package:our_first_app/model/language.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DarkTheme>(create: (context) => DarkTheme()),
        ChangeNotifierProvider<Language>(create: (context) => Language())
      ],
      builder: (context, child) {
        return Consumer<DarkTheme>(
          builder: (context, darkTheme, child){
            return MaterialApp(
              theme: ThemeData(
                brightness: darkTheme.brightness,
                primarySwatch: Colors.green
              ),
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
