class Bottle {
  
  Ingredient bottleName;
  int locationX;
  int locationY;
  int radius;
  boolean selected = false;
 boolean included = false; // If it's included in the recipe at all
  PImage sweep = loadImage("Images/sweep3.png");
  PImage redSweep = loadImage("Images/sweep3red.png");
  PImage grid = loadImage("Images/pattern1green.png");
  PImage gridRed = loadImage("Images/pattern1red.png");
  
  Bottle(Ingredient name, int x, int y, int size) {
    bottleName = name;
    locationX = x;
    locationY = y;
    radius = size;
  };
  
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
  
  void toggleSelect() {
    this.selected = this.selected ? false : true;
  }
    
      void toggleIncluded() {
    this.included = this.included ? false : true;
  }
  
 void drawThis(int counter) {
    float deg = 3.0 * counter;
    pushMatrix();
    translate(locationX, locationY);
    rotate(radians(-deg));
    imageMode(CENTER);
    if (this.isSelected()) {
      image(redSweep, 0, 0, 1.5 * radius, 1.5 * radius);
      tint(255, 127);
      image(gridRed, 0, 0, 1.5 * radius, 1.5 * radius);
    } else {
      image(sweep, 0, 0, 1.5 * radius, 1.5 * radius);
      tint(255, 127);
      image(grid, 0, 0, 1.5 * radius, 1.5 * radius);
    }
    fill(color(0,0,0));
    stroke(0);
    ellipse(0, 0, 50, 50);
    strokeWeight(8);
    noFill();
    ellipse(0, 0, radius, radius);
    popMatrix();
    
    if (this.isIncluded()) {
      stroke(96, 255, 75);
      strokeWeight(5);
      line(this.locationX, this.locationY, width/2, height - 30);
    }
  }
  
  String toString() {
    return this.bottleName.toString();
  };
  
}
