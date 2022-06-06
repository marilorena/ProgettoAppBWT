import 'package:shared_preferences/shared_preferences.dart';

class QueriesCounter{ // to detect if the rate limit of queries is reached
  static final Stopwatch chronometer = Stopwatch();
  static bool stopQueries = false;

  QueriesCounter._constructor();

  factory QueriesCounter.getInstance(){
    return QueriesCounter._constructor();
  }

  void start(){
    chronometer.start();
  }

  Future<bool> check() async{
    if(chronometer.isRunning){
      final sp = await SharedPreferences.getInstance();

      if(sp.getInt('pastTime') == null){
        sp.setInt('pastTime', DateTime.now().millisecondsSinceEpoch);
      }
      sp.setInt(
        'millisecondsSincePastTime',
        DateTime.now().millisecondsSinceEpoch - sp.getInt('pastTime')!
      );
      final elapsedTime = (chronometer.elapsedMilliseconds + sp.getInt('millisecondsSincePastTime')!)/1000/60/60; // hours

      int counter = sp.getInt('counter')?? 0;

      if(elapsedTime >= 1){ // after each hour...
        sp.setInt('pastTime', DateTime.now().millisecondsSinceEpoch);
        sp.setInt('millisecondsSincePastTime', 0);
        sp.setInt('counter', 1);
        chronometer.reset();
        stopQueries = false;
        return stopQueries; // queries can be done
      } else { // otherwise, within each hour...
        sp.setInt('counter', counter + 1);
        if(counter >= 70){ // rate limit: 70*2 = 140 queries per hour
          stopQueries = true;
          return stopQueries; // queries cannot be done
        } else {
          stopQueries = false;
          return stopQueries; // queries can be done
        }
      }
    } else {
      return true; // when the chronometer is not running (i.e. only in the login page), queries cannot be done
    }
  }

  bool getStopQueries(){
    return stopQueries;
  }

  void stop(){
    chronometer.stop();
    chronometer.reset();
  }
}