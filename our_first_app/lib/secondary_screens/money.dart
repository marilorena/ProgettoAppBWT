 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:our_first_app/database/repository/database_repository.dart';
import 'package:provider/provider.dart';

class Coins extends StatelessWidget {
  const Coins({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Consumer<DatabaseRepository>( 
          builder: (context, dbr, child) => FutureBuilder(
              initialData: null,
              future: dbr.getStepsSum(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  final data = (snapshot.data as List<>);
                  
                  return Card(
                    child: 
                  );
                }
              }
                
              )
         )
      ),
    );
  }
}

