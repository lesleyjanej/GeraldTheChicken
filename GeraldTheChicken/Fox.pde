/**
 * Stores the properties of a Fox, which is an Enemy.
 * Contains a method show() for displaying the Fox to the screen.
 *
 * Created by Lesleyjane J.
 */
public class Fox extends Enemy {
  /**
   * Create a new Fox by specifying a start x and y position.
   */
  Fox(float startX, float startY) {
    this.position = new PVector(startX, startY);
    this.objWidth = FOX_WIDTH;
    this.objHeight = FOX_HEIGHT;
    this.hitByFireball = false;
  }
  
  /**
   * Display the Fox as an image. Called in the draw() method.
   * Uncomment the fill and rect() lines to view the hit box around the fox.
   */
  void show() {
    // display the fox as an image of a fox, with start x,y position and set image width and height.
    image(fox,position.x,position.y,objWidth,objHeight);
    // Hit box around the fox. Uncomment to view hitbox. 
    //fill(255,255,0, 0);
    //rect(this.position.x, this.position.y, objWidth, objHeight);
  }
  
}
