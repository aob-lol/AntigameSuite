class ContextSwitch {
 
  ArrayList<Context> contexts = new ArrayList<Context>();
  int cIndex;
  
  ContextSwitch() {
    cIndex = 0; 
  }
  
  void addContext( Context context_ ) {
    contexts.add(context_);
    int latestIndex = contexts.size() - 1;
    contexts.get(latestIndex).init();
    println("Added Context! Len=" + contexts.size() );
  }
  
  void prevContext() {
    if ( cIndex > 0 ) {
      cIndex--; 
      println("cIndex:" + cIndex + "\tMillis:" + millis());
    }
  }
  
  void nextContext() {
    if ( cIndex < contexts.size() - 1 ) {
      cIndex++; 
      println("cIndex:" + cIndex + "\tMillis:" + millis());
    }
  }
  
  void anim() {
    contexts.get(cIndex).anim();
  }
  
  PGraphics getPGraphics() {
    return contexts.get(cIndex).getPGraphics();
  }
  
  String getSketchName() {
     return contexts.get(cIndex).getSketchName(); 
  }
  
}
