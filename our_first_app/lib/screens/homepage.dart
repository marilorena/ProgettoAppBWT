import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>{

  @override
  Widget build(BuildContext context){
    final _result = ModalRoute.of(context)!.settings.arguments! as String;

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'username: $_result',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                child: const Text('To Login page'),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}