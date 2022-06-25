import 'package:flutter/material.dart';
import 'package:our_first_app/database/database.dart';
import 'package:our_first_app/database/repository/database_repository.dart';
import 'package:our_first_app/model/targets.dart';
import 'package:our_first_app/screens/authorizationpage.dart';
import 'package:our_first_app/screens/loginpage.dart';
import 'package:our_first_app/screens/homepage.dart';
import 'package:our_first_app/screens/profilepage.dart';
import 'package:our_first_app/secondary_screens/activitypage.dart';
import 'package:our_first_app/secondary_screens/activitysettingspage.dart';
import 'package:our_first_app/secondary_screens/heartpage.dart';
import 'package:our_first_app/secondary_screens/flowerpage.dart';
import 'package:our_first_app/secondary_screens/sleeppage.dart';
import 'package:our_first_app/secondary_screens/yogapage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final AppDatabase database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  final databaseRepository = DatabaseRepository(database: database);

  final sp = await SharedPreferences.getInstance();
  final stepsTarget = sp.getInt('steps')?? 5000;
  final floorsTarget = sp.getInt('floors')?? 1;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<DatabaseRepository>(create: (context) => databaseRepository),
      ChangeNotifierProvider<Targets>(create: (context) => Targets(steps: stepsTarget+.0, floors: floorsTarget+.0))
    ],
    child: const MyApp()));
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
              '/activitysettings/': (context) => const ActivitySettings(),
              '/flower/' : (context) =>  const Coins()
            }
          );
        } else {
          return Container(color:Colors.white, child: Center(child: Image.asset('asset/icons/icon_launcher.png', height: 100)));
        }
      }
    );
  }

  Future<SharedPreferences> _whenOpening() async{
    await Future.delayed(const Duration(seconds: 1));
    return await SharedPreferences.getInstance();
  }
}
