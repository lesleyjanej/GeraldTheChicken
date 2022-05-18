/**
 * Use this class to create an ExtraLife Item. Subclasses Item.
 * 
 * Created by Student 210033811.
 */
public class ExtraLife extends Item {
  
  /**
   * Create a new ExtraLife.
   */
  public ExtraLife() {
    this.itemName = "Extra Life";
    this.cost = 200; // costs 200 points to purchase.
    this.description = "Buy an extra life to increase your chances of winning the levels!";
  }
  
}
