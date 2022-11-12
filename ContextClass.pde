class Context {
 
  PGraphics pg; // All graphics drawn to this buffer.
  String name;  // Drawn onscreen, make it count!
  
  void init() {
  // Setup Functions. Gets run once.
  }
  
  
  void anim() {
   // Stuff to do many times per second.
  }
  
  
  PGraphics getPGraphics() {
    return pg;
  }
  
  String getSketchName() {
    return name; 
  }
  
}
