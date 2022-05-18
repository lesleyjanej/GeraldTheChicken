/**
 * Stores the properties of a Farmer, which is an Enemy.
 * Contains a method show() for displaying the Farmer to the screen.
 *
 * Created by Student 210033811.
 */
public class Farmer extends Enemy {
  /**
   * Create a new Farmer by specifying a start x and y position.
   */
  Farmer(float startX, float startY) {
    this.position = new PVector(startX, startY);
    this.objWidth = FARMER_WIDTH;
    this.objHeight = FARMER_HEIGHT;
    this.hitByFireball = false;
  }
  
  /**
   * Display the Farmer as an image. Called in the draw() method.
   * Uncomment the fill and rect() lines to view the hit box around the Farmer.
   */
  void show() {
    // display the farmer as an image of a farmer, with start x,y position and set image width and height.
    image(farmer,position.x,position.y,objWidth,objHeight);
    // Hit box around the farmer. Uncomment to view hitbox. 
    //fill(255,255,0, 0);
    //rect(this.position.x, this.position.y, objWidth, objHeight);
  }
  
}
