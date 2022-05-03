import 'package:flutter/material.dart';
import 'package:our_first_app/model/language.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BottomNavBarIndex>(
      create: (context) => BottomNavBarIndex(),
      builder: (context, child) => Consumer<BottomNavBarIndex>(
        builder: (context, bottomnavbarindex, child) => Consumer<Language>(
          builder: (context, language, child) =>  BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: (){
                    Navigator.popAndPushNamed(context, '/home/');
                    bottomnavbarindex.onItemTapped;
                  },
                ),
                label: 'Home'
              ),
              BottomNavigationBarItem(
                icon: IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: (){
                    Navigator.popAndPushNamed(context, '/profile/');
                    bottomnavbarindex.onItemTapped;
                  },
                ),
                label: language.language[3]
              )
            ],
            currentIndex: bottomnavbarindex.selectedIndex,
            selectedItemColor: Colors.green,
            unselectedLabelStyle: const TextStyle(fontSize: 14)
          ),
        ),
      ),
    );
  }
}

class BottomNavBarIndex extends ChangeNotifier{
  int selectedIndex = 0;

  void onItemTapped(int index){
    selectedIndex = index;
    notifyListeners();
  }
}