class Cocktail {
  String cocktailName;
  //HashMap<Ingredient, Float> ingredients;
  ArrayList<Ingredient> ingredientList;
  ArrayList<Float> amountList;
  
 /**
  *  This class represents cocktail-recipes, each cocktail has a NAME
  *  and a list of ingredients with their correct amounts.
  *  
  */
  
  Cocktail(String name){
    cocktailName = name;
    //ingredients = new HashMap<Ingredient, Float>();
    ingredientList = new ArrayList<Ingredient>();
    amountList = new ArrayList<Float>();
  }
  
  
  /**
  *  A method for getting a string description of a specific phase of a recipe.
  *  For example, to get the first phase of making a gin tonic, use
  *  gintonic.getIngredientNo(0);
  *  TODO: what should this return instead of a string description?
  */
  Ingredient getIngredientNo(Integer number) {
    if (number >= 0 && number < this.ingredientList.size()) return this.ingredientList.get(number);
    else return new Ingredient("Completed!");
  };
  
  Float getAmountNo(Integer number) {
    return this.amountList.get(number);
  }
  
  /*
  * Returns the total volume of this drink
  */
  Float getTotalVolume() {
    Float sum = 0.0;
    for(Float number : amountList) {
      sum += number;
    }
    return sum;
  };
  
   String toString() {
     return this.cocktailName;
   }
   
   ArrayList<String> getAllPhases(){
     ArrayList<String> listResult = new ArrayList<String>();
     for(int i = 0; i < ingredientList.size(); i ++) {
       listResult.add(ingredientList.get(i).toString() + ", " + amountList.get(i).toString());
     }
     return listResult;
   }
  
};
