/**
 * Create a new GameObject which has a position, width and height.
 * GameObject's move to the left of the screen.
 * GameObject's must be rectangular for the intersects method to work.
 * Contains a method update, which moves the object to the left of the screen.
 * Also checks if a game object is intersecting with a player.
 * 
 * Created by Student 210033811.
 */
public abstract class GameObject {
  PVector position;
  float objWidth;
  float objHeight;
  boolean hitByFireball;

  
  /**
   * All classes which subclass this one must implement the show() method to draw the GameObject to the screen.
   */
  abstract void show();
  
  /**
   * Updates the position of the game object on the screen.
   * Moves it to the left of the screen.
   */
  void update() {
    this.position.x -= gameObjectSpeed;
  }
  

  /**
   * Returns true if the player is intersecting with the rectangular game object.
   * Checks if player comes into contact with top, left, right or bottom edge of game object.
   */
  boolean intersects(Player player) {
    if (((player.position.x + player.playerWidth) >= this.position.x) && //players right edge is past game object's left edge
       (player.position.x <= (this.position.x + objWidth)) && // players left edge is past game object's right edge
       ((player.position.y + player.playerHeight) >= this.position.y) && // players top edge past game object's bottom edge
       (player.position.y  <= (this.position.y + this.objHeight)) // players bottom edge past game object's top edge  
       ) {
         return true;
       }
    return false;
  }
  

}
