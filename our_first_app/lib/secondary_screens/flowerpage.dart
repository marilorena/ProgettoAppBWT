import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:our_first_app/database/repository/database_repository.dart';
import 'package:provider/provider.dart';

class Coins extends StatelessWidget {
  const Coins({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(150, 195, 181, 236),
        centerTitle: true,
        title: const Text('Flower\'s growth-by-steps',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1,
            )),
      ),
      body: Container(
        child: Center(
            child: Consumer<DatabaseRepository>(
                builder: (context, dbr, child) => FutureBuilder(
                    initialData: null,
                    future: dbr.getSteps(),
                    builder: (context, snapshot) {
                      final data = snapshot.data as List<double>?;
                      final steps = data == null || data.isEmpty
                          ? 0
                          : data.reduce((a, b) => a + b) ~/ 1;
                      final points = steps ~/ 10000;
                      return ListView(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 10, height: 40,),
                                Text(
                                  'Let\'s grow your flower!',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(MdiIcons.walk),
                                const SizedBox(width: 10, height: 1,),
                                Text('Total steps: $steps',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.star),
                                const SizedBox(width: 10),
                                Text('Level: $points',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                                margin:
                                    const EdgeInsets.fromLTRB(10, 100, 10, 10),
                                constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height / 2),
                                child: _getFlower(points))
                          ]);
                    }))),
      ),
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
                label: 'Home'),
            BottomNavigationBarItem(
                icon: IconButton(
                  icon: const Icon(MdiIcons.flowerTulip),
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/flower/');
                  },
                ),
                label: 'Flower'),
            BottomNavigationBarItem(
                icon: IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/profile/');
                  },
                ),
                label: 'Profile')
          ],
          currentIndex: 1,
          selectedItemColor: Colors.green,
          unselectedLabelStyle: const TextStyle(fontSize: 14)),
    );
  }

  Widget _getFlower(num points) {
    if (points >= 20) {
      return Card(elevation: 1, child: Image.asset('asset/Animation/6.png'));
    } else if (points < 20 && points >= 18) {
      return Card(child: Image.asset('asset/Animation/5.png'));
    } else if (points < 18 && points >= 15) {
      return Card(child: Image.asset('asset/Animation/4.png'));
    } else if (points < 15 && points >= 10) {
      return Card(child: Image.asset('asset/Animation/3.png'));
    } else if (points < 10 && points >= 5) {
      return Card(child: Image.asset('asset/Animation/2.png'));
    } else {
      return Card(child: Image.asset('asset/Animation/1.png'));
    }
  }
}
