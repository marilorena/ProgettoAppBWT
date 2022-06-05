import 'dart:core';
import 'package:flutter/material.dart';
import 'package:fitbitter/fitbitter.dart';

class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage({Key? key}) : super(key: key);

  @override
  State<AuthorizationPage> createState() => _AuthorizationPageState();
}

 class _AuthorizationPageState extends State<AuthorizationPage> {

   final FitbitAccountDataManager fitbitAccountDataManager = FitbitAccountDataManager(clientID: '238BR6', clientSecret: '447a1a825a0ff1846b3b3f35024dd7d4');
   

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuthorizationPage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
               
                String? userId = await FitbitConnector.authorize(
                  context: context,
                  clientID: '238BR6',
                  clientSecret: '447a1a825a0ff1846b3b3f35024dd7d4',
                  redirectUri: 'example://fitbit/auth',
                  callbackUrlScheme: 'example'
                );
                 final account = await _fetchData();
                Navigator.popAndPushNamed(context, '/home/');   
              },
              child: const Text('Authorize'),
            )
          ]
        ),
      ),
    );
  }



 Future<List<FitbitData>> _fetchData() async {

  return await fitbitAccountDataManager.fetch(FitbitUserAPIURL.withUserID(
    userID: '7ML2XV' )) as List<FitbitData>;
  } 

}
