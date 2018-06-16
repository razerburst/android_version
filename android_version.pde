import android.util.DisplayMetrics;

int density;
float centerX;
float centerY;

color green = color(0, 255, 0);
color red = color(255, 0, 0);
color black = color(0);
color lightBlue = color(94, 228, 255);
color blue = color(11, 19, 240);
color orange = color(255, 217, 0);
color magenta = color(255, 68, 149);
color purple = color(199, 55, 173);

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
TextButton[][] traits = new TextButton[4][2];
TextButton startButton;

PImage dice;
float rectW;
float rectH;
float rectY;

void setup() {
  fullScreen();
  orientation(LANDSCAPE);

  DisplayMetrics metrics = new DisplayMetrics();
  getActivity().getWindowManager().getDefaultDisplay().getMetrics(metrics);
  density = int(metrics.density);

  noStroke();
  fill(0);
  centerX = width/2;
  centerY = height/2;
  textAlign(CENTER, CENTER);
  imageMode(CENTER);
  pet = new Pet();

  newGameButton = new TextButton("New game", centerX, height*0.4, 32, green);
  loadButton = new TextButton("Load", centerX, height*0.6, 32, green);
  quitButton = new TextButton("Quit", centerX, height*0.8, 32, green);

  maleButton = new TextButton("Male", width*0.4, height*0.4, 28, red);
  femaleButton = new TextButton("Female", width*0.6, height*0.4, 28, red);
  traits[0][0] = new TextButton("Early Bird", width*0.36, height*0.69, 32, lightBlue);
  traits[0][1] = new TextButton("Night Owl", width*0.49, height*0.69, 32, lightBlue);
  traits[1][0] = new TextButton("Energetic", width*0.36, height*0.75, 32, green);
  traits[1][1] = new TextButton("Lethargic", width*0.49, height*0.75, 32, green);
  traits[2][0] = new TextButton("Impatient", width*0.36, height*0.81, 32, orange);
  traits[2][1] = new TextButton("Composed", width*0.49, height*0.81, 32, orange);
  traits[3][0] = new TextButton("Friendly", width*0.36, height*0.87, 32, magenta);
  traits[3][1] = new TextButton("Hostile", width*0.49, height*0.87, 32, magenta);

  startButton = new TextButton("Start!", centerX, centerY, 34, green);
  startButton.defaultColour = red;
  
  pushStyle();
  textSize(28*density);
  textBoxRectW = textWidth(textBoxHeader);
  textBoxRectH = textAscent()+(textDescent()*2);
  textBoxRectY = height*0.3;
  popStyle();

  dice = loadImage("Dice.png");
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
    textSize(size*density);
    asc = textAscent();
    desc = textDescent();
    w = textWidth(string);
  }

  void display() {
    pushStyle();
    textSize(size*density);
    if (mouseCollide()) {
      fill(hoverColour);
    } else {
      fill(defaultColour);
    }
    text(string, x, y);
    popStyle();
  }

  boolean mouseCollide() {
    rectMode(CORNERS);
    return mouseX >= x-(w/2) && mouseX <= x+(w/2) && mouseY >= y-(asc/2) && mouseY <= y+((asc/2)+desc);
  }

  boolean clicked() {
    return mousePressed && mouseCollide();
  }
}

class Pet {
  String name;
  String gender;
  String[] nature = new String[4];

  Pet() {
  }
}

void draw() {
  background(255);
  switch(gameState) {
  case "mainMenu":
    newGameButton.display();
    loadButton.display();
    quitButton.display();

    if (newGameButton.clicked()) {
      gameState = "newGame";
    } else if (loadButton.clicked()) {
      gameState = "loadGame";
    } else if (quitButton.clicked()) {
    }
    break;
  case "newGame":
    int traitsPicked = 0;
    pushStyle();
    textSize(28*density);
    text(textBoxHeader, width/2, height*0.2);
    rectMode(CENTER);
    stroke(1);
    noFill();
    rect(centerX, rectY, rectW, rectH);
    textSize(26*density);
    text(textBoxString, centerX, rectY);
    popStyle();

    if (entered) {
      maleButton.display();
      femaleButton.display();

      if (maleButton.clicked()) {
        maleButton.defaultColour = red;
        femaleButton.defaultColour = black;
        pet.gender = "male";
        genderPicked = true;
      } else if (femaleButton.clicked()) {
        femaleButton.defaultColour = red;
        maleButton.defaultColour = black;
        pet.gender = "female";
        genderPicked = true;
      }

      if (genderPicked) {
        pushStyle();
        textAlign(LEFT);
        fill(blue);
        text("Choose pet's nature:", width*0.05, height*0.7);
        fill(purple);
        text("Randomise pet's nature:", width*0.65, height*0.7);
        popStyle();
        image(dice, width*0.8, height*0.8);
        for (int i = 0; i < traits.length; i = i+1) {
          for (int j = 0; j < traits[i].length; j = j+1) {
            traits[i][j].display();
            if (traits[i][j].clicked()) {
              traits[i][j].defaultColour = traits[i][j].hoverColour;
              pet.nature[i] = traits[i][j].string;
              if (j == 0) {
                traits[i][j+1].defaultColour = black;
              } else {
                traits[i][j-1].defaultColour = black;
              }
            }
          }
          if (pet.nature[i] != null) {
            traitsPicked = traitsPicked+1;
          }
        }
        if (traitsPicked == 4) {
          startButton.display();
          if (startButton.clicked()) {
            gameState = "playingGame";
          }
        }
      }
    }
    break;
  case "playingGame":
    break;
  case "loadGame":
    break;
  }
}

void keyPressed() {
  if (gameState == "newGame") {
    if (keyCode == BACKSPACE) {
      if (textBoxString.length() >0) {
        textBoxString = textBoxString.substring(0, textBoxString.length()-1);
      }
    } else if (keyCode == SHIFT) {
    } else if (keyCode == ENTER) {
      pet.name = textBoxString;
      textBoxString = "";
      entered = true;
      closeKeyboard();
    } else {
      if (textWidth(textBoxString) <= textWidth(textBoxHeader)) {
        textBoxString += key;
      }
    }
  }
}

void mouseReleased() {
  switch(gameState) {
  case "newGame":
    if (mouseX >= centerX-(rectW/2) && mouseX <= centerX+(rectW/2) && mouseY >= rectY-(rectH/2) && mouseY <= rectY+(rectH/2)) {
      openKeyboard();
    } else {
      closeKeyboard();
    }
  }
}
