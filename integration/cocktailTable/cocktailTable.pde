/* This class is for drawing stuff on the table, around the bottles and the glass */
import java.util.Map;
import java.util.Map.Entry;
JSONArray json;

int heightY = 1050;
int widthX = 1920;

int counter = 0;
int everyFourth = 0;
int weight = 0; // Here goes the reading from the pressure sensor!

color green = color(96, 255, 75);
color red = color(116, 0, 0);

ArrayList<Bottle> bottles;
ArrayList<Cocktail> recipes;
ArrayList<Ingredient> ingredients;
Cocktail activeRecipe;
int currentStep, numberOfSteps;

PImage glass;

//ARDUINOSTUFF
int fsrValue = 0; //stores the value from force sensitive resistor
int c1 = 0; //counter to check if liquid has been poured
int c2 = 0; //counter to make sure two phases dont pass at once
//

void setup() {

  // ARDUINO STUFF
  //println(Arduino.list());
  arduino = new Arduino(this, "/dev/cu.usbmodem1411", 57600);
  //

  size(1920, 1050);
  background(0, 0, 0);
  testData();
  PFont myFont;
  myFont = createFont("Consolas", 24);
  textFont(myFont);

  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.initVideo();
  // Lookup table for all possible depth values (0 - 2047)
  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
  }
}

void draw() {
  // Clear background
  background(0, 0, 0);

  //ARDUINOSTUFF
  fill(green);
  text(arduino.analogRead(0), width/2, height/2);
  if (c1 == 10) {
    if (arduino.analogRead(0) > 50 + fsrValue && c2 > 3) {
      nextStep();
      drawCurrentPhase();
      c2 = 0;
    } else {
    fsrValue = arduino.analogRead(0);
    c1 = 0;
    }
  } else c1 += 1;
  //

  // Draw the bottles
  for (Bottle bottle : bottles) {
    bottle.drawThis(counter, weight);
  }
  // Draw menu
  drawMenu();
  drawGlass();
  // Add to counter, for spinning the images
  counter = (counter < 120) ? counter + 1 : 0;
  if (counter >= 0 && counter < 30) {
    everyFourth = 0;
  }
  if (counter >= 30 && counter < 60) {
    everyFourth = 1;
  }
  if (counter >= 60 && counter < 90) {
    everyFourth = 2;
  }
  if (counter >= 90 && counter <= 120) {
    everyFourth = 3;
  }
  trackBottles();
}

void drawGlass() {
  noStroke();

  fill(0);
  ellipse(widthX/2, heightY-80, 124, 124);

  fill(96, 255, 75, 127);
  ellipse(widthX/2, heightY-80, 124, 124);     // background green glass

  if (weight == 0) {            // only do this if glass is not set on table

    if (everyFourth == 0) {
      fill(0, 0, 0);
      ellipse(widthX/2, heightY-80, min(120, counter*4), min(120, counter*4));  // black, 1st
    }

    if (everyFourth == 1) {
      noStroke();
      fill(0, 0, 0);
      ellipse(widthX/2, heightY-80, 120, 120);

      fill(96, 255, 75, 127);
      ellipse(widthX/2, heightY-80, min(120, (counter - 30) * 4), min(120, (counter - 30) * 4));    // green, 2nd
    }

    if (everyFourth == 2) {
      noStroke();
      fill(0, 0, 0);
      ellipse(widthX/2, heightY-80, min(120, (counter - 60) * 4), min(120, (counter - 60) * 4));    // black, 3rd
    }

    if (everyFourth == 3) {
      noStroke();
      fill(0, 0, 0);
      ellipse(widthX/2, heightY-80, 120, 120);

      fill(96, 255, 75, 127);
      ellipse(widthX/2, heightY-80, min(120, (counter - 90) * 4), min(120, (counter - 90) * 4));  // green, 4th
    }
  }
}

void drawMenu() {
  for (int i = 0; i < recipes.size (); i++) {
    stroke(green);
    strokeWeight(2);
    noFill();
    ellipse(50, ((height - i * 110) - 60), 90, 90);
    // Highlight the active recipe
    color thisColor = activeRecipe.equals(recipes.get(i)) ? red : green;
    fill(thisColor);
    textSize(42);
    text(recipes.get(i).toString(), 180, (height - i * 110) - 60);
  }
}

// The following pieces of code are here for testing:
// Dummy data & mouse events for controlling the bottles.

void testData() {
  json = loadJSONArray("data.json");
  bottles = new ArrayList<Bottle>();
  recipes = new ArrayList<Cocktail>();
  ingredients = new ArrayList<Ingredient>();
  // Go through the data-file and add recipes and possible ingredients
  for (int i = 0; i < json.size (); i++) {
    JSONArray values = json.getJSONArray(i);
    JSONObject item = values.getJSONObject(0);
    Cocktail cocktailName = new Cocktail(item.getString("name"));
    recipes.add(cocktailName);
    for (int t = 1; t<values.size (); t++) {
      JSONObject currentRecipe = values.getJSONObject(t);
      cocktailName.ingredientList.add(getOrCreate(currentRecipe.getString("ingredient")));
      cocktailName.amountList.add(currentRecipe.getFloat("amount"));
      //cocktailName.ingredients.put(getOrCreate(currentRecipe.getString("ingredient")), currentRecipe.getFloat("amount"));
    }
  }
  //add some bottles on the table
  // bottles.add(new Bottle(ingredients.get(0), 90, 90, 50));
  // bottles.add(new Bottle(ingredients.get(1), 600, 200, 80));
  // bottles.add(new Bottle(ingredients.get(2), 180, 500, 100));
  // bottles.add(new Bottle(ingredients.get(3), 900, 300, 70));
  // bottles.add(new Bottle(ingredients.get(4), 1000, 200, 80));

  bottles.add(new Bottle(ingredients.get(0), 0, 0, 60));
  bottles.add(new Bottle(ingredients.get(1), 0, 0, 80));
  bottles.add(new Bottle(ingredients.get(2), 0, 0, 110));
  bottles.add(new Bottle(ingredients.get(3), 0, 0, 120));
  bottles.add(new Bottle(ingredients.get(4), 0, 0, 130));

  changeRecipe(0);
}

void mouseClicked() {
  int random = int(random(ingredients.size()));
  bottles.add(new Bottle(ingredients.get(random), mouseX, mouseY, 80));
}

Ingredient getOrCreate(String check) {
  int finder = bottleExists(check);
  if (finder != -1)  return ingredients.get(finder);
  else {
    Ingredient createdIngredient = new Ingredient(check);
    ingredients.add(createdIngredient);
    return createdIngredient;
  }
};

void changeRecipe(int selector) {
  activeRecipe = recipes.get(selector);
  numberOfSteps = activeRecipe.ingredientList.size();
  currentStep = 0;
  drawCurrentPhase();
  fsrValue = arduino.analogRead(0);
}

void drawCurrentPhase() {
  String currentIngredient = activeRecipe.getIngredientNo(currentStep).toString();
  boolean found = false;
  for (Bottle bottle : bottles) {
    bottle.selected = false;
    if (activeRecipe.ingredientList.contains(bottle.bottleName)) {
      bottle.included = true;
    }
    if (bottle.bottleName.toString().equals(currentIngredient.toString()) && !found) {
      bottle.selected = true;
      found = true;
    }
  }
  if (currentIngredient.equals("Completed!")) {
    clearRecipe();
  }
  println(currentIngredient);
}


void nextStep() {
  currentStep += 1;
  fsrValue = arduino.analogRead(0);
}

void clearRecipe() {
  for (Bottle bottle : bottles) {
    bottle.included = false;
    bottle.selected = false;
  }
}


int bottleExists(String check) {
  int found = -1;
  for (int k = 0; k < bottles.size (); k++) {
    if (ingredients.get(k).ingredientName.equals(check)) found = k;
  }
  return found;
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      int index = recipes.indexOf(activeRecipe);
      clearRecipe();
      int newIndex = (index == 0) ? recipes.size() - 1 : index - 1;
      changeRecipe(newIndex);
      println(activeRecipe);
      println(activeRecipe.ingredientList);
    }
    if (keyCode == DOWN) {
      nextStep();
      drawCurrentPhase();
    }
    if (keyCode == LEFT) { // Simulate the pressure sensor
      println(weight);
      if (weight < 100) {
        weight++;
      } else {
        weight = 0;
        nextStep();
        drawCurrentPhase();
      }
    }
  }
}