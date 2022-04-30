import 'package:flutter/material.dart';
import 'package:our_first_app/screens/loginpage.dart';
import 'package:our_first_app/screens/homepage.dart';
import 'package:our_first_app/screens/profilepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.green,
          selectedLabelStyle: TextStyle(fontSize: 14),
          unselectedLabelStyle: TextStyle(fontSize: 14)
        )   
      ),
    initialRoute: '/login/',
      routes: {
        '/login/': (context) => const LoginPage(),
        '/home/': (context) => const HomePage(),
        '/profile/': (context) => const ProfilePage(),
      }
    );
  
    
     
  }
}