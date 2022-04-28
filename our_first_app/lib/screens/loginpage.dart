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
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Login',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 3
          )
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(12)
              ),
              width: 350,
              height: 50,
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(hintText: 'username')
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(12)
                ),
                width: 350,
                height: 50,
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(hintText: 'password'),
                  obscureText: true,
                  obscuringCharacter: '•',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                child: const Text('Login'),
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)
                ),
                onPressed: (){
                  if(_usernameController.text=='test' && _passwordController.text=='test'){
                    _usernameController.text='';
                    _passwordController.text='';
                    Navigator.pushNamed(context, '/home/', arguments: _usernameController.text);
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Wrong credentials', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
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