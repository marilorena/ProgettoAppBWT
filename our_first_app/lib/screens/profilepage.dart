import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:our_first_app/utils/client_credentials.dart';
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
      body: Center(
        child: Column(
          children: [
            Card(
              elevation: 5,
              child: ListTile(
                title: const Text('Logout', style: TextStyle(fontSize: 18)),
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
                                  onTap: () => Navigator.pop(context)
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width/3/3),
                                GestureDetector(
                                  child: const Text('Log out', style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 158, 158, 158))),
                                  onTap: () => _toLoginPage(context)
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width/3/6)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ) 
          ],
        )
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
        ],
        currentIndex: 1,
        selectedItemColor: Colors.green,
        unselectedLabelStyle: const TextStyle(fontSize: 14)
      )
    );
  }
  
  Future<void> _toLoginPage(BuildContext context) async{ 
    final sp = await SharedPreferences.getInstance();
    final keys = sp.getKeys().toList();
    for(var item in keys){
      sp.remove(item);
    } // remove all the key-value objects in the database

    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/login/');

    final credentials = Credentials.getCredentials();
    await FitbitConnector.unauthorize(
      clientID: credentials.id,
      clientSecret: credentials.secret
    );
  }
}