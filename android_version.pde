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
float textBoxRectW;
float textBoxRectH;
float textBoxRectY;

TextButton newGameButton;
TextButton loadButton;
TextButton quitButton;
TextButton sleepButton;
TextButton statsButton;
TextButton feedButton;
TextButton shopButton;

boolean entered;
boolean genderPicked;
TextButton maleButton;

TextButton femaleButton;
TextButton[][] traits = new TextButton[4][2];
TextButton startButton;
TextButton backButton;

PImage dice;
float diceX;
float diceY;

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

  sleepButton = new TextButton("Sleep", width*0.086, height*0.9, 32, purple);
  statsButton = new TextButton("Stats", width*0.36, height*0.9, 32, purple);
  feedButton = new TextButton("Feed", width*0.654, height*0.9, 32, purple);
  shopButton = new TextButton("Shop", width*0.92, height*0.9, 32, purple);

  maleButton = new TextButton("Male", width*0.45, height*0.34, 28, red, RIGHT, CENTER);
  femaleButton = new TextButton("Female", width*0.55, height*0.34, 28, red, LEFT, CENTER);

  traits[0][0] = new TextButton("Early Bird", width*0.18, height*0.67, 24, lightBlue);
  traits[0][1] = new TextButton("Night Owl", width*0.38, height*0.67, 24, lightBlue);
  traits[1][0] = new TextButton("Energetic", width*0.18, height*0.75, 24, green);
  traits[1][1] = new TextButton("Lethargic", width*0.38, height*0.75, 24, green);
  traits[2][0] = new TextButton("Impatient", width*0.18, height*0.83, 24, orange);
  traits[2][1] = new TextButton("Composed", width*0.38, height*0.83, 24, orange);
  traits[3][0] = new TextButton("Friendly", width*0.18, height*0.91, 24, magenta);
  traits[3][1] = new TextButton("Hostile", width*0.38, height*0.91, 24, magenta);

  startButton = new TextButton("Start!", centerX, height*0.45, 34, purple);
  startButton.defaultColour = red;
  backButton = new TextButton("Back", width*0.97, height*0.05, 34, red);

  pushStyle();
  textSize(28*density);
  textBoxRectW = textWidth(textBoxHeader);
  textBoxRectH = textAscent()+(textDescent()*2);
  textBoxRectY = height*0.2;
  popStyle();

  dice = loadImage("Dice.png");
  dice.resize(70*density, 70*density);
  diceX = width*0.75;
  diceY = height*0.76;
}

class TextButton {
  String string;
  float x;
  float y;
  int h;
  int v;
  int size;
  color hoverColour;
  color defaultColour;
  float asc;
  float desc;
  float w;

  TextButton(String _string, float _x, float _y, int _size, color _hoverColour, int _h, int _v) {
    string = _string;
    x = _x;
    y = _y;
    h = _h;
    v = _v;
    size = _size;
    hoverColour = _hoverColour;
    defaultColour = black;
    textSize(size*density);
    asc = textAscent();
    desc = textDescent();
    w = textWidth(string);
  }

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
    textAlign(h, v);
    text(string, x, y);
    popStyle();
  }

  boolean mouseCollide() {
    rect((x-h)-(w/2), (y-v)-(asc/2), w, asc+desc);
    return mouseX >= x-(w/2) && mouseX <= x+(w/2) && mouseY >= y-(asc/2) && mouseY <= y+((asc/2)+desc);
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
  if ((gameState != "mainMenu") && (gameState != "newGame")) {
    pushStyle();
    textAlign(RIGHT, TOP);
    backButton.display();
    popStyle();
  }
  switch(gameState) {
  case "mainMenu":
    newGameButton.display();
    loadButton.display();
    quitButton.display();
    break;
  case "newGame":
    int traitsPicked = 0;
    pushStyle();
    textSize(28*density);
    text(textBoxHeader, width/2, height*0.1);
    rectMode(CENTER);
    stroke(1);
    noFill();
    rect(centerX, textBoxRectY, textBoxRectW, textBoxRectH);
    textSize(26*density);
    text(textBoxString, centerX, textBoxRectY);
    popStyle();

    if (entered) {
      maleButton.display();
      femaleButton.display();

      if (genderPicked) {
        pushStyle();
        textAlign(RIGHT);
        fill(blue);
        textSize(24*density);
        text("Choose pet's nature:", width*0.45, height*0.60);
        textAlign(LEFT);
        fill(purple);
        text("Randomise pet's nature:", width*0.55, height*0.60);
        image(dice, diceX, diceY);
        popStyle();

        for (int i = 0; i < traits.length; i = i+1) {
          for (int j = 0; j < traits[i].length; j = j+1) {
            traits[i][j].display();
          }
          if (pet.nature[i] != null) {
            traitsPicked = traitsPicked+1;
          }
        }

        if (traitsPicked == 4) {
          startButton.display();
        }

        if (mousePressed && mouseX >= diceX-(dice.width/2) && mouseX <= diceX+(dice.width/2) && mouseY >= diceY-(dice.height/2) && mouseY <= diceY+(dice.height/2)) {
          for (int i = 0; i < traits.length; i = i+1) {
            int randi = int(random(traits[i].length));
            pet.nature[i] = traits[i][randi].string;
          }
          gameState = "playingGame";
        }
      }
    }
    break;
  case "playingGame":
    sleepButton.display();
    statsButton.display();
    feedButton.display();
    shopButton.display();
    break;
  case "stats":
    pushStyle();
    textAlign(LEFT);
    textSize(24*density);
    text("Name: " + pet.name, width*0.1, height*0.1);
    text("Gender: " + pet.gender, width*0.1, height*0.2);
    text("Nature: " + join(pet.nature, ", "), width*0.1, height*0.3);
    popStyle();
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
  if (backButton.mouseCollide()) {
    if (gameState == "playingGame") {
      gameState = "mainMenu";
    } else {
      gameState = "playingGame";
    }
  }
  switch(gameState) {
  case "mainMenu":
    if (newGameButton.mouseCollide()) {
      gameState = "newGame";
    } else if (loadButton.mouseCollide()) {
      gameState = "loadGame";
    } else if (quitButton.mouseCollide()) {
    }
    break;
  case "newGame":
    if (mouseX >= centerX-(textBoxRectW/2) && mouseX <= centerX+(textBoxRectW/2) && mouseY >= textBoxRectY-(textBoxRectH/2) && mouseY <= textBoxRectY+(textBoxRectH/2)) {
      openKeyboard();
    } else {
      closeKeyboard();
    }
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
    for (int i = 0; i < traits.length; i = i+1) {
      for (int j = 0; j < traits[i].length; j = j+1) {
        if (traits[i][j].mouseCollide()) {
          traits[i][j].defaultColour = traits[i][j].hoverColour;
          pet.nature[i] = traits[i][j].string;
          if (j == 0) {
            traits[i][j+1].defaultColour = black;
          } else {
            traits[i][j-1].defaultColour = black;
          }
        }
      }
    }
    if (startButton.mouseCollide()) {
      gameState = "playingGame";
    }
    break;
  case "playingGame":
    if (sleepButton.mouseCollide()) {
    } else if (statsButton.mouseCollide()) {
      gameState = "stats";
    } else if (feedButton.mouseCollide()) {
    } else if (shopButton.mouseCollide()) {
    }
  }
}
