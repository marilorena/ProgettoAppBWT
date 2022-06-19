import 'package:shared_preferences/shared_preferences.dart';

class QueriesCounter{ // to detect if the rate limit of queries is reached
  static bool stopQueries = false;

  QueriesCounter._constructor();

  factory QueriesCounter.getInstance(){
    return QueriesCounter._constructor();
  }

  Future<bool> check() async{
    final sp = await SharedPreferences.getInstance();
    if(sp.getInt('pastTime') == null){
      sp.setInt('pastTime', DateTime.now().millisecondsSinceEpoch);
    }
    final elapsedTime = (DateTime.now().millisecondsSinceEpoch - sp.getInt('pastTime')!)/1000/60/60; // hours
    int counter = sp.getInt('counter')?? 0;

    if(elapsedTime >= 1){ // after each hour...
      sp.setInt('pastTime', DateTime.now().millisecondsSinceEpoch);
      sp.setInt('counter', 1);
      stopQueries = false;
      return stopQueries; // queries can be done
    } else { // otherwise, within each hour...
      sp.setInt('counter', counter + 1);
      if(counter >= 130){ // rate limit: 130 queries per hour
        stopQueries = true;
        return stopQueries; // queries cannot be done
      } else {
        stopQueries = false;
        return stopQueries; // queries can be done
      }
    }
  }

  bool getStopQueries(){
    return stopQueries;
  }
}