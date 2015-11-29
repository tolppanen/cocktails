class Cocktail {
  String cocktailName;
  HashMap<Ingredient, Float> ingredients;  
  
 /**
  *  This class represents cocktail-recipes, each cocktail has a NAME
  *  and a list of ingredients with their correct amounts.
  *  
  */
  
  Cocktail(String name){
    cocktailName = name;
    ingredients = new HashMap<Ingredient, Float>();
  }
  
  
  /**
  *  A method for getting a string description of a specific phase of a recipe.
  *  For example, to get the first phase of making a gin tonic, use
  *  gintonic.getIngredientNo(0);
  *  TODO: what should this return instead of a string description?
  */
  String getIngredientNo(Integer number) {
    if(number < ingredients.keySet().size() && number >= 0) {
      Ingredient[] newarray = ingredients.keySet().toArray(new Ingredient[0]);
      Ingredient currentIngredient = newarray[number];
      Integer amount = round(ingredients.get(currentIngredient));
      return "Pour " + amount + "cl of " + currentIngredient.toString();
    }
    else return "No such ingredient";
  };
  
  /*  A method for getting the amount of a specific ingredient
  *   Takes an Ingredient object and return the amount in float (centileters)
  */
  Float getAmountOf(Ingredient liquor) {
    return this.ingredients.get(liquor);
  }
  
  
  /*
  * Returns the total volume of this drink
  */
  Float getTotalVolume() {
    Float sum = 0.0;    
    for (Map.Entry me : ingredients.entrySet()) {
        sum += (Float) me.getValue();
    };
    return sum;
  };
  
   String toString() {
     return this.cocktailName;
   }
   
   ArrayList<String> getAllPhases(){
     ArrayList<String> listResult = new ArrayList<String>();
     for(int i = 0; i < ingredients.keySet().size(); i ++) {
       listResult.add(this.getIngredientNo(i));
     }
     return listResult;
   }
  
};