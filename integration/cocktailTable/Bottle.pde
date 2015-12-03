class Bottle {
  
  Ingredient bottleName;
  int locationX;
  int locationY;
  int radius;
  boolean selected = false;
  PImage sweep = loadImage("sweep2.png");
  
  Bottle(Ingredient name, int x, int y, int size) {
    bottleName = name;
    locationX = x;
    locationY = y;
    radius = size;
  };
  
  boolean isSelected() {
    return selected;
  };
  
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
    
  
  void drawThis(int counter) {
    float deg = 3.0 * counter;
    pushMatrix();
    translate(locationX - radius, locationY - radius);
    rotate(radians(-deg));
    imageMode(CENTER);
    image(sweep, 0, 0, 1.5 * radius, 1.5 * radius);
    fill(color(0,0,0));
    ellipse(0, 0, 50, 50);
    strokeWeight(8);
    noFill();
    ellipse(0, 0, radius, radius);
    if (this.isSelected()) {
      fill(color(255, 0, 0));
      ellipse(0, 0, 20, 20);
    }
    popMatrix();
  }
  
  String toString() {
    return this.bottleName.toString();
  };
  
}
