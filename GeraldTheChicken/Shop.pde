/**
 * Create a new in-game shop. 
 * Stores a list of items.
 * Contains a method to check if the shop sells the item.
 * 
 * Created by Student 210033811.
 */
public class Shop {
  ArrayList<Item> itemsList; // list of items which the shop sells
  
  /**
   * Creating a new shop will result in items being added to the itemsList.
   * The shop currently sells Items of type ExtraLife and Jetpack.
   */
  public Shop() {
    itemsList = new ArrayList<Item>();
    itemsList.add(new ExtraLife());
    itemsList.add(new Jetpack());
    itemsList.add(new FireballGun());
    
  }
  
  /**
   * Returns true if the shop stocks a given Item by its item name (String).
   */
  boolean sellsItemByName(String name) {
    // Check if any item in the itemsList has the same name as the one passed in
    for (Item item : itemsList) {
      if (item.itemName.equals(name)) {
        return true;
      }
    }
    return false;
  }
  
  
 
  
}
