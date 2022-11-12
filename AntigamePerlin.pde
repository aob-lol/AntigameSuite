class AntigamePerlin extends Context {
  // Perlin Noise Attribs
  float xorigin = 0.0;
  float yorigin = 0.0;
  float xoffset = 0.0;
  float yoffset = 0.0;
  float xmotion = 0.05;
  float ymotion = 0.05;
  float increment = 0.01;
  float rdegrees = 0.01;
  int side;

  // Two Layers of Perlin Noise
  PGraphics bg;
  PGraphics fg;
  PGraphics pg;

  int width_;
  int height_;

  String name="AntigamePerlin";

  void init() {
    // Set up canvases.
    // take longest edge of parent canvas and make that
    // the shortest side of child canvases, plus extra room
    // for seamless rotation.


    // Make it small bc these calculations are heavy
    width_ = 384;
    height_ = 216;

    // Compute canvas sizes
    side = int( width_ * 1.24 ); // The smallest square with perfect coverage in corners
    bg = createGraphics(side, side, P2D);
    fg = createGraphics(side, side, P2D);
    pg = createGraphics(width_, height_, P2D);
  }

  void anim() {
    // Get controller inputs
    float zoom = controller.getAxis("Y1");
    float rotate = controller.getAxis("X2");

    // set colorspace
    colorMode(RGB);

    // Apply motion
    xoffset += xmotion;
    yoffset += ymotion;
    increment += map(zoom, -1, 1, -0.0001, 0.0001);
    rdegrees += map(rotate, -1, 1, -0.01, 0.01 );

    // Animate Bottom Layer
    bg.beginDraw();
    bg.loadPixels();
    xorigin = 0.0 + xoffset;

    for (int x = 0; x < side; x++ ) {
      xorigin += increment;
      yorigin = 0.0 + yoffset;
      for (int y = 0; y < side; y++) {
        yorigin += increment;
        float noiseVal = noise( xorigin, yorigin) * 255;
        bg.pixels[x+y*side] = color(noiseVal, noiseVal, noiseVal, 155);
      }
    }

    bg.updatePixels();
    bg.endDraw();

    // Animate Top Layer
    fg.beginDraw();
    fg.loadPixels();
    xorigin = 0.0 + xoffset;

    for (int x = 0; x < side; x++ ) {
      xorigin += increment * 5;
      yorigin = 0.0 + yoffset;
      for (int y = 0; y < side; y++) {
        yorigin += increment * 5;
        float noiseVal = noise( xorigin, yorigin ) * 255;
        fg.pixels[x+y*side] = color(noiseVal, noiseVal, noiseVal, 66);
      }
    }
    fg.updatePixels();
    fg.endDraw();

    // Render Both Layers
    pg.beginDraw();
    pg.background(0);
    pg.pushMatrix();
    pg.translate(width_ / 2, height_ / 2);
    pg.rotate(rdegrees);
    pg.imageMode(CENTER);
    pg.blendMode(LIGHTEST);
    pg.image(bg, 0, 0);
    pg.image(fg, 0, 0);
    pg.popMatrix();
    pg.endDraw();
  }

  PGraphics getPGraphics() {
    return pg;
  }

  String getSketchName() {
    return name;
  }
}
