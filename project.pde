float centerX;
float centerY;
String gameState = "mainMenu";
String textBoxHeader = "Enter a name for your new pet:";
String textBox = "";

TextButton newGameButton;
TextButton loadButton;
TextButton quitButton;

void setup() {
  fullScreen();
  noStroke();
  fill(0);
  centerX = width/2;
  centerY = height/2;
  textAlign(CENTER, CENTER);

  newGameButton = new TextButton("New game", centerX, centerY, 32);
  loadButton = new TextButton("Load", centerX, height*0.6, 32);
  quitButton = new TextButton("Quit", centerX, height*0.7, 32);
}

class TextButton {
  String string;
  float x;
  float y;
  int size;
  float asc;
  float desc;
  float w;

  TextButton(String _string, float _x, float _y, int _size) {
    string = _string;
    x = _x;
    y = _y;
    size = _size;
    textSize(size);
    asc = textAscent();
    desc = textDescent();
    w = textWidth(string);
  }

  void display() {
    pushStyle();
    textSize(size);
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

  void mouseHover() {
    if (mouseCollide()) {
      pushStyle();
      fill(0, 255, 0);
      display();
      popStyle();
    } else {
      pushStyle();
      fill(0);
      display();
      popStyle();
    }
  }
}

void draw() {
  background(255);
  pushStyle();
  stroke(0);
  strokeWeight(1);
  line(0, centerY, width, centerY);
  line(centerX, 0, centerX, height);
  popStyle();
  switch(gameState) {
  case "mainMenu":
    newGameButton.mouseHover();
    loadButton.mouseHover();
    quitButton.mouseHover();

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
    text(textBoxHeader, width/2, height*0.4);
    rectMode(CENTER);
    stroke(1);
    noFill();
    rect(width/2, (height/2)+textDescent(), textWidth(textBoxHeader)*1.05, textAscent()*1.2);
    text(textBox, width/2, height/2);
    popStyle();
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
      if (textBox.length() >0) {
        textBox = textBox.substring(0, textBox.length()-1);
      }
    } else if (key == ENTER) {
      print("test");
    } else {
      if (textWidth(textBox) <= textWidth(textBoxHeader)) {
        textBox += key;
      }
    }
  }
}
