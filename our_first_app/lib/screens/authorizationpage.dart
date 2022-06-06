import 'package:flutter/material.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:our_first_app/utils/client_credentials.dart';
import 'package:our_first_app/utils/queries_counter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthorizationPage extends StatelessWidget {
  const AuthorizationPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await _authorize(context);
                await _fetch(context); 
              },
              child: const Text('Authorize and fetch', style: TextStyle(fontSize: 18)),
            )
          ]
        ),
      ),
    );
  }

  // data fetching methods
  Future<void> _fetchAccount(BuildContext context)async{
    // start the chronometer and initialize the queries counter
    QueriesCounter.getInstance().start();

    FitbitAccountDataManager fitbitAccountDataManager = FitbitAccountDataManager(
      clientID: Credentials.getCredentials().id,
      clientSecret: Credentials.getCredentials().secret
    );
    final sp = await SharedPreferences.getInstance();
    final userID = sp.getString('userID');
    final stopQueries = await QueriesCounter.getInstance().check();
    if(stopQueries){
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Text('Limit rate of requests exceeded...', style: TextStyle(fontSize: 17, color: Colors.black))
        ),
        backgroundColor: Color.fromARGB(150, 195, 181, 236)
      ));
      return;
    } else {
      final accountData = await fitbitAccountDataManager.fetch(
        FitbitUserAPIURL.withUserID(
          userID: userID
        )
      );
      // save data

      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/home/');
      return;
    }
  }

  // _authorize and _fetch methods
  Future<void> _authorize(BuildContext context)async{
    String? userID = await FitbitConnector.authorize(
      context: context,
      clientID: Credentials.getCredentials().id,
      clientSecret: Credentials.getCredentials().secret,
      redirectUri: 'example://fitbit/auth',
      callbackUrlScheme: 'example'
    );
    final sp = await SharedPreferences.getInstance();
    if(userID != null){
      sp.setString('userID', userID);
    }
  }

  Future<void> _fetch(BuildContext context)async{
    final sp = await SharedPreferences.getInstance();
    if(sp.getString('userID') != null){
      await showDialog(
        context: context,
        builder: (context) => FutureBuilder(
          future: _fetchAccount(context),
          builder: (context, snapshot){
            return Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Fetching your data...', style: TextStyle(fontSize: 16, color: Colors.black, decoration: TextDecoration.none, fontStyle: FontStyle.normal)),
                    SizedBox(height: 7),
                    Text('(it might take a while)', style: TextStyle(fontSize: 16, color: Colors.black, decoration: TextDecoration.none, fontStyle: FontStyle.normal))
                  ],
                ),
              )
            );
          }
        )
      );
    } else {
      ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Text('To fetch data, please authorize.', style: TextStyle(fontSize: 17, color: Colors.black))
        ),
        backgroundColor: Color.fromARGB(150, 195, 181, 236)
      ));
    }
  }
}
