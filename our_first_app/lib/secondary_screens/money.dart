 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:our_first_app/database/entities/activity_entity.dart';
import 'package:our_first_app/database/repository/database_repository.dart';
import 'package:provider/provider.dart';

class Coins extends StatelessWidget {
  const Coins({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
    elevation: 0,
    backgroundColor: const Color.fromARGB(56, 240, 235, 160),
    items: [
      BottomNavigationBarItem(
        icon: IconButton(
          icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/home/');
            },
          ),
          label: 'Home'
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: const Icon(Icons.person),
              onPressed: () { 
                Navigator.popAndPushNamed(context, '/profile/'); 
              },
            ),
            label: 'Profile'
          ),
           BottomNavigationBarItem(
          icon: IconButton(
            icon: const Icon(MdiIcons.flowerTulip),
              onPressed: () {
                
                Navigator.popAndPushNamed(context, '/money/');
                
              },
            ),
            label: 'Flower'
          )
        ],
        currentIndex: 0,
        selectedItemColor: Colors.green,
        unselectedLabelStyle: const TextStyle(fontSize: 14)
      ),
      body: Container(
        child: Center(
          child: Consumer<DatabaseRepository>( 
            builder: (context, dbr, child) => FutureBuilder(
                initialData: null,
                future: dbr.getStepsSum(),
                builder: (context, snapshot){
                  
                    final data = (snapshot.data as double?) ;
                    final coins = data == null ? 0 : data/1000; 
                     
                      return _getmymoney(coins);
                     
                    
                  }
                
                  
                )
           )
        ),
      ),
    );
  }




 Widget _getmymoney(num coins) {
      
        
          if (coins >= 20){
          return Card( 
          elevation: 5,
          child: Image.asset('asset/Animation/6.png'),
            );
          } else if (coins < 20 && coins >= 18){
            return Card( 
          elevation: 5,
          child: Image.asset('asset/Animation/5.png'),
          );
          } else if (coins < 18 && coins >= 15 ) {
          return Card( 
          elevation: 5,
          child: Image.asset('asset/Animation/4.png'),
          );
          } else if (coins < 15 && coins >= 10){
          return Card( 
          elevation: 5,
          child: Image.asset('asset/Animation/3.png'),
          );
          } else if (coins < 10 && coins >= 5 ) {
          return Card( 
          elevation: 5,
          child: Image.asset('asset/Animation/2.png'),
          );
          } else if (coins < 5){
          return Card( 
          elevation: 5,
          child: Image.asset('asset/Animation/1.png'),
          );
          }
       
    return CircularProgressIndicator();
  }


}

     