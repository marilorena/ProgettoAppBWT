import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:our_first_app/model/language.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
final Color col = Color.fromARGB(150, 53, 196, 84);

  @override
  Widget build(BuildContext context){
    return Consumer<Language>(
      builder: (context, language, child) =>  Scaffold(
        appBar: AppBar(
          
          backgroundColor: Color.fromARGB(150, 195, 181, 236),
          centerTitle: true,
          title: const Text(
            'Home',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25,
              
            )
          )
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('asset/sfondo5.jpg'), fit: BoxFit.fitHeight)),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(25, 50, 25, 25),
            children: [
              GestureDetector(
                child: Container(
                width: 320,
                height: 100,
                child: const Icon(MdiIcons.heartPulse, size: 50, color: Colors.white),
                decoration: BoxDecoration(
                  color: col,
                  borderRadius: BorderRadius.circular(45),
                ),
                ),
                onTap: (){}
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 3,
                ),
              ),
              GestureDetector(
                child: Container(
                width: 320,
                height: 100,
                child: const Icon(MdiIcons.run, size: 50, color: Colors.white),
                decoration: BoxDecoration(
                  color: col,
                  borderRadius: BorderRadius.circular(45),
                ),
                ),
                onTap: (){}
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 3,
                ),
              ),
              GestureDetector(
                child: Container(
                width: 320,
                height: 100,
                child: const Icon(MdiIcons.bed, size: 50, color: Colors.white),
                decoration: BoxDecoration(
                  color: col,
                  borderRadius: BorderRadius.circular(45),
                ),
                ),
                onTap: (){}
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 3,
                ),
              ),
              GestureDetector(
                child: Container(
                width: 320,
                height: 100,
                decoration: BoxDecoration(
                  
                  color: col,
                  borderRadius: BorderRadius.circular(45),
                  image: const DecorationImage(image: AssetImage('asset/icons/icon_launcher_adaptive_fore.png'), fit: BoxFit.none, scale: 3.5)
                ),
                ),
                onTap: (){}
              ),
            ]
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: (){
                    Navigator.popAndPushNamed(context, '/home/');
                  },
                ),
                label: 'Home'
              ),
              BottomNavigationBarItem(
                icon: IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: (){
                    Navigator.popAndPushNamed(context, '/profile/');
                  },
                ),
                label: language.language[3]
              )
            ],
            currentIndex: 0,
            selectedItemColor: Colors.green,
            unselectedLabelStyle: const TextStyle(fontSize: 14)
          )
      ),
    );
  }
}