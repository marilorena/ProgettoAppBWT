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
      appBar: AppBar(backgroundColor: const Color.fromARGB(150, 195, 181, 236),
        centerTitle: true,
        title: const Text(
          'Coins Page',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 27,
            letterSpacing: 1,
          )
        ),),
      body: Container(
        child: Center(
          child: Consumer<DatabaseRepository>( 
            builder: (context, dbr, child) => FutureBuilder(
                initialData: null,
                future: dbr.getStepsSum(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    final data = (snapshot.data as double?) as int;
                      double coins = data/1000;  
                      return Card(
                         elevation: 5,
                              child: ListTile(
                                title: Text('${coins}'),
                                trailing: const Icon(MdiIcons.cash),
                              )
                      ); 
                    }else{
                      return Text('No coins');
                    }
                  }
                
                  
                )
           )
        ),
      ),
    );
  }
}

