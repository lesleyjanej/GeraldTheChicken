/**
 * Create a new GoalPlatform with a start x and y position, width and height.
 * Subclasses Platform.
 * Responsible for drawing the platform to the screen.
 *
 * Created by Student 210033811.
 */
public class GoalPlatform extends Platform {
  
  /**
   * Creates a GoalPlatform with a start x position, start y position, width and height.
   * A GoalPlatform has a different colour to a StandardPlatform.
   */
  GoalPlatform(float startX, float startY, float platformWidth, float platformHeight) {
    super(startX, startY, platformWidth, platformHeight);
    this.platformColor = color(0);
  }
  
  /**
   * Draw the goal platform to the screen as a rectangle and paint it with the given fill colour.
   * Additionally adds text to the platform to indiciate that this goal is the "goal" platform.
   */ 
  void show() {
    stroke(0,255,0);
    fill(0); 
    // platforms are drawn as rectangles
    rect(this.position.x, this.position.y, objWidth, objHeight);
    textSize(24);
    fill(255,255,255);
    text("GOAL", position.x + objWidth/2, position.y + objHeight/2);
  }
}
