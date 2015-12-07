import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;

// void setup() {
  // size(640, 480);
  // kinect = new Kinect(this);
  // kinect.initDepth();
  // kinect.initVideo();
  // // Lookup table for all possible depth values (0 - 2047)
  // for (int i = 0; i < depthLookUp.length; i++) {
  //   depthLookUp[i] = rawDepthToMeters(i);
  // }
// }

// We'll use a lookup table so that we don't have to repeat the math over and over
float[] depthLookUp = new float[2048];

float floorDistance = 0.81; // has to be determined at start; in meters
float distanceBuffer = 0.2; // in meters
int trackingSkip = 2; // tracking takes into account every trackingSkip:th pixel
int colorAverageArea = 5; // determines the size of the area from wich color average is calculated
int moveTreshold = 50; // how far does the bottle have to be in order to be moved

color vodkaColor = color(255, 0, 0); // pitää muuttaa oikeiksi arvoiksi
color jalluColor = color(0, 255, 0);
color tonicColor = color(0, 0, 255);
// color d = Todo;
// color e = Todo;
// color f = Todo;
// color g = Todo;
// color h = Todo;
// color i = Todo;
// color j = Todo;

color closestVodkaColor = color(255, 255, 255);
int vodkaDifference = 10000;
color closestJalluColor = color(255, 255, 255);
int jalluDifference = 10000;
color closestTonicColor = color(255, 255, 255);
int tonicDifference = 10000;

int closestVodkaX = 0;
int closestVodkaY = 0;
int closestJalluX = 0;
int closestJalluY = 0;
int closestTonicX = 0;
int closestTonicY = 0;


//ArrayList<Bottle> bottles = new ArrayList<Bottle>();

// void setup() {
//   bottles.add(new Bottle("Vodka", 90, 90, 50));
//   bottles.add(new Bottle("Jallu", 600, 200, 80));
//   bottles.add(new Bottle("Tonic", 180, 500, 100));
// }

void trackBottles() {
  int[] depthValues = kinect.getRawDepth();
  PImage img = kinect.getVideoImage();
  img.loadPixels();

  if (depthValues == null) return;

  for (int i = 0; i < depthValues.length; i += trackingSkip) {

    int y = i / kinect.width;
    int x = i - y*kinect.width;

    float depth = depthLookUp[depthValues[i]];

    if (floorDistance - 2*distanceBuffer < depth && depth < floorDistance - distanceBuffer) {
      checkAreaColor(x, y, img);
      //println("piirretään");
      stroke(200,200,200);
      fill(200,200,200);
      ellipse(x,y,20,20);
    }
    //if (i == 0) println(depthValues.length);
    //if (i == depthValues.length / 2) println("keskusta " + depth);
  }

  int[] currentLocationVodka = bottles.get(0).location();
  int[] currentLocationJallu = bottles.get(1).location();
  int[] currentLocationTonic = bottles.get(2).location();

  if (abs(currentLocationVodka[0] - closestVodkaX) + abs(currentLocationVodka[1] - closestVodkaY) > moveTreshold) {
    bottles.get(0).moveToLocation(closestVodkaX, closestVodkaY);
    //println("Vodka " + bottles.get(0).location() + ", " + bottles.get(0).location().get(1));
  }
  if (abs(currentLocationJallu[0] - closestJalluX) + abs(currentLocationJallu[1] - closestJalluY) > moveTreshold) {
    bottles.get(1).moveToLocation(closestJalluX, closestJalluY);
  }
  if (abs(currentLocationTonic[0] - closestTonicX) + abs(currentLocationTonic[1] - closestTonicY) > moveTreshold) {
    bottles.get(2).moveToLocation(closestTonicX, closestTonicY);
  }

  closestVodkaColor = color(0,0,0);
  vodkaDifference = 10000;
}

float rawDepthToMeters(int depthValue) {
  if (depthValue < 2047) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0f;
}

void checkAreaColor(int x, int y, PImage img) {

  int redTotal = 0;
  int greenTotal = 0;
  int blueTotal = 0;

  for (int j = 3; j < colorAverageArea - 3; j++) {
    redTotal += red(img.pixels[x + y*kinect.width - 2 + j]);
    redTotal += red(img.pixels[x + y*kinect.width + (- 2 + j)*kinect.width]);

    greenTotal += green(img.pixels[x + y*kinect.width - 2 + j]);
    greenTotal += green(img.pixels[x + y*kinect.width + (- 2 + j)*kinect.width]);

    blueTotal += blue(img.pixels[x + y*kinect.width - 2 + j]);
    blueTotal += blue(img.pixels[x + y*kinect.width + (- 2 + j)*kinect.width]);
  }

  int redAverage = redTotal / (colorAverageArea * 2);
  int greenAverage = greenTotal / (colorAverageArea * 2);
  int blueAverage = blueTotal / (colorAverageArea * 2);

  //if (abs(red(vodkaColor) - redAverage) < abs(red(vodkaColor) - red(closestVodkaColor))) {
  if (colorDifference(vodkaColor, redAverage, greenAverage, blueAverage) < vodkaDifference) {
    closestVodkaColor = color(redAverage, greenAverage, blueAverage);
    closestVodkaX = x;
    closestVodkaY = y;
    vodkaDifference = colorDifference(vodkaColor, redAverage, greenAverage, blueAverage);
  }

  if (colorDifference(jalluColor, redAverage, greenAverage, blueAverage) < jalluDifference) {
    closestJalluColor = color(redAverage, greenAverage, blueAverage);
    closestJalluX = x;
    closestJalluY = y;
    jalluDifference = colorDifference(jalluColor, redAverage, greenAverage, blueAverage);
  }

  if (colorDifference(tonicColor, redAverage, greenAverage, blueAverage) < tonicDifference) {
    closestTonicColor = color(redAverage, greenAverage, blueAverage);
    closestTonicX = x;
    closestTonicY = y;
    tonicDifference = colorDifference(tonicColor, redAverage, greenAverage, blueAverage);
  }
}

int colorDifference(color originalColor, int red, int green, int blue) {
  int total = abs(int(red(originalColor)) - red);
  total += abs(green(originalColor) - green);
  total += abs(blue(originalColor) - blue);

  return total;
}
