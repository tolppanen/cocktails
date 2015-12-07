class Bottle {

  Ingredient bottleName;
  int locationX;
  int locationY;
  int radius;
  boolean selected = false; // If it's the one to be poured now
  boolean included = false; // If it's included in the recipe at all
  PImage sweep = loadImage("Images/sweep3small.png");
  PImage redSweep = loadImage("Images/sweep3redsmall.png");
  PImage grid = loadImage("Images/pattern1greensmall.png");
  PImage gridRed = loadImage("Images/pattern1redsmall.png");

  Bottle(Ingredient name, int x, int y, int size) {
    bottleName = name;
    locationX = x;
    locationY = y;
    radius = size;
  };

  int[] location() {
    int[] res = new int[2];
    res[0] = locationX;
    res[1] = locationY;
    return res;
  }

  void moveToLocation(int x, int y) {
    locationX = x;
    locationY = y;
  }

  boolean isSelected() {
    return selected;
  };

  boolean isIncluded() {
    return included;
  }

  boolean isHere(int mx, int my) {
    if (abs(mx - locationX) < 100 && abs(my - locationY) < 100) {
      return true;
    } else {
      return false;
    }
  }

  void drawThis(int counter, int poured) {
    if (this.isIncluded()) {
      drawLine(poured/100.0);
    }
    float deg = 3.0 * counter;
    pushMatrix();
    translate(locationX, locationY);
    tint(255, 127);
    noStroke();
    fill(0, 0, 0);
    ellipse(0, 0, radius*3, radius*3);
    rotate(radians(-deg));
    imageMode(CENTER);
    if (this.isSelected()) {
      //println("Is selected");
      image(redSweep, 0, 0, 3 * radius, 3 * radius);
      image(gridRed, 0, 0, 3 * radius, 3 * radius);
    } else {
      image(sweep, 0, 0, 3 * radius, 3 * radius);
      tint(255, 127);
      image(grid, 0, 0, 3 * radius, 3* radius);
    }

    fill(color(0, 0, 0));
    stroke(0);
    ellipse(0, 0, 120, 120);
    strokeWeight(10);
    noFill();
    ellipse(0, 0, radius*2, radius*2);
    tint(255, 255);
    popMatrix();
  }

  void drawLine(float percentage) {
    stroke(green);
    strokeWeight(4);
    line(this.locationX, this.locationY, width/2, height - 80);
    if (this.isSelected()) {
      int deltaX = ((width/2) - this.locationX);
      int deltaY = (height - 80 - this.locationY);
      float endX = this.locationX + (percentage*deltaX);
      float endY = this.locationY + (percentage*deltaY);
      stroke(red);
      line(this.locationX, this.locationY, endX, endY);
    }
  }
  String toString() {
    return this.bottleName.toString();
  };
}