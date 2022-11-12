class CubeDancer {

  /**
    this is so absolutely BLAH.
    just got it working; don't know what
    it needs. 
  
  */
  
  float x;
  float y;
  float z;
  float w;
  float h;
  float d;
  int lifespan;


  CubeDancer() {
    w = 128;
    d = w;
    h = random(128);
    lifespan = 13;
  }

  void anim() {
    lifespan--;
    if (lifespan == 0) {
      h += random(-w / 3, w / 3);
      lifespan = int(random(55));
    }
  }

  void anim(float h_) {
    //lifespan--;
    //if (lifespan == 0) {
    //  h = h_ * 300;
    //  lifespan = 13;
    //}
    h = h_ * map(controller.getAxis("X1"), -1, 1, 100, 600);
  }

  void render(PGraphics pg, int xOffset, int zOffset) {

    pg.pushMatrix();
    pg.translate( pg.height / 2 - xOffset * w, 0, pg.height / 2 -zOffset * w);
    pg.box(w, h, d);
    pg.popMatrix();
  }
}

class CubeRave {

  CubeDancer[][] rave = new CubeDancer[20][20];

  float noiseXOffset = 0.1;
  float noiseYOffset = 0.1;
  float noiseScale = 300;

  CubeRave() {

    // Initialize Ravers
    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < 20; j++) {
        rave[i][j] = new CubeDancer();
      }
    }
  }

  void anim() {
    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < 20; j++) {
        rave[i][j].anim( noise((i + noiseXOffset), (j + noiseYOffset)));
      }
    }
    noiseXOffset += 0.1;
    noiseYOffset += 0.1;
  }

  void render(PGraphics pg) {

    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < 20; j++) {
        rave[i][j].render(pg, i, j);
      }
    }
  }
}

class AntigameCubeRave extends Context {

  PGraphics pg; // All graphics drawn to this buffer.
  String name = "AntigameCubeRave";  // Drawn onscreen, make it count!
  int width_ = 1920;
  int height_ = 1080;
  CubeRave c = new CubeRave();
  float theta = 0.001;

  AntigameCubeRave() {
    pg = createGraphics(width_, height_, P3D);
  }


  void anim() {
    pg.beginDraw();
    pg.background(0);
    pg.noStroke();

    // Lighting
    pg.lightSpecular(255, 255, 255);
    pg.directionalLight(126, 126, 126, 0, 0, -1);
    pg.ambientLight(102, 102, 102);
    pg.emissive(0, 26, 51);

    // Camera
    pg.ortho(-width/2, width/2, -height/2, height/2);
    pg.translate( -(c.rave[0][0].w * c.rave[0].length), pg.height / 2, 0);

    pg.rotateX(-PI/6);
    pg.rotateY( pg.width / 2 + theta);

    theta += map(controller.getAxis("X2"), -1, 1, -.01, .01);
    c.anim();
    c.render(pg);
    pg.endDraw();
  }


  PGraphics getPGraphics() {
    return pg;
  }

  String getSketchName() {
    return name;
  }
}
