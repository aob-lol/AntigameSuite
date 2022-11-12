// Controller
import net.java.games.input.*;
import org.gamecontrolplus.*;
import org.gamecontrolplus.gui.*;

// Camera
import processing.video.*;
Capture video;

// Controller
ControlIO control;
Configuration config;
Controller controller;

// Declare Antigames
ContextSwitch cs;


// Onscreen debug info
PFont font;

void captureEvent(Capture c) {
  c.read();
}


void setup() {
  fullScreen(P2D);
  //size(960, 540, P2D);

  // Hide mouse
  noCursor();

  // Controller Init
  control = ControlIO.getInstance(this);
  controller = new Controller();


  // Set up camera
  video = new Capture(this, 320, 240);
  video.start();

  // Set up ContextSwitch
  cs = new ContextSwitch();

  // Add antigames.
  cs.addContext( new AntigameCubeRave() );
  cs.addContext( new AntigameType2D() );
  cs.addContext( new AntigameGradientPlacer() );
  cs.addContext( new AntigamePortland() );
  cs.addContext( new AntigamePerlin() );
  cs.addContext( new AntigameCamShow() );
  cs.addContext( new AntigameTimeCircles() );

  // Set up font
  font = loadFont("Calibri-Light-18.vlw");
}


void draw() {
  // Parse controller input.
  controller.step();

  if (controller.buttonPressed(0)) {
    cs.prevContext();
  } else if (controller.buttonPressed(1)) {
    cs.nextContext();
  }


  // Animate current context.
  cs.anim();
  image( cs.getPGraphics(), 0, 0, width, height );

  // Display current game as debug text
  textFont(font);
  textAlign(RIGHT, BOTTOM);
  text( cs.getSketchName() + "\n" + nf(frameRate, 2, 2) + " fps", width, height);
}
