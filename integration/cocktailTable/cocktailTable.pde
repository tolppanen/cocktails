/* This class is for drawing stuff on the table, around the bottles and the glass */
import java.util.Map;
import java.util.Map.Entry;
JSONArray json;

int heightY = 720;
int widthX = 1280;

int counter = 0;

ArrayList<Bottle> bottles;
ArrayList<Cocktail> recipes;
ArrayList<Ingredient> ingredients;
Cocktail activeRecipe;
int currentStep, numberOfSteps;


void setup() {
  size(widthX, heightY);
  background(0, 0, 0);
  testData();
}

void draw() {
  for (Bottle bottle : bottles) {
    bottle.drawThis(counter);
  }
  counter = (counter < 120) ? counter + 1 : 0;
}

// The following pieces of code are here for testing: 
// Dummy data & mouse events for controlling the bottles.

void testData() {  
  json = loadJSONArray("data.json");
  bottles = new ArrayList<Bottle>();
  recipes = new ArrayList<Cocktail>();
  ingredients = new ArrayList<Ingredient>();
  // Go through the data-file and add recipes and possible ingredients
  for (int i = 0; i < json.size(); i++) {
    JSONArray values = json.getJSONArray(i);
    JSONObject item = values.getJSONObject(0);
    Cocktail cocktailName = new Cocktail(item.getString("name"));
    recipes.add(cocktailName);
    for(int t = 1; t<values.size(); t++) {
      JSONObject currentRecipe = values.getJSONObject(t);
      cocktailName.ingredientList.add(getOrCreate(currentRecipe.getString("ingredient")));
      cocktailName.amountList.add(currentRecipe.getFloat("amount"));
      //cocktailName.ingredients.put(getOrCreate(currentRecipe.getString("ingredient")), currentRecipe.getFloat("amount"));
    }    
  }
  //add some bottles on the table 
  bottles.add(new Bottle(ingredients.get(0), 90, 90, 50));
  bottles.add(new Bottle(ingredients.get(1), 600, 600, 80));
  bottles.add(new Bottle(ingredients.get(2), 180, 500, 100));
  bottles.add(new Bottle(ingredients.get(3), 900, 300, 70));
  bottles.add(new Bottle(ingredients.get(4), 1000, 200, 80));
  
    changeRecipe(0);
}

void mouseClicked() {
  boolean selected = false;
//  for (Bottle bottle : bottles) {
//    if (bottle.isHere(mouseX, mouseY)) {
//      bottle.toggleSelect();
//      bottle.toggleIncluded();
//      println(bottle);
//      selected = true;
//    }
//  }
   if(!selected) {
   int random = int(random(ingredients.size()));
   bottles.add(new Bottle(ingredients.get(random), mouseX + 80, mouseY + 80, 80));
    }
}
  
Ingredient getOrCreate(String check) {
  int finder = bottleExists(check);
  if(finder != -1)  return ingredients.get(finder);
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
    if(bottle.bottleName.toString().equals(currentIngredient.toString()) && !found) {
          bottle.included = true;
          bottle.selected = true;
          found = true;
    }
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
    for(int k = 0; k < bottles.size(); k++){
      if(ingredients.get(k).ingredientName.equals(check)) found = k;
    }
    return found;
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      clearRecipe();
      int newIndex = int(random(recipes.size())-1);
      changeRecipe(int(random(newIndex)));
      println(activeRecipe);
      println(activeRecipe.ingredientList);
    }
    if (keyCode == DOWN) {
      nextStep();
      drawCurrentPhase();
    }
  }
}
  