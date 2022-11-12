class AntigameCamShow extends Context {

  // Adapted from https://github.com/kimasendorf/ASDFPixelSort

  int mode = 0;
  PGraphics pg; // All graphics drawn to this buffer.
  String name = "AntigameCamShow";  // Drawn onscreen, make it count!
  float sc = 1.01; //Scale Coefficient
  int width_;
  int height_;
  int lfWidth;
  int lfHeight;
  int hue;
  boolean rgbIllumination = false;


  PGraphics lastFrame;
  PImage tempPixBuf = createImage(lfWidth, lfHeight, RGB);

  PGraphics getPGraphics() {
    return pg;
  }

  String getSketchName() {
    return name;
  }

  void init() {
    width_ = int(width * 0.67);
    height_ = int(height * 0.67);
    lfWidth = int(width_ * sc);
    lfHeight = int(height_ * sc);
    hue = int(random(255));

    pg = createGraphics(width_, height_, P2D);
    lastFrame = createGraphics( int(width_ * sc), int(height_ * sc), P2D);
    lastFrame.beginDraw();
    lastFrame.background(0);
    lastFrame.endDraw();
  }


  void anim() {

    float x1 = controller.getAxis("X1");
    float y1 = controller.getAxis("Y1");

    x1 = map(x1, -1, 1, -50, 50);
    y1 = map(y1, -1, 1, -50, 50);

    float x2 = controller.getAxis("X2");
    float y2 = controller.getAxis("Y2");

    x2 = map(x2, -1, 1, -350, 350);
    y2 = map(y2, -1, 1, -350, 350);

    if (controller.buttonPressed(4)) {
       rgbIllumination = !rgbIllumination; 
    }

    // Pull new frame
    if (video.available()) {
      video.read();
    }

    //Draw background
    pg.beginDraw();
    pg.background(0);
    pg.imageMode(CENTER);
    pg.image(lastFrame, width_ / 2 + x1, height_ / 2 + y1);
    pg.image(video, width_ / 2, height_ / 2, video.width + x2, video.height + y2);
    pg.endDraw();



    // Copy pixel buffer to lastFrame
    tempPixBuf = pg.get(0, 0, width_, height_);
    lastFrame.beginDraw();
    lastFrame.imageMode(CENTER);
    lastFrame.image(tempPixBuf, width_ / 2, height_ / 2, lfWidth + 50, lfHeight + 50 );
    lastFrame.endDraw();


    if (rgbIllumination) {
      // Draw RGB illumination box
      pg.beginDraw();
      pg.colorMode(HSB);
      pg.noStroke();
      pg.fill(hue, 255, 255);
      pg.rect(0, 0, 100, height_);
      pg.rect(width_-100, 0, 100, height_);
      pg.rect(0, 0, width_, 100);
      pg.rect(0, height_-100, width_, 100);
      pg.endDraw();
      hue++;
      hue %= 255;
    }
  }
}
