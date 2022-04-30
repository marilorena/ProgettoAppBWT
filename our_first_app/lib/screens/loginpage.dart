import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<StatefulWidget>{
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Welcome',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 1
          )
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text('Login to continue', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: const EdgeInsets.all(7),
              width: 350,
              child: TextField(
                  controller: _usernameController,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0x0B00FF00),
                    hintText: 'username',
                    prefixIcon: Icon(MdiIcons.account),
                    border: OutlineInputBorder()
                  )
                ),
            ),
            Container(
              padding: const EdgeInsets.all(7),
              width: 350,
              child: TextField(
                  controller: _passwordController,
                  obscureText: _obscure,
                  obscuringCharacter: '•',
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'password',
                    filled: true,
                    fillColor: const Color(0x0B00FF00),
                    prefixIcon: const Icon(MdiIcons.lock),
                    suffixIcon: IconButton(
                      onPressed: (){
                        setState((){
                          _obscure=!_obscure;
                        });
                      },
                      icon: const Icon(MdiIcons.eye)
                      ),
                    border: const OutlineInputBorder()
                  ),
                ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                child: const Text('Login'),
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1),
                  padding: const EdgeInsets.all(8),
                  fixedSize: const Size.fromWidth(90),
                ),
                onPressed: (){
                  if(_usernameController.text=='test' && _passwordController.text=='test'){
                    _usernameController.text='';
                    _passwordController.text='';
                    Navigator.popAndPushNamed(context, '/home/');
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Wrong credentials',
                        style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic)
                      ),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.black54,
                      padding: EdgeInsets.all(18)
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