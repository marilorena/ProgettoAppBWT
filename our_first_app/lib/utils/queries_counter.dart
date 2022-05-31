class QueriesCounter{ // to detect if the rate limit of queries is reached
  static final Stopwatch chronometer = Stopwatch();
  static int counter = 0;
  static bool stopQueries = false;

  QueriesCounter._constructor();

  factory QueriesCounter.getInstance(){
    return QueriesCounter._constructor();
  }

  void start(){
    chronometer.start();
    stopQueries = false;
  }

  bool check(){
    if(chronometer.isRunning){
      final elapsedTime = chronometer.elapsedMilliseconds/1000/60/60;
      if(elapsedTime >= 1){ // after each hour...
        counter = 1;
        chronometer.reset();
        stopQueries = false;
        return stopQueries; // queries can be done
      } else { // otherwise, within each hour...
        counter = counter + 1;
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
  }
}