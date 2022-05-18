/**
 * Create a new StandardPlatform with a start x and y position, width and height.
 * Responsible for drawing the platform to the screen.
 *
 * Created by Student 210033811.
 */
public class StandardPlatform extends Platform {
  
 /**
  * Creates a StandardPlatform with a start x position, start y position, width and height.
  * A StandardPlatform has a different colour to a GoalPlatform.
  */
  StandardPlatform(float startX, float startY, float platformWidth, float platformHeight) {
    super(startX, startY, platformWidth, platformHeight);
    this.platformColor = color(50,205,50);  // lime green;
  }
  
 /**
  * Draw the standard platform to the screen as a rectangle and paint it with the given fill colour.
  */  
  void show() {
    fill(platformColor); 
    // platforms are drawn as rectangles
    rect(this.position.x, this.position.y, objWidth, objHeight);
  }
}
