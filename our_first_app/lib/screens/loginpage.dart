import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:our_first_app/model/language.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    //Check if the user is already logged in before rendering the login page
    _checkLogin();
  }//initState

 void _checkLogin() async {
    //Get the SharedPreference instance and check if the value of the 'username' filed is set or not
    final sp = await SharedPreferences.getInstance();
    if(sp.getString('username') != null){
      //If 'username is set, push the HomePage
      Navigator.popAndPushNamed(context, '/home/');
    }//if
  }



  @override
  Widget build(BuildContext context){
    return Consumer<Language>(
      builder: (context, language, child) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('asset/sfondo7.jpg'), fit: BoxFit.cover)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage('asset/icons/icon_launcher.png'))
                    )
                  )
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(language.language[0], style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.all(7),
                  width: 350,
                  child: TextField(
                      controller: _usernameController,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(200, 255, 255, 255),
                        hintText: language.language[1],
                        prefixIcon: const Icon(MdiIcons.account),
                        border: const OutlineInputBorder()
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
                        fillColor: Color.fromARGB(200, 255, 255, 255),
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
                    onPressed: () async{
                      if(_usernameController.text=='test' && _passwordController.text=='test'){
                         final sp = await SharedPreferences.getInstance();
                         sp.setString('username', _usernameController.text);
                        Navigator.popAndPushNamed(context, '/authorization/');
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            language.language[2],
                            style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic)
                          ),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.black54,
                          padding: const EdgeInsets.all(18)
                          ),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}