class Droplet {

  int lifespan;
  float vtA; //Visibility Threshold A
  float vtB;
  int x;
  int y;
  int xOffset;
  int yOffset;

  Droplet(int width_, int height_) {
    lifespan = 15;
    vtA = 0.7;
    vtB = 0.2;
    x = int(random(width_));
    y = int(random(height_));
    xOffset = int(random(50));
    yOffset = int(random(200)) + 100;
  }

  void anim() {
    lifespan--;
  }

  void render(PGraphics pg) {
    pg.beginDraw();

    if (lifespan > 0) {
      // Draw line
      pg.stroke(255);
      pg.strokeWeight(2);
      float x3 = map(lifespan, 15, 0, (x - xOffset), x);
      float y3 = map(lifespan, 15, 0, (y - yOffset), y);
      pg.line( x3, y3, x, y);
      //println("x: " + x + "\ty: " + y + "\txoff: " + xOffset + "\tyOff: " + yOffset + "\tx3: " + x3 + "\ty3: " + y3);
      float w = map(lifespan, int(lifespan * vtA), 0, 50, 150);
      pg.noFill();
      pg.ellipse(x, y, w, 10);
    }


    pg.endDraw();
  }
}

class Ripple {

  int x;
  int y;
  int lifespan;

  Ripple(int x_, int y_) {
    lifespan = 60;
    x = x_;
    y = y_;
  }

  void anim() {
    lifespan--;
  }

  void render(PGraphics context) {
    context.beginDraw();
    float lineWidth = map(lifespan, 0, 60, 2, 10);
    context.strokeWeight(lineWidth);

    float opacity = map(lifespan, 0, 60, 0, 255);
    context.stroke(255, opacity);

    float rWidth = map(lifespan, 0, 60, 80, 120);
    float rHeight = map(lifespan, 0, 60, 10, 18);
    context.ellipse(x, y, rWidth, rHeight);
    context.endDraw();
  }
}

class AntigamePortland extends Context {


  PGraphics pg; // All graphics drawn to this buffer.
  String name = "AntigamePortland";  // Drawn onscreen, make it count!
  ArrayList<Droplet> drops = new ArrayList<Droplet>();
  ArrayList<Ripple> rips = new ArrayList<Ripple>();

  int width_;
  int height_;


  AntigamePortland() {
    // Setup Functions. Gets run once.
    width_ = 1920;
    height_ = 1080;
    pg = createGraphics(width_, height_, P2D);

    pg.beginDraw();
    pg.background(0);
    pg.endDraw();
  }


  void anim() {
    float stormWidth = width_;
    
    // Animate drops
    pg.beginDraw();
    pg.background(0);
    for (Droplet d : drops) {
      d.anim();
      d.render(pg);
    }
    for (Ripple r : rips) {
      r.anim();
      r.render(pg);
    }
    pg.endDraw();

    // Get controller input; add drops
    if (controller.buttonPressed(4)) {
      for (int x = 0; x < int(random(6)); x++ ) {
        drops.add( new Droplet(width_, height_) );
      }
    }

    // Controller input: create storm with up on stick
    float stormChance = map( controller.getAxis("Y1"), -1, 1, 9, 0);


    // Prune old drops
    for (int x = drops.size() -1; x > 0; x--) {
      if (drops.get(x).lifespan <= 0) {
        drops.remove(x);
      }
    }

    // Prune old ripples
    for (int x = rips.size() -1; x > 0; x--) {
      if (rips.get(x).lifespan <= 0) {
        rips.remove(x);
      }
    }

    // Add drops at random
    if ( int(random(10)) > stormChance) {
      drops.add( new Droplet( int(stormWidth), height_));
    }

    // Add ripples at random
    if ( int(random(10)) > 8) {
      if ( drops.size() > 0 ) {
        Droplet tempDrop = drops.get( int(random(drops.size())) );
        if (tempDrop.lifespan > 8) {
          rips.add( new Ripple(tempDrop.x, tempDrop.y));
        }
      }
    }
  }


  PGraphics getPGraphics() {
    return pg;
  }

  String getSketchName() {
    return name;
  }
}
