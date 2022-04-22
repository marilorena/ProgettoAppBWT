import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<StatefulWidget>{
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'username',
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'password',
                ),
                obscureText: true,
                obscuringCharacter: '•',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                child: const Text('Login'),
                onPressed: (){
                  if(_usernameController.text=='bug@expert.com' && _passwordController.text=='5TrNgP5Wd'){
                    Navigator.pushNamed(context, '/home/', arguments: _usernameController.text);
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Wrong credentials'),
                      duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      )
    );
  }
}