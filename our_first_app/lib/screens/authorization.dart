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
                final account = _fetchData();
                String? userId = await FitbitConnector.authorize(
                  context: context,
                  clientID: '238BR6',
                  clientSecret: '447a1a825a0ff1846b3b3f35024dd7d4',
                  redirectUri: 'example://fitbit/auth',
                  callbackUrlScheme: 'example'
                );
                Navigator.popAndPushNamed(context, '/home/');   
              },
              child: const Text('Authorize'),
            )
          ]
        ),
      ),
    );
  }



 Future<List<FitbitAccountData>> _fetchData() async {

  return await fitbitAccountDataManager.fetch(FitbitUserAPIURL.withUserID(
    userID: '7ML2XV' )) as List<FitbitAccountData>;
  } 

}
