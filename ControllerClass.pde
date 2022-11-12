class Controller {

  /*
  
  
  
  GameControlPlus doesn't provide debouncing. 
  This library debounces inputs and adds
  a couple helper functions to access a 
  controller map by button and axis.
  
  
  
  
  */
  
  
  
  ControlDevice device;

  Boolean[][] buttons = new Boolean[8][2];

  Controller() {
    // Set up device
    device = control.filter(GCP.GAMEPAD).getMatchedDevice("gamepad_controllerPOC");

    // Set up button array
    for (int x = 0; x < buttons.length; x++) {
      for (int y = 0; y < buttons[x].length; y++) {
        buttons[x][y] = false;
      }
    }
  }

  void step() {
    // Take a sample of all buttons for debouncing

    buttons[0][0] = buttons[0][1];
    buttons[0][1] = device.getButton("B1").pressed();
    buttons[1][0] = buttons[1][1];
    buttons[1][1] = device.getButton("B2").pressed();
    buttons[2][0] = buttons[2][1];
    buttons[2][1] = device.getButton("B3").pressed();
    buttons[3][0] = buttons[3][1];
    buttons[3][1] = device.getButton("B4").pressed();
    buttons[4][0] = buttons[4][1];
    buttons[4][1] = device.getButton("B5").pressed();
    buttons[5][0] = buttons[5][1];
    buttons[5][1] = device.getButton("B6").pressed();
    buttons[6][0] = buttons[6][1];
    buttons[6][1] = device.getButton("B7").pressed();
    buttons[7][0] = buttons[7][1];
    buttons[7][1] = device.getButton("B8").pressed();
  }

  Boolean buttonPressed( int button ) {
    // Only true when debounced
    if ( buttons[button][0] == false && buttons[button][1] == true ) {
      return true;
    } else {
      return false;
    }
  }

  Boolean buttonDown( int button ) {
    return buttons[button][1]; 
  }

  Float getAxis( String axis ) {
    return device.getSlider(axis).getValue();
  }
}
