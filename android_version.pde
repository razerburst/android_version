//todo: save states screen (load menu), age has effect, turns green when health is low
//replace shop with upgrades? maybe maps (backgrounds) and rename feed to shop
//add instructions
//add coin minigame
//add game over screen (replay)
//fix snacks image width
//day/night background change
import android.util.DisplayMetrics;

int density;
float centerX;
float centerY;

color green = color(0, 255, 0);
color red = color(255, 0, 0);
color black = color(0);
color lightBlue = color(94, 228, 255);
color blue = color(11, 5, 201);
color orange = color(255, 217, 0);
color magenta = color(255, 68, 149);
color purple = color(199, 55, 173);
color brown = color(158, 55, 0);
color yellow = color(247, 228, 23);

Pet pet;
Time time;
enum gameState {
  MAINMENU, 
    NEWGAME, 
    LOAD, 
    QUIT, 
    PLAYING, 
    STATS, 
    FEED,
}
gameState currentState = gameState.PLAYING;
String textBoxHeader = "Enter a name for your new pet:";
String textBoxString = "";
float textBoxRectW;
float textBoxRectH;
float textBoxRectX;
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

Consumable cookie;
Consumable petFood;
Consumable snacks;
Consumable healthPack;
Consumable bandage;
Consumable sleepingPill;

int startTime;
int barTimer;
int startDayTimer;
int notTiredTimer;
int notHungryTimer;
int petAsleepTimer;
int bandageTimer;

Bar healthBar;
Bar hungerBar;
Bar fatigueBar;
Bar happinessBar;

int money = 0;
PImage moneyImg;

Coin[] coins = new Coin[5];

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

  //something to do with sleep
  traits[0][0] = new TextButton("Early Bird", width*0.18, height*0.68, 24, lightBlue);
  traits[0][1] = new TextButton("Night Owl", width*0.38, height*0.68, 24, lightBlue);
  //if energetic, hungrier faster, if lethargic, hungrier slower
  //if energetic, lose more weight when active, if lethargic, lose less weight when active
  traits[1][0] = new TextButton("Energetic", width*0.18, height*0.76, 24, green);
  traits[1][1] = new TextButton("Lethargic", width*0.38, height*0.76, 24, green);
  traits[2][0] = new TextButton("Impatient", width*0.18, height*0.84, 24, orange);
  traits[2][1] = new TextButton("Composed", width*0.38, height*0.84, 24, orange);
  //quotes are vary slightly if friendly or hostile
  traits[3][0] = new TextButton("Friendly", width*0.18, height*0.92, 24, magenta);
  traits[3][1] = new TextButton("Hostile", width*0.38, height*0.92, 24, magenta);

  startButton = new TextButton("Start!", centerX, height*0.45, 34, green);
  backButton = new TextButton("Back", width*0.94, height*0.04, 34, red);

  pushStyle();
  textSize(28*density);
  textBoxRectW = textWidth(textBoxHeader);
  textBoxRectH = textAscent()+(textDescent()*2);
  textBoxRectX = centerX;
  textBoxRectY = height*0.2;
  popStyle();

  dice = loadImage("Dice.png");
  diceX = width*0.75;
  diceY = height*0.76;

  cookie = new Consumable("Cookie", "Cookie.png", width*0.24, height*0.16, 3, 7, 10, 6);
  petFood = new Consumable("Pet Food", "PetFood.png", width*0.24, height*0.49, 6, 3, 30, 12);
  snacks = new Consumable("Snacks", "Snacks.png", width*0.24, height*0.82, 4, 5, 20, 9);

  healthPack = new Consumable("Health Pack", "HealthPack.png", width*0.76, height*0.16, 10, "Restores 10 health");
  bandage = new Consumable("Bandage", "Bandage.png", width*0.76, height*0.49, 6, "Stops health loss for 3 seconds");
  sleepingPill = new Consumable("Sleeping Pill", "SleepingPill.png", width*0.76, height*0.82, 8, "Reduces fatigue by 50% of current fatigue");

  healthBar = new Bar(width*0.03, height*0.15, red, "Health");
  hungerBar = new Bar(width*0.03, height*0.3, brown, "Hunger");
  fatigueBar = new Bar(width*0.03, height*0.45, blue, "Fatigue");
  happinessBar = new Bar(width*0.03, height*0.6, yellow, "Happiness");

  moneyImg = loadImage("Money.png");

  for (int i = 0; i < coins.length; i++) {
    coins[i] = new Coin(1+(i/10.0));
  }
}

//general use functions
boolean rectMouseCollide(float x, float y, float w, float h, int mode) {
  if (mode == CENTER) {
    return mouseX >= x-(w/2) && mouseX <= x+(w/2) && mouseY >= y-(h/2) && mouseY <= y+(h/2);
  } else if (mode == CORNER) {
    return mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h;
  } else {
    return false;
  }
}

boolean circleMouseCollide(float x, float y, float d) {
  return (dist(x, y, mouseX, mouseY) <= d/2);
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
  boolean pressed = false;

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
    return mouseX >= x-(w/2) && mouseX <= x+(w/2) && mouseY >= y-(asc/2) && mouseY <= y+(asc/2)+desc;
  }
}

class Pet {
  String name;
  String gender;
  int age;
  String[] nature = new String[4];
  float health = 100;
  float hunger = 0;
  float fatigue = 0;
  float happiness = 100;
  float weight = 4000;
  //weight is in grams, displayed in KG
  float baseRate;
  float healthRate;
  float hungerRate;
  float fatigueRate;
  float happinessRate;
  float weightRate;
  float sleepRate;
  Animation sprite;
  boolean asleep = false;
  boolean losingHealth = false;

  Pet() {
    sprite = new Animation("Pet.png", centerX, centerY, 1440, 576, 2, 5);
  }

  void calculateRates() {
    //bar reaches 100% after 18000 frames (5 minutes)
    baseRate = 100.0/(5*60*frameRate);
    //Rates increase by 1% for every 1% of other stats missing/gained, up three times greater rate for each stat
    if (pet.nature[1] == "Lethargic") {
      weightRate = (weight-4000)/1000;
      //every kg increases hunger rate by 100%
    } else if (pet.nature[1] == "Energetic") {
      weightRate = (weight-4000)/500;
      //every kg increases hunger rate by 200%, so more hunger in less time
    }

    healthRate = baseRate * (1+((hunger/75)+(fatigue/75)+((100-happiness)/75)));
    hungerRate = baseRate * (1+(((100-health)/100)+(fatigue/100)+((100-happiness)/100)+weightRate));
    fatigueRate = baseRate * (1+(((100-health)/100)+(hunger/100)+((100-happiness)/100)));
    happinessRate = baseRate * (1+(((100-health)/100)+(fatigue/100)+(hunger/100)));

    //healthRate = baseRate;
    //hungerRate = baseRate;
    //fatigueRate = baseRate;
    //happinessRate = baseRate;

    if (time.hours > 0 && time.hours < 6) {
      sleepRate = fatigueRate*12;
      //takes two hours to sleep 100%
    } else {
      sleepRate = fatigueRate*8;
      //takes three hours to sleep 100%
    }
  }

  void updateStats() {
    //if any of them are true, lose health, otherwise (if all of them are not true), regenerate health
    barTimer = millis();
    if ((hunger >= 25) || (fatigue >= 25) || (happiness <= 75)) {
      health -= healthRate;
      losingHealth = true;
    } else {
      health += healthRate;
      losingHealth = false;
    }
    hunger += hungerRate;
    if (asleep) {
      fatigue -= sleepRate;
    } else {
      fatigue += fatigueRate;
    }
    happiness -= happinessRate;

    health = constrain(health, 0, 100);
    hunger = constrain(hunger, 0, 100);
    fatigue = constrain(fatigue, 0, 100);
    happiness = constrain(happiness, 0, 100);
  }

  void updateAge() {
    if (millis()-startDayTimer >= (5*60*1000)) {
      pet.age += 1;
      startDayTimer = millis();
    }
  }

  void displaySprite() {    
    if (asleep) {
      sprite.display(8, 2);
    } else if (happiness >= 75) {
      sprite.display(0, 2);
    } else if (happiness >= 50) {
      sprite.display(2, 2);
    } else if (happiness >= 25) {
      sprite.display(4, 2);
    } else {
      sprite.display(6, 2);
    }
  }

  void autoWake() {
    if (asleep) {
      if (fatigue <= 0) {
        asleep = false;
      }
    }
  }
}

class Time {
  int millis;
  int multiplier = (24*60)/5;
  //1 minute in real life = 288 minutes in game
  float seconds;
  float minutes;
  float hours;

  void update() {
    millis = (millis()-startTime)*multiplier;
    seconds = millis/1000.0;
    minutes = seconds/60.0;
    hours = (minutes/60.0)%24;
  }

  String AM_or_PM() {
    if ((hours >= 0) && (hours < 12)) {
      return "AM";
    } else {
      return "PM";
    }
  }

  void display(float x, float y, int alignX, int alignY) {
    String clock = nf(int(hours), 2) + ":" + nf(int(minutes)%60, 2);
    pushStyle();
    textAlign(alignX, alignY);
    textSize(26*density);
    text(clock + AM_or_PM(), x, y);
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

  Bar(float _x, float _y, color _colour, String _name) {
    x = _x;
    y = _y;
    colour = _colour;
    name = _name;
  }

  void display(float x, float y, float value) {
    pushStyle();
    noFill();
    stroke(0);
    strokeWeight(8);
    rect(x-4, y-4, w+8, h+8);

    textAlign(CENTER, BOTTOM);
    textSize(20*density);
    text(name, x+(w/2), y-8);

    fill(colour);
    noStroke();
    rect(x, y, value*5, h);
    textAlign(CENTER, CENTER);
    textSize(20*density);
    fill(0);
    text(int(value) + "%", x+(w/2), y+(h/2));
    popStyle();
  }
}

class Consumable {
  String name;
  String filename;
  float x;
  float y;
  int w;
  int h;
  int price;
  int happiness;
  int weight;
  int hunger;
  String description;
  PImage img;
  int amount = 0;
  int buttonW = 140;
  int buttonH = 65;
  TextButton buyButton;
  TextButton sellButton;
  boolean pressed = false;

  Consumable(String _name, String _filename, float _x, float _y, int _price, int _happiness, int _weight, int _hunger) {
    name = _name;
    filename = _filename;
    x = _x;
    y = _y;
    price = _price;
    happiness = _happiness;
    weight = _weight;
    hunger = _hunger;
    description = "Happiness: +" + happiness + "\nWeight: +" + weight + "\nHunger: -" + hunger;
    img = loadImage(filename);
    w = img.width;
    h = img.height;
    buyButton = new TextButton("Buy", x-(buttonW/2)-14, y+(h/2)+(buttonH/2)+13, 24, purple);
    sellButton = new TextButton("Sell", x+(buttonW/2)+14, y+(h/2)+(buttonH/2)+13, 24, purple);
  }

  Consumable(String _name, String _filename, float _x, float _y, int _price, String _description) {
    name = _name;
    filename = _filename;
    x = _x;
    y = _y;
    price = _price;
    description = _description;
    img = loadImage(filename);
    w = img.width;
    h = img.height;
    buyButton = new TextButton("Buy", x-(buttonW/2)-14, y+(h/2)+(buttonH/2)+13, 24, purple);
    sellButton = new TextButton("Sell", x+(buttonW/2)+14, y+(h/2)+(buttonH/2)+13, 24, purple);
  }

  void display() {
    image(img, x, y);
    pushStyle();
    textAlign(CENTER, BOTTOM);
    textSize(18*density);
    text(name + "($" + price + ")", x, y-(h/2));
    if (x <= centerX) {
      textAlign(RIGHT, CENTER);
      textSize(18*density);
      text(description, (x-(w/2))-10, y);
      textAlign(LEFT, CENTER);
      textSize(20*density);
      text(" " + "X" + amount, x+(w/2), y);
    } else {
      textAlign(LEFT, CENTER);
      rectMode(CORNERS);
      textSize(16*density);
      text(description, (x+(w/2))+10, y-(h/2), width, y+(textAscent()*3));
      textAlign(RIGHT, CENTER);
      textSize(20*density);
      text(amount + "X" + " ", x-(w/2), y);
    }
    popStyle();

    pushStyle();
    rectMode(CORNER);
    stroke(0);
    strokeWeight(8);
    fill(lightBlue);
    rect(buyButton.x-(buttonW/2), buyButton.y-(buttonH/2), buttonW, buttonH+buyButton.desc);
    rect(sellButton.x-(buttonW/2), sellButton.y-(buttonH/2), buttonW, buttonH+sellButton.desc);
    popStyle();

    buyButton.display();
    sellButton.display();
  }

  void onEat() {
    if (mouseCollide() && amount > 0) {
      if (pet.asleep) {
        petAsleepTimer = frameCount;
      } else if (pet.hunger < 1) {
        notHungryTimer = frameCount;
      } else {
        pet.happiness += happiness;
        pet.weight += weight;
        pet.hunger -= hunger;
        amount -= 1;
        pet.happiness = constrain(pet.happiness, 0, 100);
        pet.hunger = constrain(pet.hunger, 0, 100);
      }
    }
  }

  void onUse() {
    if (mouseCollide() && money >= price && amount > 0) {
      if (name == "Health Pack") {
        pet.health += 10;
        amount -= 1;
      } else if (name == "Bandage") {
        if (pet.losingHealth) {
          bandageTimer = frameCount;
          amount -= 1;
        }
      } else if (name == "Sleeping Pill") {
        pet.fatigue -= pet.fatigue*0.5;
        amount -= 1;
      }
    }
  }

  void onBuy() {
    if (buyButton.mouseCollide() && money >= price) {
      money -= price;
      amount += 1;
    }
  }

  void onSell() {
    if (sellButton.mouseCollide() && amount > 0) {
      amount -= 1;
      money += price;
    }
  }

  boolean mouseCollide() {
    return circleMouseCollide(x, y, img.width);
  }
}

class Animation {
  String filename;
  float x;
  float y;
  int w;
  int h;
  int rows;
  int columns;
  int imgW;
  int imgH;
  int currentFrame = 0;
  PImage spritesheet;
  PImage[] frames;

  Animation(String _filename, float _x, float _y, int _w, int _h, int _rows, int _columns) {
    filename = _filename;
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    rows = _rows;
    columns = _columns;
    spritesheet = loadImage(filename);
    frames = new PImage[rows*columns];
    imgW = w/columns;
    imgH = h/rows;
    int index = 0;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        int imgX = imgW*j;
        int imgY = imgH*i;
        PImage img = spritesheet.get(imgX, imgY, imgW, imgH);
        frames[index] = img;
        index += 1;
      }
    }
  }

  void display(int start, int numFrames) {
    PImage[] displayFrames = (PImage[]) subset(frames, start, numFrames);
    image(displayFrames[currentFrame%displayFrames.length], x, y);
    if (frameCount % 60 == 0) {
      currentFrame += 1;
    }
  }
}

class Coin {
  PImage img;
  float x;
  float y;
  float displayInterval;
  int hideTimer = 0;
  int showTimer = 0;
  boolean hide = true;
  boolean show = false;
  boolean initialDelay = false;

  Coin(float _displayInterval) {
    displayInterval = _displayInterval;
    img = loadImage("Coin.png");
    calculatePosition();
  }

  void calculatePosition() {
    x = random(healthBar.x+healthBar.w+4+(img.width/2), width-(img.width/2));
    y = random(backButton.y+backButton.desc+(img.height/2), shopButton.y-shopButton.asc);
  }

  void display() {
    if (show) {
      if (frameCount - showTimer < 60) {
        image(img, x, y);
      } else {
        if (!initialDelay) {
          displayInterval = 1;
          initialDelay = true;
        }
        show = false;
        hideTimer = frameCount;
        calculatePosition();
      }
    } else if (frameCount - hideTimer > 60*displayInterval) {
      hide = false;
      show = true;
      showTimer = frameCount;
    }
  }

  boolean mouseCollide() {
    return circleMouseCollide(x, y, img.width);
  }
}

void draw() {
  background(255);
  //automatic events
  if (currentState == gameState.PLAYING || currentState == gameState.LOAD || currentState == gameState.STATS || currentState == gameState.FEED) {
    backButton.display();
    if (currentState != gameState.LOAD) {
      time.update();
      pet.calculateRates();
      pet.updateStats();
      pet.updateAge();
      pet.autoWake();
      if (pet.losingHealth && frameCount - bandageTimer < frameRate*3) {
        pet.health += pet.healthRate;
      }
      if (currentState != gameState.FEED) {
        time.display(width*0.01, height*0.01, LEFT, TOP);
      }
    }
  }

  switch(currentState) {
  case MAINMENU:
    newGameButton.display();
    loadButton.display();
    quitButton.display();
    break;

  case NEWGAME:
    traitsPicked = 0;
    pushStyle();
    textSize(28*density);
    text(textBoxHeader, width/2, height*0.1);
    rectMode(CENTER);
    stroke(1);
    noFill();
    rect(textBoxRectX, textBoxRectY, textBoxRectW, textBoxRectH);
    textSize(26*density);
    text(textBoxString, textBoxRectX, textBoxRectY);
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

        if (mousePressed && rectMouseCollide(diceX, diceY, dice.width, dice.height, CENTER)) {
          for (int i = 0; i < traits.length; i = i+1) {
            int randi = int(random(traits[i].length));
            pet.nature[i] = traits[i][randi].string;
          }
          currentState = gameState.PLAYING;
          startTime = millis();
          startDayTimer = millis();
        }
      }
    }
    break;

  case PLAYING:
    if (pet.asleep) {
      sleepButton.string = "Wake";
    } else {
      sleepButton.string = "Sleep";
    }

    sleepButton.display();
    statsButton.display();
    feedButton.display();
    shopButton.display();

    if (sleepButton.pressed && pet.fatigue < 10) {
      if (frameCount - notTiredTimer < frameRate) {
        pushStyle();
        pushMatrix();
        translate(pet.sprite.x + (pet.sprite.imgW/2), pet.sprite.y);
        fill(lightBlue);
        triangle(0, 0, 100, -100, 100, -50);
        textAlign(LEFT, CENTER);
        textSize(20*density);
        String s = "I'm not tired!";
        float textW = textWidth(s);
        ellipse(100 + (textW/2), -75, textW+50, 200);
        fill(0);
        text(s, 100, -75);
        popMatrix();
        popStyle();
      } else {
        sleepButton.pressed = false;
      }
    }

    healthBar.display(width*0.03, height*0.15, pet.health);
    hungerBar.display(width*0.03, height*0.3, pet.hunger);
    fatigueBar.display(width*0.03, height*0.45, pet.fatigue);
    happinessBar.display(width*0.03, height*0.6, pet.happiness);

    pet.displaySprite();

    pushStyle();
    textSize(20*density);
    text("Money", width*0.16, height*0.7);
    image(moneyImg, width*0.16-(moneyImg.width/2), height*0.78);
    textAlign(LEFT, CENTER);
    text("X" + money, width*0.16, height*0.78);
    popStyle();

    for (int i = 0; i < 2; i++) {
      Coin coin = coins[i];
      coin.display();
      if (coin.show && frameCount - coin.showTimer < 60) {
        text(i, coin.x, coin.y);
      }
      if (coin.mouseCollide()) {
        coin.show = false;
        coin.hide = true;
        coin.hideTimer = frameCount;
        money += 1;
        coin.calculatePosition();
      }
    }
    break;

  case STATS:
    pushStyle();
    textAlign(LEFT);
    textSize(24*density);
    text("Name: " + pet.name, width*0.1, height*0.2);
    text("Gender: " + pet.gender, width*0.1, height*0.3);
    text("Nature: " + join(pet.nature, ", "), width*0.1, height*0.4);
    text("Weight: " + pet.weight/1000 + "KG", width*0.1, height*0.5);
    text("Age: " + pet.age + " day(s) old", width*0.1, height*0.6);
    popStyle();
    break;

  case FEED:
    time.display(centerX, height*0.01, CENTER, TOP);

    //half bar length (because original x and y of bar is top, left not center)
    healthBar.display(centerX-250, height*0.15, pet.health);
    hungerBar.display(centerX-250, height*0.3, pet.hunger);
    fatigueBar.display(centerX-250, height*0.45, pet.fatigue);
    happinessBar.display(centerX-250, height*0.6, pet.happiness);

    cookie.display();
    petFood.display();
    snacks.display();
    healthPack.display();
    bandage.display();
    sleepingPill.display();

    pushStyle();
    textSize(20*density);
    text("Money", centerX, height*0.7);
    image(moneyImg, centerX-(moneyImg.width/2), height*0.78);
    textAlign(LEFT, CENTER);
    text("X" + money, centerX, height*0.78);
    popStyle();

    if (cookie.mouseCollide() || petFood.mouseCollide() || snacks.mouseCollide()) {
      pushStyle();
      textSize(20*density);
      textAlign(LEFT, TOP);
      fill(lightBlue, 100);
      if (frameCount - notHungryTimer < frameRate && notHungryTimer != -1) {
        if (pet.hunger < 1) {
          String s = "Pet is not hungry!";
          rect(mouseX, mouseY, textWidth(s), textAscent()+textDescent());
          fill(0);
          text(s, mouseX, mouseY);
        } else {
          //stop timer when hunger exceeds 1
          notHungryTimer = -1;
        }
      } else if (frameCount - petAsleepTimer < frameRate && petAsleepTimer != -1) {
        if (pet.asleep) {
          String s = "Pet is asleep!";
          rect(mouseX, mouseY, textWidth(s), textAscent()+textDescent());
          fill(0);
          text(s, mouseX, mouseY);
        }
      } else {
        //stops timer when pet wakes up
        petAsleepTimer = -1;
      }
      popStyle();
    }
    break;

  case LOAD:
    break;
  }
}

void keyPressed() {
  if (currentState == gameState.NEWGAME) {
    if (keyCode == BACKSPACE) {
      if (textBoxString.length() > 0) {
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

//detect taps
void mouseReleased() {
  if (backButton.mouseCollide()) {
    if (currentState == gameState.PLAYING || currentState == gameState.LOAD) {
      currentState = gameState.MAINMENU;
    } else if (currentState == gameState.STATS || currentState == gameState.FEED) {
      currentState = gameState.PLAYING;
    }
  }

  switch(currentState) {
  case MAINMENU:
    if (newGameButton.mouseCollide()) {
      currentState = gameState.NEWGAME;
    } else if (loadButton.mouseCollide()) {
      currentState = gameState.LOAD;
    } else if (quitButton.mouseCollide()) {
    }
    break;

  case NEWGAME:
    if (rectMouseCollide(textBoxRectX, textBoxRectY, textBoxRectW, textBoxRectH, CENTER)) {
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
            currentState = gameState.PLAYING;
            startTime = millis();
            startDayTimer = millis();
          }
        }
      }
    }
    break;

  case PLAYING:
    if (sleepButton.mouseCollide()) {
      sleepButton.pressed = true;
      if (sleepButton.string == "Wake") {
        pet.asleep = false;
      } else if (sleepButton.string == "Sleep") {
        if (pet.fatigue >= 10) {
          pet.asleep = true;
        } else {
          pet.asleep = false;
          notTiredTimer = frameCount;
        }
      }
    } else if (statsButton.mouseCollide()) {
      currentState = gameState.STATS;
    } else if (feedButton.mouseCollide()) {
      currentState = gameState.FEED;
    } else if (shopButton.mouseCollide()) {
    }
    break;

  case FEED:
    cookie.onEat();
    petFood.onEat();
    snacks.onEat();
    healthPack.onUse();
    bandage.onUse();
    sleepingPill.onUse();

    cookie.onBuy();
    petFood.onBuy();
    snacks.onBuy();
    healthPack.onBuy();
    bandage.onBuy();
    sleepingPill.onBuy();

    cookie.onSell();
    petFood.onSell();
    snacks.onSell();
    healthPack.onSell();
    bandage.onSell();
    sleepingPill.onSell();
    break;
  }
}
