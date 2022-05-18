/**
 * Use this class to create a new goal object (depicted by a red flag).
 * Extends GameObject.
 * 
 * Created by Lesleyjane J.
 */
public class Goal extends GameObject {
  
  /**
   * Create a new goal object by specifying the start x and y position.
   */
  Goal(float startX, float startY) {
    this.position = new PVector(startX, startY);  
    this.objWidth = FLAG_WIDTH;
    this.objHeight = FLAG_HEIGHT;
  }
  
  /**
   * Draw the goal to the screen by displaying an image of the flag in the specified position.
   * The width and height can be set in the main file (GeraldTheChicken.pde).
   */
  void show() {
    image(goalFlag,position.x,position.y,objWidth,objHeight);
  }
  

  

}
