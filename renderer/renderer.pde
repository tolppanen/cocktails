/* This class is for drawing stuff on the table, around the bottles and the glass */

int heightY = 720;
int widthX = 1280;

int counter = 0;

ArrayList<Bottle> bottles = new ArrayList<Bottle>();


void setup() {
  size(widthX, heightY);
  background(0, 0, 0);
  testData();
}

void draw() {
  for (Bottle bottle : bottles) {
    bottle.drawThis(counter);
  }
  counter = (counter < 60) ? counter + 1 : 0;
}

void testData() {
  bottles.add(new Bottle("Vodka", 90, 90, 50));
  bottles.add(new Bottle("Rum", 600, 600, 80));
  bottles.add(new Bottle("Cola", 180, 500, 100));
  bottles.add(new Bottle("Sprite", 900, 300, 70));
  bottles.add(new Bottle("Something", 1000, 200, 80));
}
  
