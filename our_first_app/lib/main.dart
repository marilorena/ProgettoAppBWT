import 'package:flutter/material.dart';
import 'package:our_first_app/screens/loginpage.dart';
import 'package:our_first_app/screens/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login/',
      routes: {
        '/login/': (context) => const LoginPage(),
        '/home/':(context) => const HomePage(),
      }
    );
  }
}