class Bottle {
  
  String bottleName;
  int locationX;
  int locationY;
  int radius;
  boolean selected = false;
  PImage sweep = loadImage("sweep2.png");
  
  Bottle(String name, int x, int y, int size) {
    bottleName = name;
    locationX = x;
    locationY = y;
    radius = size;
  };
  
  void drawThis(int counter) {
    float deg = 6.0 * counter;
    pushMatrix();
    translate(locationX - radius, locationY - radius);
    rotate(radians(-deg));
    imageMode(CENTER);
    image(sweep, 0, 0, 2 * radius, 2 * radius);
    fill(color(0,0,0));
    noStroke();
    ellipse(0, 0, 50, 50);
    popMatrix();
  }
  
  String toString() {
    return this.bottleName;
  };
  
}
