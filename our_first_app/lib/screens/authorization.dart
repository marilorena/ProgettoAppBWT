import 'package:flutter/material.dart';
import 'package:fitbitter/fitbitter.dart';

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
}
