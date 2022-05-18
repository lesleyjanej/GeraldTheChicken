/**
 * Stores the properties of a Corn, which is a GameObject.
 * Contains a method show() for displaying the Corn to the screen.
 *
 * Created by Lesleyjane J.
 */
public class Corn extends GameObject {
  int worthPoints; // number of points which the player will earn if they collect the corn
  
  /**
   * Create a new Corn by specifying a start x and y position.
   */
  Corn(float startX, float startY) {
    this.position = new PVector(startX, startY);
    this.objWidth = CORN_WIDTH;
    this.objHeight = CORN_HEIGHT;
    this.worthPoints = 50; 
    this.hitByFireball = false;
  }
  
  /**
   * Display the Corn as an image. Called in the draw() method.
   * Uncomment the fill and rect() lines to view the hit box around the Corn.
   */
  void show() {
    // display the corn as an image of a chilli, with start x,y position and set image width and height.
    image(corn,position.x,position.y,objWidth,objHeight);
    // Hit box around the corn. Uncomment to view hitbox. 
    //fill(255,255,0, 0);
    //rect(this.position.x, this.position.y, objWidth, objHeight);
  }
  

  

}
