import 'package:flutter/material.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:our_first_app/utils/client_credentials.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthorizationPage extends StatelessWidget {
  const AuthorizationPage({Key? key}) : super(key: key);
  
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
                final credentials = Credentials.getCredentials();
                String? userID = await FitbitConnector.authorize(
                  context: context,
                  clientID: credentials.id,
                  clientSecret: credentials.secret,
                  redirectUri: 'example://fitbit/auth',
                  callbackUrlScheme: 'example'
                );
                final sp = await SharedPreferences.getInstance();
                if(userID != null){
                  sp.setString('userID', userID);
                }
                Navigator.pushReplacementNamed(context, '/home/');   
              },
              child: const Text('Authorize'),
            )
          ]
        ),
      ),
    );
  }
}
