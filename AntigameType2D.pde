class Letter {

  int x;
  int y;
  PFont font;
  String letter;

  Letter(int x_, int y_, PFont font_) {
    x = x_;
    y = y_;
    font = font_;
  }

  void setLetter( String letter_ ) {
    letter = letter_;
  }

  void render(PGraphics pg_) {
    pg_.textFont(font);
    pg_.text(letter, x, y);
  }

  void setFont( PFont font_ ) {
    font = font_;
  }
}

class WordGrid {
  
  int x;
  
}

class AntigameType2D extends Context {

  PGraphics pg; // All graphics drawn to this buffer.
  String name = "AntigameType2D";  // Drawn onscreen, make it count!
  PFont[] fontArray = new PFont[4];
  int fontIndex = 0;
  int width_ = width;
  int height_= height;


  AntigameType2D() {
    pg = createGraphics(width_, height_, P2D);
    fontArray[0] = loadFont("Menco-Thin-48.vlw");
    fontArray[1] = loadFont("Menco-Light-48.vlw");
    fontArray[2] = loadFont("Menco-Bold-48.vlw");
    fontArray[3] = loadFont("Menco-Black-48.vlw");
  }

  void anim() {
    // Stuff to do many times per second.
    pg.beginDraw();
    pg.background(0);
    pg.textFont(fontArray[fontIndex]);
    pg.textAlign(CENTER);
    pg.text("hello", width / 2, height / 2);
    fontIndex++;
    fontIndex%=fontArray.length;
    pg.endDraw();
  }


  PGraphics getPGraphics() {
    return pg;
  }

  String getSketchName() {
    return name;
  }
}
