//todo: save states screen (load menu), change size of texts, fix positioning of bars
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
color brown = color(158, 55, 0);
color yellow = color(247, 228, 23);

Pet pet;
Time time;
String gameState = "playingGame";
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
int traitsPicked;
TextButton maleButton;

TextButton femaleButton;
TextButton[][] traits = new TextButton[4][2];
TextButton startButton;
TextButton backButton;

PImage dice;
float diceX;
float diceY;

int startTime = 0;

Bar healthBar;
Bar hungerBar;
Bar fatigueBar;
Bar happinessBar;

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
  time = new Time();

  newGameButton = new TextButton("New game", centerX, height*0.4, 32, green);
  loadButton = new TextButton("Load", centerX, height*0.6, 32, green);
  quitButton = new TextButton("Quit", centerX, height*0.8, 32, green);

  sleepButton = new TextButton("Sleep", width*0.086, height*0.9, 32, purple);
  statsButton = new TextButton("Stats", width*0.36, height*0.9, 32, purple);
  feedButton = new TextButton("Feed", width*0.654, height*0.9, 32, purple);
  shopButton = new TextButton("Shop", width*0.92, height*0.9, 32, purple);

  maleButton = new TextButton("Male", width*0.4, height*0.33, 28, red);
  femaleButton = new TextButton("Female", width*0.6, height*0.33, 28, red);

  traits[0][0] = new TextButton("Early Bird", width*0.18, height*0.68, 24, lightBlue);
  traits[0][1] = new TextButton("Night Owl", width*0.38, height*0.68, 24, lightBlue);
  traits[1][0] = new TextButton("Energetic", width*0.18, height*0.76, 24, green);
  traits[1][1] = new TextButton("Lethargic", width*0.38, height*0.76, 24, green);
  traits[2][0] = new TextButton("Impatient", width*0.18, height*0.84, 24, orange);
  traits[2][1] = new TextButton("Composed", width*0.38, height*0.84, 24, orange);
  traits[3][0] = new TextButton("Friendly", width*0.18, height*0.92, 24, magenta);
  traits[3][1] = new TextButton("Hostile", width*0.38, height*0.92, 24, magenta);

  startButton = new TextButton("Start!", centerX, height*0.45, 34, green);
  backButton = new TextButton("Back", width*0.93, height*0.05, 34, red);

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

  healthBar = new Bar(width*0.03, height*0.15, red, "Health");
  hungerBar = new Bar(width*0.03, height*0.3, brown, "Hunger");
  fatigueBar = new Bar(width*0.03, height*0.45, blue, "Fatigue");
  happinessBar = new Bar(width*0.03, height*0.6, yellow, "Happiness");
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
    if (mouseCollide() && mousePressed) {
      fill(hoverColour);
    } else {
      fill(defaultColour);
    }
    text(string, x, y);
    popStyle();
  }

  boolean mouseCollide() {
    return mouseX >= x-(w/2) && mouseX <= x+(w/2) && mouseY >= y-(asc/2) && mouseY <= y+((asc/2)+desc);
  }
}

class Pet {
  String name;
  String gender;
  String[] nature = new String[4];
  float health = 100.0;
  float hunger = 0.0;
  float fatigue = 0.0;
  float happiness = 100;
  float baseRate = 100.0/(5*60*60);

  Pet() {
  }

  void updateStats() {
    hunger += baseRate;
    fatigue += baseRate;
    happiness -= baseRate;
  }
}

class Time {
  int frames;
  int multiplier;
  float seconds;
  float minutes;
  float hours;

  Time() {
    multiplier = (24*60)/5;
    //5 minutes in real life = 1440 minutes in gamesta
    //1 minute in real life = 288 minutes in game
  }

  void update() {
    frames = (frameCount-startTime)*multiplier;
    seconds = frames/60.0;
    minutes = seconds/60.0;
    hours = minutes/60.0;
  }

  String AM_or_PM() {
    if ((hours%24 >= 0) && (hours%24 < 12)) {
      return "AM";
    } else {
      return "PM";
    }
  }

  void display() {
    String clock = nf(int(hours)%24, 2) + ":" + nf(int(minutes)%60, 2);
    pushStyle();
    textAlign(LEFT, TOP);
    textSize(26*density);
    text(clock, width*0.01, height*0.01);
    text(AM_or_PM(), width*0.01 + textWidth(clock), height*0.01);
    popStyle();
  }
}

class Bar {
  float x;
  float y;
  float w = 500;
  float h = 65;
  color colour;
  String name;
  float value;

  Bar(float _x, float _y, color _colour, String _name) {
    x = _x;
    y = _y;
    colour = _colour;
    name = _name;
  }

  void updateValue() {
    if (name == "Health") {
      value = pet.health;
    } else if (name == "Hunger") {
      value = pet.hunger;
    } else if (name == "Fatigue") {
      value = pet.fatigue;
    } else if (name == "Happiness") {
      value = pet.happiness;
    }
  }

  void display() {
    pushStyle();
    fill(0);
    stroke(0);
    strokeWeight(8);
    rect(x, y, w, h);

    textAlign(CENTER, BOTTOM);
    textSize(24*density);
    text(name, x+(w/2), y-4);

    fill(colour);
    rect(x, y, w, h);

    textAlign(CENTER, CENTER);
    textSize(20*density);
    fill(0);
    updateValue();
    text(value + "%", x+(w/2), y+(h/2));
    popStyle();
  }
}

void draw() {
  background(255);

  if ((gameState != "mainMenu") && (gameState != "newGame")) {
    backButton.display();
    if (gameState != "loadGame") {
      time.update();
      time.display();
    }
  }

  switch(gameState) {
  case "mainMenu":
    newGameButton.display();
    loadButton.display();
    quitButton.display();
    break;

  case "newGame":
    traitsPicked = 0;
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
        fill(blue);
        textSize(24*density);
        text("Choose pet's nature:", width*0.28, height*0.60);
        fill(purple);
        text("Randomise pet's nature:", width*0.75, height*0.60);
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
          startTime = frameCount;
        }
      }
    }
    break;

  case "playingGame":
    sleepButton.display();
    statsButton.display();
    feedButton.display();
    shopButton.display();

    pet.updateStats();

    healthBar.display();
    hungerBar.display();
    fatigueBar.display();
    happinessBar.display();
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
  if ((gameState != "mainMenu") && (gameState != "newGame")) {
    if (backButton.mouseCollide()) {
      if (gameState == "playingGame" || gameState == "loadGame") {
        gameState = "mainMenu";
      } else {
        gameState = "playingGame";
      }
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

    if (entered) {
      if (maleButton.mouseCollide()) {
        maleButton.defaultColour = red;
        femaleButton.defaultColour = black;
        pet.gender = "Male";
        genderPicked = true;
      } else if (femaleButton.mouseCollide()) {
        femaleButton.defaultColour = red;
        maleButton.defaultColour = black;
        pet.gender = "Female";
        genderPicked = true;
      }

      if (genderPicked) {
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

        if (traitsPicked == 4) {
          if (startButton.mouseCollide()) {
            gameState = "playingGame";
            startTime = frameCount;
          }
        }
      }
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
