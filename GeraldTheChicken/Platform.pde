/**
 * Create a new Platform with a start x and y position, width and height.
 * Platforms are game objects are therefore subclass GameObject.
 * Responsible for drawing the platform to the screen.
 * 
 * Created by Lesleyjane J.
 */
public abstract class Platform extends GameObject {
  public color platformColor;
  
  /**
   * This class is abstract and cannot be instantiated. 
   * Subclasses may use this constructor to create a platform with a start x position,
   * start y position, width and height.
   */
  public Platform(float startX, float startY, float platformWidth, float platformHeight) {
    this.position = new PVector(startX, startY); // starting coordinates of the platform
    this.objWidth = platformWidth;
    this.objHeight = platformHeight;
    this.platformColor = color(127,255,0);  // chartreuse

  }
  
  /**
   * All classes which subclass this one must implement the show() method to draw the platform to the screen.
   */
  abstract void show();
  

  


  
}
