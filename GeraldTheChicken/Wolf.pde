/**
 * Stores the properties of a Wolf, which is an Enemy.
 * Contains a method show() for displaying the Wolf to the screen.
 *
 * Created by Lesleyjane J.
 */
public class Wolf extends Enemy {
  /**
   * Create a new Wolf by specifying a start x and y position.
   */
  Wolf(float startX, float startY) {
    this.position = new PVector(startX, startY);
    this.objWidth = WOLF_WIDTH;
    this.objHeight = WOLF_HEIGHT;
    this.hitByFireball = false;
  }
  
  /**
   * Display the Wolf as an image. Called in the draw() method.
   * Uncomment the fill and rect() lines to view the hit box around the wolf.
   */
  void show() {
    // display the wolf as an image of a wolf, with start x,y position and set image width and height.
    image(wolf,position.x,position.y,objWidth,objHeight);
    // Hit box around the wolf. Uncomment to view hitbox. 
    //fill(255,255,0, 0);
    //rect(this.position.x, this.position.y, objWidth, objHeight);
  }
  
}
