import 'package:flutter/material.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:our_first_app/database/entities/account_entity.dart';
import 'package:our_first_app/utils/client_credentials.dart';
import 'package:our_first_app/utils/queries_counter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthorizationPage extends StatelessWidget {
  const AuthorizationPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => Center(
                  child: Card(
                    elevation: 5,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      height: MediaQuery.of(context).size.height*0.35,
                      width: MediaQuery.of(context).size.width*0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('We\'re going to fetch your data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1, textAlign: TextAlign.center),
                          const SizedBox(height: 10),
                          const Text(
                            'They will be used just for visualization purposes and to retrieve simple possible solutions to improve your wellbeing to advice you with.\nThey will be stored on the local storage of your smartphone, but never shared with any third-party application or system.',
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 16)
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            child: const Text('Got it', style: TextStyle(fontSize: 18, color: Colors.blue)),
                            onTap: () async{
                              await _authorize(context);
                              await _fetch(context); 
                            }
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              child: const Text('Authorize and fetch', style: TextStyle(fontSize: 18)),
            )
          ]
        ),
      ),
    );
  }

  // data fetching method
  Future<void> _fetchData(BuildContext context)async{
    FitbitAccountDataManager fitbitAccountDataManager = FitbitAccountDataManager(
      clientID: Credentials.getCredentials().id,
      clientSecret: Credentials.getCredentials().secret
    );
    final sp = await SharedPreferences.getInstance();
    final userID = sp.getString('userID');
    final stopQueries = await QueriesCounter.getInstance().check(); // x number of queries to do, in this way no data will be fetched if the total number of queries is too much, so it won't happen that some data are fetched and others not
    if(stopQueries){
      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Text('Limit rate of requests exceeded...', style: TextStyle(fontSize: 17, color: Colors.black))
        ),
        backgroundColor: Color.fromARGB(150, 195, 181, 236)
      ));
      return;
    } else {
      // ACCOUNT DATA
      // fetch
      final accountData = await fitbitAccountDataManager.fetch(
        FitbitUserAPIURL.withUserID(
          userID: userID
        )
      ) as List<FitbitAccountData>;
      // save
      final Account account = Account(
        id: null,
        name: accountData[0].fullName,
        age: accountData[0].age,
        avatar: accountData[0].avatar,
        dateOfBirth: accountData[0].dateOfBirth,
        gender: accountData[0].gender,
        height: accountData[0].height,
        legalTermsAcceptRequired: accountData[0].legalTermsAcceptRequired,
        weight: accountData[0].weight
      );

      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/home/');
      return;
    }
  }

  // _authorize and _fetch methods
  Future<void> _authorize(BuildContext context)async{
    String? userID = await FitbitConnector.authorize(
      context: context,
      clientID: Credentials.getCredentials().id,
      clientSecret: Credentials.getCredentials().secret,
      redirectUri: 'example://fitbit/auth',
      callbackUrlScheme: 'example'
    );
    final sp = await SharedPreferences.getInstance();
    if(userID != null){
      sp.setString('userID', userID);
    }
  }

  Future<void> _fetch(BuildContext context)async{
    final sp = await SharedPreferences.getInstance();
    if(sp.getString('userID') != null){
      await showDialog(
        context: context,
        builder: (context) => FutureBuilder(
          future: _fetchData(context),
          builder: (context, snapshot){
            return Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Fetching your data...', style: TextStyle(fontSize: 16, color: Colors.black, decoration: TextDecoration.none, fontStyle: FontStyle.normal)),
                    SizedBox(height: 7),
                    Text('(it might take a while)', style: TextStyle(fontSize: 16, color: Colors.black, decoration: TextDecoration.none, fontStyle: FontStyle.normal))
                  ],
                ),
              )
            );
          }
        )
      );
    } else {
      ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Text('To fetch data, please authorize.', style: TextStyle(fontSize: 17, color: Colors.black))
        ),
        backgroundColor: Color.fromARGB(150, 195, 181, 236)
      ));
    }
  }
}
