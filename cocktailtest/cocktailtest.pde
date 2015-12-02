import java.util.Map;
import java.util.Map.Entry;
JSONArray json;

Cocktail gintonic, manhattan;
Ingredient gin, tonicWater, ryeWhiskey, vermouth, bitters;
ArrayList<Cocktail> recipes;
ArrayList<Ingredient> bottles;

void setup() {
  json = loadJSONArray("data.json");
  recipes = new ArrayList<Cocktail>();
  bottles = new ArrayList<Ingredient>();
  for (int i = 0; i < json.size(); i++) {
    JSONArray values = json.getJSONArray(i);
    JSONObject item = values.getJSONObject(0);
    Cocktail cocktailName = new Cocktail(item.getString("name"));
    recipes.add(cocktailName);
    for(int t = 1; t<values.size(); t++) {
      println(bottles);
      JSONObject currentRecipe = values.getJSONObject(t);
      cocktailName.ingredients.put(getOrCreate(currentRecipe.getString("ingredient")), currentRecipe.getFloat("amount"));
    }    
  }
  
  //This prints out every recipe
 for(int k = 0; k < recipes.size(); k++){
   ArrayList<String> currentList = new ArrayList<String>(recipes.get(k).getAllPhases());
   println(recipes.get(k));
   for(int p = 0; p < currentList.size(); p++) {
     println(currentList.get(p));
   }
   println("=====================================");
 }
 println(bottles);
};


// This only creates new bottles if such incredient has not been seen in another recipe  yet
Ingredient getOrCreate(String check) {
  int finder = bottleExists(check);
  if(finder != -1)  return bottles.get(finder);
  else {
      Ingredient createdIngredient = new Ingredient(check);
      bottles.add(createdIngredient);
      return createdIngredient; 
  }
};


int bottleExists(String check) {
    int found = -1;
    for(int k = 0; k < bottles.size(); k++){
      println(bottles.get(k).ingredientName);
      if(bottles.get(k).ingredientName.equals(check)) found = k;
    }
    return found;
}