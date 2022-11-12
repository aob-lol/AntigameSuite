class BigCircle {

  float x;
  float y;
  float w;
  float h;

  BigCircle(float x_, float y_, float w_) {
    x = x_;
    y = y_;
    w = w_;
    h = random(0, 360);
  }

  void anim() {
    x+= random(-1, 1);
    y+= random(-1, 1);
  }

  void push( float x_, float y_ ) {

    // Inputs are -1 to +1
    float delta = map(w, 300, 350, 15.0, 0.5);
    x += x_ * delta; // function of scale
    y += y_ * delta;
  }

  void render(PGraphics pg_) {

    pg_.colorMode(HSB, 360, 100, 100);

    for (int r = int(w); r > 0; r-=15) {
      pg_.noStroke();
      pg_.fill(h, 90, 90);
      pg_.circle(x, y, r);
      h = (h + 35) % 360;
    }
  }
}

class AntigameTimeCircles extends Context {

  PGraphics pg; // All graphics drawn to this buffer.
  PGraphics lastFrame;
  String name = "AntigameTimeCircles";  // Drawn onscreen, make it count!
  ArrayList<BigCircle> circles;
  int width_;
  int height_;
  int lfWidth;
  int lfHeight;
  boolean lastReading = false;
  boolean curReading = false;
  PImage tempPixBuf = createImage(lfWidth, lfHeight, RGB);

  void init() {
    width_ = int(width * 0.67);    // Scale down for higher FPS
    height_ = int(height * 0.67);

    lfWidth = int(width_ * 1.01);  //
    lfHeight = int(height_ * 1.01);

    pg = createGraphics( width_, height_, P2D);
    lastFrame = createGraphics( lfWidth, lfHeight, P2D);

    // Initialize lastFrame as black
    lastFrame.beginDraw();
    lastFrame.background(0);
    lastFrame.endDraw();

    circles = new ArrayList<BigCircle>();

    for (int x = 0; x < 2; x++) {
      circles.add( new BigCircle( random(width_), random(height_), random(100)+250 ));
    }
  }


  void anim() {
    // Collect input
    float x1 = controller.getAxis("X1");
    float y1 = controller.getAxis("Y1");
    float x2 = controller.getAxis("X2");
    float y2 = controller.getAxis("Y2");

    if (controller.buttonPressed(4)) {
      init();
    }


    // Animate circles
    for (int x = 0; x < 2; x++) {
      if (x == 0) {
        circles.get(0).push(x1, y1);
      } else {
        circles.get(1).push(x2, y2);
      }
    }

    for (BigCircle b : circles) {
      b.anim();
    }

    // Draw background
    pg.beginDraw();
    pg.background(0);
    pg.imageMode(CENTER);
    pg.image(lastFrame, width_ / 2, height_ / 2);

    // Draw circles
    for (BigCircle b : circles) {
      b.render(pg);
    }
    pg.endDraw();

    // Copy pixel buffer to lastFrame
    tempPixBuf = pg.get(0, 0, width_, height_);
    lastFrame.beginDraw();
    lastFrame.imageMode(CENTER);
    lastFrame.image(tempPixBuf, width_ / 2, height_ / 2, lfWidth, lfHeight);

    // Grey out frames
    //lastFrame.fill(0, 12);
    //lastFrame.noStroke();
    //lastFrame.rect(0,0,width_,height_);
    lastFrame.endDraw();
  }


  PGraphics getPGraphics() {
    return pg;
  }

  String getSketchName() {
    return name;
  }
}
