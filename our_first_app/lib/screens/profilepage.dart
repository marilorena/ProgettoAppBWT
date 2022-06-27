import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:our_first_app/database/entities/account_entity.dart';
import 'package:our_first_app/database/repository/database_repository.dart';
import 'package:our_first_app/model/targets.dart';
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
          child: Consumer<DatabaseRepository>(
            builder: (context, dbr, child) => FutureBuilder(
              initialData: null,
              future: dbr.getAccount(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  final data = (snapshot.data as List<Account>);
                  if(data.isEmpty){
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: Card(
                            elevation: 5,
                            child: ListTile(
                              title: const Text('Activity settings', style: TextStyle(fontSize: 18)),
                              trailing: const Icon(Icons.settings),
                              onTap: () => Navigator.pushNamed(context, '/activitysettings/')
                            ),
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: Card(
                            elevation: 5,
                            child: ListTile(
                              title: const Text('Logout', style: TextStyle(fontSize: 18)),
                              trailing: const Icon(Icons.logout),
                              onTap: () => Navigator.pushReplacementNamed(context, '/login/')
                            ),
                          )
                        ),
                      ],
                    );
                  } else {
                    final account = data[0];
                    return ListView(
                    padding: const EdgeInsets.all(10),
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width/4,
                          2,
                          MediaQuery.of(context).size.width/4,
                          2
                        ),
                        child: Card(
                          elevation: 10,
                          shape: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: ClipOval(
                              child: account.avatar == null ? null : Image.network(account.avatar!, scale: 0.1)
                            ),
                          ),
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                            enabled: false,
                            title: const Text('Name', style: TextStyle(fontSize: 14, color: Colors.grey)),
                            subtitle: Text(account.name?? '-', style: const TextStyle(fontSize: 16, color: Colors.black))
                          ),
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                            enabled: false,
                            title: const Text('Date of birth', style: TextStyle(fontSize: 14, color: Colors.grey)),
                            subtitle: Text(account.dateOfBirth?? '-', style: const TextStyle(fontSize: 16, color: Colors.black))
                          ),
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                            enabled: false,
                            title: const Text('Gender', style: TextStyle(fontSize: 14, color: Colors.grey)),
                            subtitle: Text((account.gender?? '-').toLowerCase(), style: const TextStyle(fontSize: 16, color: Colors.black))
                          ),
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                            enabled: false,
                            title: const Text('Height', style: TextStyle(fontSize: 14, color: Colors.grey)),
                            subtitle: Text('${account.height?? '-'} cm', style: const TextStyle(fontSize: 16, color: Colors.black))
                          ),
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                            enabled: false,
                            title: const Text('Weight', style: TextStyle(fontSize: 14, color: Colors.grey)),
                            subtitle: Text('${account.weight?? '-'} kg', style: const TextStyle(fontSize: 16, color: Colors.black))
                          ),
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                            enabled: false,
                            title: const Text('Legal terms accepted', style: TextStyle(fontSize: 14, color: Colors.grey)),
                            subtitle: Text(account.legalTermsAcceptRequired == null ? '-' : (account.legalTermsAcceptRequired == true ? 'yes' : 'no'), style: const TextStyle(fontSize: 16, color: Colors.black))
                          ),
                        )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: Card(
                            elevation: 5,
                            child: ListTile(
                              title: const Text('Activity settings', style: TextStyle(fontSize: 18)),
                              trailing: const Icon(Icons.settings),
                              onTap: () => Navigator.pushNamed(context, '/activitysettings/')
                            ),
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: Card(
                            elevation: 5,
                            child: ListTile(
                              title: const Text('Logout', style: TextStyle(fontSize: 18)),
                              trailing: const Icon(Icons.logout),
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => Center(
                                  child: Card(
                                    elevation: 5,
                                    margin: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      constraints: BoxConstraints(
                                        maxHeight: MediaQuery.of(context).size.height/3.2
                                      ),
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
                                                onTap: () => _toLoginPage(context, dbr)
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
                          ),
                        )
                      ],
                    );
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              }
            ),
          )
        ),
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
            icon: const Icon(MdiIcons.flowerTulip),
              onPressed: () {
                Navigator.popAndPushNamed(context, '/flower/');
              },
            ),
            label: 'Flower'
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
        currentIndex: 2,
        selectedItemColor: Colors.green,
        unselectedLabelStyle: const TextStyle(fontSize: 14)
      )
   );
  }
  
  Future<void> _toLoginPage(BuildContext context, DatabaseRepository dbr) async{
    await Provider.of<Targets>(context, listen:false).updateSteps(5000);
    await Provider.of<Targets>(context, listen:false).updateFloors(1);

    // remove all the key-value objects in the database, except fot counter and pastTime
    final sp = await SharedPreferences.getInstance();
    final keys = sp.getKeys().toList();
    for(var item in keys){
      if(item != 'counter' && item != 'pastTime'){
        sp.remove(item);
      }
    }

    // remove all the tables in the database
    await dbr.deleteAccount();
    await dbr.deleteAllActivity();
    await dbr.deleteAllActivityTimeseries();
    await dbr.deleteAllHeartData();
    await dbr.deleteAllSleepData();

    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/login/');

    final credentials = Credentials.getCredentials();
    await FitbitConnector.unauthorize(
      clientID: credentials.id,
      clientSecret: credentials.secret
    );
    
  }
}