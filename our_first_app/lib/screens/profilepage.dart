import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:our_first_app/database/entities/account_entity.dart';
import 'package:our_first_app/database/repository/database_repository.dart';
import 'package:our_first_app/utils/client_credentials.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget{
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(150, 195, 181, 236),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 27,
            letterSpacing: 1,
          )
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/sfondo5.jpg'),
            fit: BoxFit.fitHeight
          )
        ),
        child: Center(
          child: 
            Consumer<DatabaseRepository>(
            builder: (context, dbr, child) {
              return FutureBuilder(
                initialData: null,
                future: dbr.getAccount(),
                builder: (context, snapshot) {
                  if (snapshot.hasData){
                    final data = snapshot.data as List<Account>;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, accountIndex){
                        final account = data[accountIndex];
                        return  Card(
                                key: UniqueKey(),
                                elevation: 5,
                                child: ListTile(
                                  title: Text(account.name!)
                                )
                              );
                             }
                                
                          );
                    } else {
                    return CircularProgressIndicator();
                  }
                }              
              );
            },
          ),
        
     )
    ),
     
     bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(56, 240, 235, 160),
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
        ],
        currentIndex: 1,
        selectedItemColor: Colors.green,
        unselectedLabelStyle: const TextStyle(fontSize: 14)
      ),
   );
  }
  
  Future<void> _toLoginPage(BuildContext context) async{
    // remove all the key-value objects in the database
    final sp = await SharedPreferences.getInstance();
    final keys = sp.getKeys().toList();
    for(var item in keys){
      sp.remove(item);
    }
    // remove all the tables in the database
    await Provider.of<DatabaseRepository>(context, listen: false).deleteAccount();

    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/login/');

    final credentials = Credentials.getCredentials();
    await FitbitConnector.unauthorize(
      clientID: credentials.id,
      clientSecret: credentials.secret
    );
    
  }
}