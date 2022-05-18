/**
 * Stores the properties of a Fireball.
 * Contains methods for updating the fireball, displaying it and checking if it intersects with a GameObject instance.
 *
 * Created by Student 210033811.
 */
public class Fireball {
  PVector position;
  PVector velocity;
  float fireballWidth;
  float fireballHeight;
  float diameter;
  
  /**
   * Creates a new Fireball.
   */
  Fireball() {
    this.position = new PVector(0,0); // set when player fires a fireball using left/right keys
    this.velocity = new PVector(0,0); // set when player fires a fireball using left/right keys
    diameter = FIREBALL_DIAMETER;
    fireballWidth = diameter;
    fireballHeight = diameter;
  }
  
  /**
   * Updates the position of the fireball based on the velocity.
   */
  void integrate() {
    position.add(velocity);
  }
  
  /**
   * Displays the fireball as an image of a fireball.
   * The hitbox around the fireball can be shown by uncommenting the fill and rect lines.
   */
  void show() {
    // display the corn as an image of a fireball, with start x,y position and set image width and height.
    image(fireball,position.x,position.y,fireballWidth,fireballHeight);
    // Hit box around the fireball. Uncomment to view hitbox. 
    //fill(255,255,0, 0);
    //rect(this.position.x, this.position.y, fireballWidth, fireballHeight);
  }
  
  /**
   * Sets the starting position of the fireball.
   */
  void setInitialPosition(float x, float y) {
    PVector newPosition = new PVector(x,y);
    this.position.add(newPosition);
  }
  
  /**
   * Sets the starting velocity of the fireball.
   */
  void setInitialVelocity(PVector velocity) {
    this.velocity.add(velocity);
  }
  
  /**
   * Returns true if the player is intersecting with the fireball.
   * Checks if player comes into contact with top, left, right or bottom edge of the fireball.
   */
  boolean intersects(GameObject gameObj) {
    if (((gameObj.position.x + gameObj.objWidth) >= this.position.x) && //players right edge is past fireball's left edge
       (gameObj.position.x <= (this.position.x + fireballWidth)) && // players left edge is past game fireball's right edge
       ((gameObj.position.y + gameObj.objHeight) >= this.position.y) && // players top edge past game fireball's bottom edge
       (gameObj.position.y  <= (this.position.y + this.fireballHeight)) // players bottom edge past game fireball's top edge  
       ) {
         return true;
       }
    return false;
  }
}
