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
                    return  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height*1,
                      maxWidth: MediaQuery.of(context).size.width*1
                    ),
                    child:
                    ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemCount: data.length,
                      itemBuilder: (context, accountIndex){
                        final account = data[accountIndex];
                        return    ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height,
                      maxWidth: MediaQuery.of(context).size.width
                    ),
                    child: ListView( padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                                  children: [ListTile(title: Text(account.name!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))) , 
                                  ListTile(title: Text(account.gender!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))) , 
                                  ListTile(title: Text(account.dateOfBirth!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))), 
                                  ListTile(
                                      title: const Text('Logout', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                      trailing: const Icon(Icons.logout),
                                      onTap: () => showDialog(
                                        context: context,
                                        builder: (context) => Center(
                                          child: Card(
                                            elevation: 5,
                                            margin: const EdgeInsets.fromLTRB(70, 20, 70, 20),
                                            child: Container(
                                              padding: const EdgeInsets.all(20),
                                              height: MediaQuery.of(context).size.height/3.2,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Text('Are you sure to log out?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                  const SizedBox(height: 10),
                                                  const Text(
                                                    'If you log out, all your (locally storaged) data will be deleted.\nOnce you log in again, they will need to be fetched another time.',
                                                    textAlign: TextAlign.justify,
                                                    style: TextStyle(fontSize: 16)
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(width: MediaQuery.of(context).size.width/3/6),
                                                      GestureDetector(
                                                        child: const Text('Cancel', style: TextStyle(fontSize: 18, color: Colors.blue)),
                                                        onTap: () => Navigator.pop(context)),
                                                        SizedBox(width: MediaQuery.of(context).size.width/3/3),
                                                                    GestureDetector(
                                                                      child: const Text('Log out', style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 158, 158, 158))),
                                                                      onTap: () => _toLoginPage(context)
                                                                    ),
                                                                    SizedBox(width: MediaQuery.of(context).size.width/3/6)
                                                        ]
                                                  )
                                                ]
                                              )
                                            )
                                          )
                                        )
                                      )
                                    )
                                  ]
                              )
                        );
                                
                    }
                                
                      )  
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