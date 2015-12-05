/* This class is for drawing stuff on the table, around the bottles and the glass */

int heightY = 720;
int widthX = 1280;

int counter = 0; // Counter used for rotating image to get the sweep effect

ArrayList<Bottle> bottles = new ArrayList<Bottle>();


void setup() {
  size(widthX, heightY);
  background(0, 0, 0);
  testData();
}

void draw() {
  
  // Clear all
  background(0, 0, 0);
  
  //Draw the mixing glass
  fill(color(0, 255, 0));
  ellipse(width/2, 30, 30, 30);
  
  //Draw all the bottles
  for (Bottle bottle : bottles) {
    bottle.drawThis(counter);
  }
  counter = (counter < 120) ? counter + 1 : 0;
}

// The following pieces of code are here for testing: 
// Dummy data & mouse events for controlling the bottles.

void testData() {
  bottles.add(new Bottle("Vodka", 90, 90, 50));
  bottles.add(new Bottle("Rum", 600, 200, 80));
  bottles.add(new Bottle("Cola", 180, 500, 100));
  bottles.add(new Bottle("Sprite", 900, 300, 70));
  bottles.add(new Bottle("Something", 1000, 200, 80));
}

void mouseClicked() {
  for (Bottle bottle : bottles) {
    if (bottle.isHere(mouseX, mouseY)) {
      bottle.toggleSelect();
      bottle.toggleIncluded();
    }
  }
}
