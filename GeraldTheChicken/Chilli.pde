/**
 * Stores the properties of a Chilli, which is a GameObject.
 * Contains a method show() for displaying the Chilli to the screen.
 *
 * Created by Lesleyjane J.
 */
public class Chilli extends GameObject{

  
  /**
   * Create a new Chilli by specifying a start x and y position.
   */
  Chilli(float startX, float startY) {
    this.position = new PVector(startX, startY);
    this.objWidth = CHILLI_WIDTH;
    this.objHeight = CHILLI_HEIGHT;
    this.hitByFireball = false;
  }
  
  /**
   * Display the Chilli as an image. Called in the draw() method.
   * Uncomment the fill and rect() lines to view the hit box around the Chilli.
   */
  void show() {
     // display the chilli as an image of a chilli, with start x,y position and set image width and height.
    image(chilli,position.x,position.y,objWidth,objHeight);
    // Hit box around the chilli. Uncomment to view hitbox. 
    //fill(255,255,0, 0);
    //rect(this.position.x, this.position.y, objWidth, objHeight);
  }

  

}
