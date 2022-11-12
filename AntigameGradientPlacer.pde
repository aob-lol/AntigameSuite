/**
  TO-DO:
  control master tint. thinking something like
  the main tint slowly changes over time, causing
  all gradients to slowly shift colors...
*/

class Gradient {

  
  int x;
  int y;
  int w;
  int h;
  color c1;
  color c2;

  Gradient(int x_, int y_, color c1_, color c2_) {
    x = x_;
    y = y_;
    w = int(random(15, 50));
    h = int(random(15, 50));
    c1 = c1_;
    c2 = c2_;
  }

  void anim(Emitter e_) {
    e_.step();
    w = int(e_.getValue());
  }

  void render(PGraphics pg_) {

    pg_.colorMode(HSB);
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      pg_.stroke(c);
      pg_.line((w / 2) + x, i, (w/ 2) + (x+w), i);
    }
  }
}

class GradientCollection {

  int x;
  int y;
  int c1;
  int c2;
  ArrayList<Gradient> g = new ArrayList<Gradient>();
  Emitter e;

  GradientCollection(float x_, float y_, float emitMin, float emitMax) {
    e = new Emitter(emitMin, emitMax);
    x = int(x_);
    y = int(y_);

    // Get colors
    int randHue = int(random(255));
    int randDistance = int(random(30));
    int secondHue = randHue - randDistance;
    secondHue %= 255;
    colorMode(HSB);
    c1 = color( randHue, 255, 255 );
    c2 = color( secondHue, 255, 255 );

    // Increment Y offset for each new gradient
    int step = int(random(10, 50));
    int numGrads = int(random(20));
    for (int i = 0; i < numGrads; i++) {
      g.add( new Gradient( x, y + (step * i), c1, c2) );
    }
  }

  void setTheta( float t_ ) {
    e.step( t_ );
  }

  void anim() {
    for (Gradient ga : g) {
      ga.anim(e);
    }
  }

  void render( PGraphics pg_ ) {
    pg_.beginDraw();
    for (Gradient ga : g) {
      ga.render(pg_);
    }
    pg_.endDraw();
  }
}

class Emitter {

  float theta;
  float magnitude;

  Emitter(float min, float max) {
    magnitude = random(min, max);
  }

  Emitter() {
    //magnitude = random(-.001, .001);
    magnitude = random(0.5);
    theta = random(0, 360);
  }

  void step(float t_) {
    // Increment angle
    //theta += random(0.3);
    theta += t_;
  }

  void step() {
    // Increment angle
    theta += random(0.3);
  }

  float getValue() {
    // X component of vector, thx youtube
    return(sin(theta) / magnitude);
  }
}

class Reticule {
  float x;
  float y;
  boolean visible;

  Reticule() {
    x = width / 2;
    y = height / 2;
    visible = true;
  }

  void push(float x_, float y_) {
    if (visible) {
      x += x_;
      y += y_;

      if (x < 0) {
        x = 1;
      }

      if (y < 0) {
        y = 1;
      }

      if ( x > width ) {
        x = width - 1;
      }

      if ( y > height ) {
        y = height - 1;
      }
    }
  }

  void render(PGraphics pg) {
    if (visible) {
      int w = 10;
      pg.beginDraw();
      pg.strokeWeight(1);
      pg.colorMode(RGB);
      pg.stroke(255, 0, 0);

      // Top
      pg.line( x, y - 5, x, y - w);

      // Bottom
      pg.line( x, y + 5, x, y + w);

      // Left
      pg.line( x - 5, y, x - w, y);

      // Right
      pg.line( x + 5, y, x + w, y);

      pg.endDraw();
    }
  }

  void showHide() {
    visible = !visible;
  }
}

class AntigameGradientPlacer extends Context {

  PGraphics pg;
  PGraphics lastFrame;
  String name = "AntigameGradientPlacer";
  ArrayList<GradientCollection> gp;
  Reticule r = new Reticule();
  int width_ = width;
  int height_ = height;
  int lfWidth = int(width * 1.001);
  int lfHeight = int(height * 1.001);

  PImage tempPixBuf = createImage(lfWidth, lfHeight, RGB);
  float mainTint = 0.0;


  AntigameGradientPlacer() {
    pg = createGraphics(width_, height_, P2D);
    lastFrame = createGraphics(lfWidth, lfHeight, P2D);
  }

  void init() {
    gp = new ArrayList<GradientCollection>();
  }

  void anim() {
    if (controller.buttonPressed(4)) {
      // Bias results towards narrow and tall
      gp.add( new GradientCollection( r.x, r.y, -.01, .01 ) );
    }

    if (controller.buttonPressed(6)) {
      // Bias results towards wide and short
      gp.add( new GradientCollection( r.x, r.y, -.001, .001) );
    }

    if (controller.buttonPressed(5)) {
      init();
    }

    if (controller.buttonPressed(7)) {
      r.showHide();
    }

    float xOff = map(controller.getAxis("X1"), -1, 1, -35, 35);
    float yOff = map(controller.getAxis("Y1"), -1, 1, -35, 35);
    r.push(xOff, yOff);
    

    pg.beginDraw();
    pg.background(0);
    pg.colorMode(HSB);
    //pg.tint(mainTint, 255, 255);
    pg.imageMode(CENTER);
    pg.image(lastFrame, width_ / 2, height_ / 2);
    //pg.endDraw();

    float theta = controller.getAxis("X2");

    for (GradientCollection gpa : gp) {
      gpa.setTheta(theta);
      gpa.anim();
      gpa.render(pg);
    }

    // Render reticule last
    r.render(pg);

    // Prep background for next frame
    tempPixBuf = pg.get(0, 0, width_, height_);
    lastFrame.beginDraw();
    lastFrame.imageMode(CENTER);
    lastFrame.image(tempPixBuf, width_ / 2, height_ / 2, lfWidth, lfHeight);

    // Grey out frames
    lastFrame.fill(0, 12);
    lastFrame.noStroke();
    lastFrame.rect(0, 0, width_, height_);
    lastFrame.endDraw();
    
    mainTint += 0.1;
    mainTint %= 255;
    pg.endDraw();
  }


  PGraphics getPGraphics() {
    return pg;
  }

  String getSketchName() {
    return name;
  }
}
