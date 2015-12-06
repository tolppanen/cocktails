/* This class is for drawing stuff on the table, around the bottles and the glass */
import java.util.Map;
import java.util.Map.Entry;
JSONArray json;

int heightY = 620;
int widthX = 1280;

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


void setup() {
  // ARDUINO STUFF
  
  //println(Arduino.list());
  //arduino = new Arduino(this, Arduino.list()[0], 57600);
  
 // String portName = Serial.list()[0];
  //port = new Serial(this, portName, 9600);
  
  //
  
  
  size(1280, 620);
  background(0, 0, 0);
  tint(255, 255);
  glass = loadImage("Images/glass1.png");
  testData();
  PFont myFont;
  myFont = createFont("Consolas", 24);
  textFont(myFont);
}

void draw() {
  // Clear background
  background(0, 0, 0);
  
  // Draw arduinostuff (testing)
  /*fill(green);
  textSize(18);
  text(arduino.analogRead(0), width/2, height/2);*/
  
  
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
}

void drawGlass() {
  pushMatrix();
  noStroke();
  
  fill(0);
  ellipse(widthX/2, heightY-80, 124, 124);
  
  fill(96, 255, 75, 127); 
  ellipse(widthX/2, heightY-80, 124, 124);     // background green glass

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

  popMatrix();
}

void drawMenu() {
  for (int i = 0; i < recipes.size (); i++) {
    stroke(green);
    strokeWeight(2);
    noFill();
    ellipse((width - 240), ((height - i * 39) - 40), 28, 28);
    // Highlight the active recipe
    color thisColor = activeRecipe.equals(recipes.get(i)) ? red : green;
    fill(thisColor);
    textSize(18);
    text(recipes.get(i).toString(), width - 205, (height - i * 40) - 30);
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
  bottles.add(new Bottle(ingredients.get(0), 90, 90, 50));
  bottles.add(new Bottle(ingredients.get(1), 600, 200, 80));
  bottles.add(new Bottle(ingredients.get(2), 180, 500, 100));
  bottles.add(new Bottle(ingredients.get(3), 900, 300, 70));
  bottles.add(new Bottle(ingredients.get(4), 1000, 200, 80));

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
