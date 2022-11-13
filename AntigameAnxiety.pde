class Letter {

  int x;
  int y;
  PFont font;
  String letter;

  Letter(int x_, int y_, String letter_) {
    x = x_;
    y = y_;
    letter = letter_;
  }

  void render(PGraphics pg_) {
    pg_.textFont(font);
    pg_.text(letter, x, y);
  }
}

class AntigameType2D extends Context {

  PGraphics pg;
  String name = "AntigameAnxiety";
  PFont[] fontArray = new PFont[4];
  int fontIndex = 0;
  int width_ = width;
  int height_= height;
  ArrayList<Letter> letters = new ArrayList<Letter>();


  AntigameType2D() {
    pg = createGraphics(width_, height_, P2D);
    fontArray[0] = loadFont("Menco-Thin-48.vlw");
    fontArray[1] = loadFont("Menco-Light-48.vlw");
    fontArray[2] = loadFont("Menco-Bold-48.vlw");
    fontArray[3] = loadFont("Menco-Black-48.vlw");
  }

  void anim() {
    // animate letters
    if (millis() % 150 == 0) {
      //Add new letter
      String allLetters = "a";
      int randL = int(random(1));
      String letter = allLetters[ randL ];
      int randX = int(random(width_));
      int randY = int(random(height_));
      letters.add(new Letter(randX, randY, randL));
    }
    // Draw to canvas
    pg.beginDraw();
    pg.background(0);
    pg.textFont(fontArray[int(random(4))]);
    pg.textAlign(CENTER);
    for (Letter letter: letters) {
     letter.render();
    }
    pg.endDraw();
  }


  PGraphics getPGraphics() {
    return pg;
  }

  String getSketchName() {
    return name;
  }
}
