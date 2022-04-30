import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>{
final Color col = const Color.fromARGB(248, 159, 224, 159);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 1
          )
        )
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                      child: GestureDetector(
                            child: Container(
                              width: 140,
                              height: 140,
                              child: const Icon(MdiIcons.heartPulse, size: 50, color: Colors.white),
                              decoration: BoxDecoration(
                                color: col,
                                borderRadius: BorderRadius.circular(40)
                              ),
                            ),
                            onTap: (){}
                          ),
                    ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: GestureDetector(
                            child: Container(
                              width: 140,
                              height: 140,
                              child: const Icon(MdiIcons.run, size: 50, color: Colors.white),
                              decoration: BoxDecoration(
                                color: col,
                                borderRadius: BorderRadius.circular(40)
                              ),
                            ),
                            onTap: (){}
                          ),
                        )
                  ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                      child: GestureDetector(
                            child: Container(
                              width: 140,
                              height: 140,
                              child: const Icon(MdiIcons.bed, size: 50, color: Colors.white),
                              decoration: BoxDecoration(
                                color: col,
                                borderRadius: BorderRadius.circular(40)
                              ),
                            ),
                            onTap: (){}
                          ),
                    ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: GestureDetector(
                            child: Container(
                              width: 140,
                              height: 140,
                              child: const Icon(MdiIcons.batteryAlert, size: 50, color: Colors.white),
                              decoration: BoxDecoration(
                                color: col,
                                borderRadius: BorderRadius.circular(40)
                              ),
                            ),
                            onTap: (){}
                          ),
                        ),
                  ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                      child: GestureDetector(
                            child: Container(
                              width: 140,
                              height: 140,
                              child: const Icon(MdiIcons.silverwareForkKnife, size: 50, color: Colors.white),
                              decoration: BoxDecoration(
                                color: col,
                                borderRadius: BorderRadius.circular(40)
                              ),
                            ),
                            onTap: (){}
                          ),
                    ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: GestureDetector(
                            child: Container(
                              width: 140,
                              height: 140,
                              child: const Icon(MdiIcons.lungs, size: 50, color: Colors.white),
                              decoration: BoxDecoration(
                                color: col,
                                borderRadius: BorderRadius.circular(40)
                              ),
                            ),
                            onTap: (){}
                          ),
                        )
                  ]
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
              child: GestureDetector(
                    child: Container(
                      width: 320,
                      height: 100,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          image: DecorationImage(image: AssetImage('asset/icons/icon_launcher_adaptive_fore.png'), fit: BoxFit.none, scale: 3.5)
                        )
                      ),
                      decoration: BoxDecoration(
                        color: col,
                        borderRadius: BorderRadius.circular(45)
                      ),
                    ),
                    onTap: (){}
                  ),
            )
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
            label: 'Profile'
          )
        ]
      )
    );
  }
}