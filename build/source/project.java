import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class project extends PApplet {

float centerX;
float centerY;
String gameState = "mainMenu";
String textBoxHeader = "Enter a name for your new pet:";
String textBox = "";

TextButton newGameButton;
TextButton loadButton;
TextButton quitButton;

public void setup() {
  
  noStroke();
  fill(0);
  centerX = width/2;
  centerY = height/2;
  textAlign(CENTER, CENTER);

  newGameButton = new TextButton("New game", centerX, centerY, 32);
  loadButton = new TextButton("Load", centerX, height*0.6f, 32);
  quitButton = new TextButton("Quit", centerX, height*0.7f, 32);
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

  public void display() {
    pushStyle();
    textSize(size);
    text(string, x, y-desc);
    popStyle();
  }

  public boolean mouseCollide() {
    if (mouseX >= x-(w/2) && mouseX <= x+(w/2) && mouseY >= y-(asc/2) && mouseY <= y+(asc/2)) {
      return true;
    } else {
      return false;
    }
  }

  public void mouseHover() {
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

public void draw() {
  background(255);
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
    text(textBoxHeader, width/2, height*0.4f);
    rectMode(CENTER);
    stroke(1);
    noFill();
    rect(width/2, (height/2)+textDescent(), textWidth(textBoxHeader)*1.05f, textAscent()*1.2f);
    text(textBox, width/2, height/2);
    popStyle();
    break;
  case "loadGame":
    break;
  case "quit":
    break;
  }
}

public void keyTyped() {
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
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "project" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
