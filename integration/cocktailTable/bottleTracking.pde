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
int trackingSkip = 5; // tracking takes into account every trackingSkip:th pixel
int colorAverageArea = 3; // determines the size of the area from wich color average is calculated
int moveTreshold = 50; // how far does the bottle have to be in order to be moved

color kossuColor = color(255, 0, 0); // pitää muuttaa oikeiksi arvoiksi
color jalluColor = color(0, 255, 0);
color ginColor = color(0, 0, 255);
color kokisColor = color(255, 0, 255);
color tonicColor = color(0, 255, 255);
// color d = Todo;
// color e = Todo;
// color f = Todo;
// color g = Todo;
// color h = Todo;
// color i = Todo;
// color j = Todo;

color closestKossuColor = color(255, 255, 255);
int kossuDifference = 10000;
color closestJalluColor = color(255, 255, 255);
int jalluDifference = 10000;
color closestGinColor = color(255, 255, 255);
int ginDifference = 10000;
color closestKokisColor = color(255, 255, 255);
int kokisDifference = 10000;
color closestTonicColor = color(255, 255, 255);
int tonicDifference = 10000;

int closestKossuX = 0;
int closestKossuY = 0;
int closestJalluX = 0;
int closestJalluY = 0;
int closestGinX = 0;
int closestGinY = 0;
int closestKokisX = 0;
int closestKokisY = 0;
int closestTonicX = 0;
int closestTonicY = 0;


//ArrayList<Bottle> bottles = new ArrayList<Bottle>();

// void setup() {
//   bottles.add(new Bottle("Kossu", 90, 90, 50));
//   bottles.add(new Bottle("Jallu", 600, 200, 80));
//   bottles.add(new Bottle("Tonic", 180, 500, 100));
// }

void trackBottles() {
  int[] depthValues = kinect.getRawDepth();
  PImage img = kinect.getVideoImage();
  img.loadPixels();

  if (depthValues == null) return;

  //for (int i = 3; i < depthValues.length; i += trackingSkip) {
  for (int x = 3; x < kinect.width - 3; x += trackingSkip) {
    for (int y = 3; y < kinect.height - 3; y += trackingSkip) {

      //int y = i / kinect.width;
      //int x = i - y*kinect.width;

      float depth = depthLookUp[depthValues[ y*kinect.width + x ]];

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
  }

  int[] currentLocationKossu = bottles.get(0).location();
  int[] currentLocationJallu = bottles.get(1).location();
  int[] currentLocationGin = bottles.get(2).location();
  int[] currentLocationKokis = bottles.get(3).location();
  int[] currentLocationTonic = bottles.get(4).location();

  if (abs(currentLocationKossu[0] - closestKossuX) + abs(currentLocationKossu[1] - closestKossuY) > moveTreshold) {
    bottles.get(0).moveToLocation(closestKossuX, closestKossuY);
    //println("Kossu " + bottles.get(0).location() + ", " + bottles.get(0).location().get(1));
  }
  if (abs(currentLocationJallu[0] - closestJalluX) + abs(currentLocationJallu[1] - closestJalluY) > moveTreshold) {
    bottles.get(1).moveToLocation(closestJalluX, closestJalluY);
  }
  if (abs(currentLocationGin[0] - closestGinX) + abs(currentLocationGin[1] - closestGinY) > moveTreshold) {
    bottles.get(2).moveToLocation(closestGinX, closestGinY);
  }
  if (abs(currentLocationKokis[0] - closestKokisX) + abs(currentLocationKokis[1] - closestKokisY) > moveTreshold) {
    bottles.get(3).moveToLocation(closestKokisX, closestKokisY);
  }
  if (abs(currentLocationTonic[0] - closestTonicX) + abs(currentLocationTonic[1] - closestTonicY) > moveTreshold) {
    bottles.get(4).moveToLocation(closestTonicX, closestTonicY);
  }

  closestKossuColor = color(0,0,0);
  kossuDifference = 10000;
  closestJalluColor = color(0,0,0);
  jalluDifference = 10000;
  closestGinColor = color(0,0,0);
  ginDifference = 10000;
  closestKokisColor = color(0,0,0);
  kokisDifference = 10000;
  closestTonicColor = color(0,0,0);
  tonicDifference = 10000;
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
  //int magentaTotal = 0;
  //int turqoiseTotal = 0;

  for (int j = 0; j < colorAverageArea; j++) {
    redTotal += red(img.pixels[x + y*kinect.width - 1 + j]);
    redTotal += red(img.pixels[x + y*kinect.width + (- 1 + j)*kinect.width]);

    greenTotal += green(img.pixels[x + y*kinect.width - 1 + j]);
    greenTotal += green(img.pixels[x + y*kinect.width + (- 1 + j)*kinect.width]);

    blueTotal += blue(img.pixels[x + y*kinect.width - 1 + j]);
    blueTotal += blue(img.pixels[x + y*kinect.width + (- 1 + j)*kinect.width]);
  }

  int redAverage = redTotal / (colorAverageArea * 2);
  int greenAverage = greenTotal / (colorAverageArea * 2);
  int blueAverage = blueTotal / (colorAverageArea * 2);

  //println("r: " + redAverage + " g: " + greenAverage + " b: " + blueAverage);

  //if (abs(red(kossuColor) - redAverage) < abs(red(kossuColor) - red(closestKossuColor))) {
  if (colorDifference(kossuColor, redAverage, greenAverage, blueAverage) < kossuDifference) {
    closestKossuColor = color(redAverage, greenAverage, blueAverage);
    closestKossuX = x*2+500;
    closestKossuY = y*2+10;
    kossuDifference = colorDifference(kossuColor, redAverage, greenAverage, blueAverage);
  } else if (colorDifference(jalluColor, redAverage, greenAverage, blueAverage) < jalluDifference) {
    closestJalluColor = color(redAverage, greenAverage, blueAverage);
    closestJalluX = x*2+500;
    closestJalluY = y*2+10;
    jalluDifference = colorDifference(jalluColor, redAverage, greenAverage, blueAverage);
  } else if (colorDifference(ginColor, redAverage, greenAverage, blueAverage) < ginDifference) {
    closestGinColor = color(redAverage, greenAverage, blueAverage);
    closestGinX = x*2+500;
    closestGinY = y*2+10;
    ginDifference = colorDifference(ginColor, redAverage, greenAverage, blueAverage);
  }else if (colorDifference(kokisColor, redAverage, greenAverage, blueAverage) < kokisDifference) {
    closestKokisColor = color(redAverage, greenAverage, blueAverage);
    closestKokisX = x*2+500;
    closestKokisY = y*2+10;
    kokisDifference = colorDifference(kokisColor, redAverage, greenAverage, blueAverage);
  }else if (colorDifference(tonicColor, redAverage, greenAverage, blueAverage) < tonicDifference) {
    closestTonicColor = color(redAverage, greenAverage, blueAverage);
    closestTonicX = x*2+500;
    closestTonicY = y*2+10;
    tonicDifference = colorDifference(tonicColor, redAverage, greenAverage, blueAverage);
  }
}

int colorDifference(color originalColor, int red, int green, int blue) {
  int total = abs(int(red(originalColor)) - red);
  total += abs(green(originalColor) - green);
  total += abs(blue(originalColor) - blue);

  return total;
}
