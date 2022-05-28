import 'package:flutter/material.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:our_first_app/utils/client_credentials.dart';

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
                String? userId = await FitbitConnector.authorize(
                  context: context,
                  clientID: credentials.id,
                  clientSecret: credentials.secret,
                  redirectUri: 'example://fitbit/auth',
                  callbackUrlScheme: 'example'
                );
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
