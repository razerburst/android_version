float centerX;
float centerY;

color green = color(0, 255, 0);
color red = color(255, 0, 0);
color black = color(0);
color lightBlue = color(94, 228, 255);
color blue = color(11, 19, 240);
color orange = color(255, 217, 0);
color magenta = color(255, 68, 149);

Pet pet;
String gameState = "mainMenu";
String textBoxHeader = "Enter a name for your new pet:";
String textBoxString = "";

TextButton newGameButton;
TextButton loadButton;
TextButton quitButton;

boolean entered;
boolean genderPicked;
TextButton maleButton;
TextButton femaleButton;
TextButton[] traits = new TextButton[8];

void setup() {
  fullScreen();
  noStroke();
  fill(0);
  centerX = width/2;
  centerY = height/2;
  textAlign(CENTER, CENTER);
  pet = new Pet();

  newGameButton = new TextButton("New game", centerX, centerY, 32, green);
  loadButton = new TextButton("Load", centerX, height*0.6, 32, green);
  quitButton = new TextButton("Quit", centerX, height*0.7, 32, green);

  maleButton = new TextButton("Male", width*0.4, height*0.4, 28, red);
  femaleButton = new TextButton("Female", width*0.6, height*0.4, 28, red);
  traits[0] = new TextButton("Early Bird", width*0.35, height*0.69, 32, lightBlue);
  traits[1] = new TextButton("Night Owl", width*0.48, height*0.69, 32, lightBlue);
  traits[2] = new TextButton("Energetic", width*0.35, height*0.75, 32, green);
  traits[3] = new TextButton("Lethargic", width*0.48, height*0.75, 32, green);
  traits[4] = new TextButton("Impatient", width*0.35, height*0.81, 32, orange);
  traits[5] = new TextButton("Composed", width*0.48, height*0.81, 32, orange);
  traits[6] = new TextButton("Friendly", width*0.35, height*0.87, 32, magenta);
  traits[7] = new TextButton("Hostile", width*0.48, height*0.87, 32, magenta);
}

class TextButton {
  String string;
  float x;
  float y;
  int size;
  color hoverColour;
  color defaultColour;
  float asc;
  float desc;
  float w;

  TextButton(String _string, float _x, float _y, int _size, color _hoverColour) {
    string = _string;
    x = _x;
    y = _y;
    size = _size;
    hoverColour = _hoverColour;
    defaultColour = black;
    textSize(size);
    asc = textAscent();
    desc = textDescent();
    w = textWidth(string);
  }

  void display() {
    pushStyle();
    textSize(size);
    if (mouseCollide()) {
      fill(hoverColour);
    } else {
      fill(defaultColour);
    }
    text(string, x, y-desc);
    popStyle();
  }

  boolean mouseCollide() {
    if (mouseX >= x-(w/2) && mouseX <= x+(w/2) && mouseY >= y-(asc/2) && mouseY <= y+(asc/2)) {
      return true;
    } else {
      return false;
    }
  }
}

class Pet {
  String name;
  String gender;

  Pet(){

  }
}

void draw() {
  background(255);
  switch(gameState) {
  case "mainMenu":
    newGameButton.display();
    loadButton.display();
    quitButton.display();

    if (mousePressed && mouseButton == LEFT) {
      if (newGameButton.mouseCollide()) {
        gameState = "newGame";
      } else if (loadButton.mouseCollide()) {
        gameState = "loadGame";
      } else if (quitButton.mouseCollide()) {
        gameState = "quit";
      }
    }
    break;
  case "newGame":
    pushStyle();
    textSize(28);
    text(textBoxHeader, width/2, height*0.2);
    rectMode(CENTER);
    stroke(1);
    noFill();
    rect(width/2, (height*0.25)+textDescent(), textWidth(textBoxHeader)*1.05, textAscent()*1.2);
    text(textBoxString, width/2, height*0.25);
    popStyle();

    if (entered) {
      maleButton.display();
      femaleButton.display();

      if (mousePressed && mouseButton == LEFT) {
        if (maleButton.mouseCollide()) {
          maleButton.defaultColour = red;
          femaleButton.defaultColour = black;
          pet.gender = "male";
          genderPicked = true;
        } else if (femaleButton.mouseCollide()) {
          femaleButton.defaultColour = red;
          maleButton.defaultColour = black;
          pet.gender = "female";
          genderPicked = true;
        }
      }

      if (genderPicked) {
        pushStyle();
        textAlign(LEFT);
        fill(blue);
        text("Choose pet's nature:", width*0.05, height*0.7);
        popStyle();
        // make this a for loop
        for (TextButton button: traits) {
          button.display();
        }
        // traits[0].display();
        // traits[1].display();
        // traits[2].display();
        // traits[3].display();
        // traits[4].display();
        // traits[5].display();
      }
    }
    break;
  case "loadGame":
    break;
  case "quit":
    break;
  }
}

void keyTyped() {
  if (gameState == "newGame") {
    if (key == BACKSPACE) {
      if (textBoxString.length() >0) {
        textBoxString = textBoxString.substring(0, textBoxString.length()-1);
      }
    } else if (key == ENTER) {
      pet.name = textBoxString;
      textBoxString = "";
      entered = true;
    } else {
      if (textWidth(textBoxString) <= textWidth(textBoxHeader)) {
        textBoxString += key;
      }
    }
  }
}
