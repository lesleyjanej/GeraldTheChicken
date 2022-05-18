import java.util.*;
import java.lang.Math;

/**
 * This class stores the information about a level.
 * It is also responsible for procedurally generating a level, rendering a level and 
 * checks if a player has come into contact with any side of a platform in the level.
 *
 * Created by Lesleyjane J.
 */
public class Level {
  // The platforms in the level are stored in a Stack
  public Stack<Platform> platforms;
  // stores corn, chillis and enemies
  public ArrayList<GameObject> gameObjects;
  // if a platform collides with a player, the position of the player and platform are saved.
  public PVector playerCollidedPos;
  public PVector platformCollidedPos;
  // save height and width of platform which player has collided with.
  public float collidedPlatformHeight;
  public float collidedPlatformWidth;
  // store whether the player has hit the goal platform
  boolean playerHitGoalPlatform;
  // store whether the player has hit the top edge of the goal platform
  boolean playerOnTopOfGoalPlatform;
  public boolean levelWon; 
  int levelNumber; // the number of this level
  ArrayList<Range> validRanges; // stores valid ranges of coordinates where objects may be placed
  GoalPlatform goalPlatform; // the goal platform
  Goal goal; // the flag goal which is on the goal platform
  
  int numPlatforms, numCorn, numChillis, numEnemies; // keep track of number of game objects in this level
  
  /**
   * Instantiate a new level in the game by specifying the level number, number of platforms, corn, chillis and enemies in the level.
   * Procedurally generated game elements such as platforms, corn, chillis and enemies.
   */
  public Level(int levelNumber, int numPlatforms, int numCorn, int numChillis, int numEnemies) {
    this.levelNumber = levelNumber;
    this.numPlatforms = numPlatforms;
    this.numCorn = numCorn;
    this.numChillis = numChillis;
    this.numEnemies = numEnemies;
    platforms = new Stack<Platform>();
    validRanges = new ArrayList<>();
    gameObjects = new ArrayList<>();
    playerCollidedPos = new PVector(0,0);
    platformCollidedPos = new PVector(0,0);
    playerHitGoalPlatform = false;
    playerOnTopOfGoalPlatform = false;
    
    // procedurally generate game elements
    // generate platforms (including the goal platform)
    generatePlatforms();
    // generate corn
    generateGameObject(new Corn(0,0), numCorn, CORN_WIDTH, CORN_HEIGHT);
    // generate chillis
    generateGameObject(new Chilli(0,0), numChillis, CHILLI_WIDTH, CHILLI_HEIGHT);
    // generate enemies if this is an appropriate level to do so in.
    if (this.levelNumber >= LEVEL_NUM_INTRODUCE_ENEMIES) {
      generateEnemies();
    }
    // generate the goal (flag) on top of the goal platform
    generateGoal();
    // the level has not yet been won
    levelWon = false;
  }
  
  /**
   * Render the level by displaying all platforms and game objects.
   * Update all platforms and game objects such that they move to the left of the screen.
   */
  void renderLevel() {
    for (Platform platform : platforms) {
      platform.show();
      platform.update();
    }
    for (GameObject obj : gameObjects) {
      obj.show();
      obj.update();
    }
    goal.show();
    goal.update();
  }
  
  /**
    * Generate platforms procedurally by using random gap distances between platforms and random widths of platform, based
    * on predetermined min and max values for gap and width of platforms.
    * The first platform is created using predetermined constants. 
    * The last platform is a goal platform, all others are standard platforms.
    * Once a platform has been created, its range (start and end position of the platform) is added to a validRanges list.
    * The validRanges list contains ranges where Game Objects may be placed.
    */
  void generatePlatforms() {
    // Create the first platform using the predetermined constants. All remaining platform x positionos will be based on this one.
    platforms.add(new StandardPlatform(FIRST_PLATFORM_X, PLATFORM_START_Y, FIRST_PLATFORM_WIDTH, PLATFORM_DEPTH));
    
    // Now to create the rest of the platforms
    // Find the range for the platform width
    int range = (MAX_PLATFORM_WIDTH - MIN_PLATFORM_WIDTH) + 1;
    
    // Create new platforms until max number of platforms is reached for this level
    for (int i = 0; i < numPlatforms; i++) {
      // Get the last added platform, as this platform's x position will be based on it.
      Platform lastAddedPlatform = platforms.peek();
      // Get the gap range between platforms
      int widthGapRange = (MAX_WIDTH_GAP_BETWEEN_PLATFORMS - MIN_WIDTH_GAP_BETWEEN_PLATFORMS) + 1;
      // Get a random gap width between the last platform and the new platform
      int randomWidthGapDistance = (int)(Math.random() * widthGapRange) + MIN_WIDTH_GAP_BETWEEN_PLATFORMS;
      // The new platforms start position will be the end of the last platform + the random gap distance, ensuring no overlap between platforms.
      float startX = (lastAddedPlatform.position.x + lastAddedPlatform.objWidth) + randomWidthGapDistance;
      // Get a random width for the new platform
      int platformWidth = (int)(Math.random() * range) + MIN_PLATFORM_WIDTH;
      // All platforms have the start start Y position
      float startY = PLATFORM_START_Y;
      // All platforms have the same height
      float platformHeight = PLATFORM_DEPTH;
      
      // If this is the last platform, create a Goal Platform instead of a Standard Platform
      if (i == numPlatforms - 1) {
        goalPlatform = new GoalPlatform(startX, startY, platformWidth, platformHeight);
        platforms.add(goalPlatform);  
      } 
      // Otherwise, create a new standard platform.
      else {
        // add new platform
        platforms.add(new StandardPlatform(startX, startY, platformWidth, platformHeight));
        // The start and end position of the new platform is added as a valid range as Game Objects can be placed on this platform.
        validRanges.add(new Range(startX, startX + platformWidth));
      }
      
    }
    
  }
  
  /**
   * Procedurally generate enemies by choosing a random enemy type from the enum EnemyTypes.
   * Uses the generateGameObject() method to place the enemies in valid locations.
   */
  void generateEnemies() {
    for (int i = 0; i < numEnemies; i++) {
      // Get a random index from the EnemyTypes enum
      int index = new Random().nextInt(EnemyTypes.values().length);
      // Get the enemy corresponding to that index
      EnemyTypes enemy = EnemyTypes.values()[index];
      if (enemy == EnemyTypes.FOX) {
        // Start with no x,y position and only generate one fox.
        generateGameObject(new Fox(0,0), 1, FOX_WIDTH, FOX_HEIGHT);
      }
      else if (enemy == EnemyTypes.WOLF) {
        generateGameObject(new Wolf(0,0), 1, WOLF_WIDTH, WOLF_HEIGHT);
      }
      else if (enemy == EnemyTypes.FARMER) {
        generateGameObject(new Farmer(0,0), 1, FARMER_WIDTH, FARMER_HEIGHT);
      }
    }
    
  }
  
  /**
   * Proecedurally generate game objects by choose a random range from the list of 
   * valid ranges (which are based on the platforms).
   * Only choose a range if the object can fit into it.
   * Once a object has been placed in within a range, delete the range and create two
   * new ranges around the object, as the object has now taken the previously available slot.
   */
  void generateGameObject(GameObject obj, int maxNumObj, int objWidth, int objHeight) {
    // Generate new game objects until max number of game objects is reached
    for (int i = 0; i < maxNumObj; i++) {
      // get random valid range from list of valid ranges, based on where the platforms are
      Range randomRange = validRanges.get(new Random().nextInt(validRanges.size()));
      // get the range from the random range
      float range = (randomRange.high - randomRange.low) + 1;
      // get random start x for the object within the range
      float startX = (float)(Math.random() * range) + randomRange.low;
      // Check if the range is is wide enough to fit the object 
      if ((randomRange.high - randomRange.low) < objWidth) { 
        // if it is not wide enough, then restart this iteration
        i--;
        continue;
      }
      // Create the new game object
      // all game object's share the same Y position (same as the platform).
      if (obj instanceof Corn) {
        Corn newObj = new Corn(startX, PLATFORM_START_Y - objHeight);
        gameObjects.add(newObj);
      }
      else if (obj instanceof Chilli) {
        Chilli newObj = new Chilli(startX, PLATFORM_START_Y - objHeight);
        gameObjects.add(newObj);
      }
      else if (obj instanceof Fox) {
        Fox newObj = new Fox(startX, PLATFORM_START_Y - objHeight);
        gameObjects.add(newObj);
      }
      else if (obj instanceof Wolf) {
        Wolf newObj = new Wolf(startX, PLATFORM_START_Y - objHeight);
        gameObjects.add(newObj);
      }
      else if (obj instanceof Farmer) {
        Farmer newObj = new Farmer(startX, PLATFORM_START_Y - objHeight);
        gameObjects.add(newObj);
      }
      
      // remove coordinates of object from validRange as that space is now taken
      validRanges.remove(randomRange);
      
      // add in two new ranges
      // new range from original range low - object starting position
      validRanges.add(new Range(randomRange.low, startX));
      // new range from object starting position - original range high
      // only add if the object does not surpass the platform
      if ((startX + objWidth) < randomRange.high) {
        validRanges.add(new Range(startX + objWidth, randomRange.high));
      }
    }
  }
  

  /**
   * Generate a goal (flag) on top of the goal platform.
   */
  void generateGoal() {
    goal = new Goal(goalPlatform.position.x + goalPlatform.objWidth/2 - FLAG_WIDTH/2, goalPlatform.position.y - FLAG_HEIGHT);
  }
  
 
  
  /**
   * Checks to see if the player has hit the top edge of a platform.
   * If the player has hit the top edge, and the platform is the goal platform, then the player has hit the top edge of the goal platform.
   */
  public boolean playerHitTopEdgePlatform() {
    // If the player's bottom edge - 50 (a buffer, explained below) is less than the platform's top edge
    // and the player is not hitting the left edge, then this means the player has collided with the top edge of the platform.
    // 50 must be subtracted as a "buffer" as Processing is not fast enough to process the collision without this buffer.
    if (playerCollidedPos.y + PLAYER_HEIGHT - (50) <= platformCollidedPos.y && !playerHitLeftEdgePlatform()) {
      // if the player has hit the goal platform, they have also hit the top edge of it.
      if (playerHitGoalPlatform) {
        playerOnTopOfGoalPlatform = true;
      }
      return true;
    }
    return false;
  }
  
  /**
   * Checks to see if the player has hit the bottom edge of a platform.
   */
  public boolean playerHitBottomEdgePlatform() {
    // If the player's top edge + 50 (a buffer, explained below) is more than the platform's bottom edge,
    // then this means the player has collided with the bottom edge of the platform.
    // 50 must be added as a "buffer" as Processing is not fast enough to process this collision without this buffer.
    if (playerCollidedPos.y + (50) >= platformCollidedPos.y + collidedPlatformHeight) {
      return true;
    }
    return false;
  }
  
  /**
   * Checks to see if the player has hit the left edge of a platform.
   */
  public boolean playerHitLeftEdgePlatform() {
    // If the player's right edge - 10 (a buffer, explained below) is less than the platform's left edge,
    // then this means the player has collided with the left edge of the platform.
    // 10 must be subtracted as a "buffer" as Processing is not fast enough to process this collision without this buffer.
    if (playerCollidedPos.x + PLAYER_WIDTH - (10) <= platformCollidedPos.x) {
      return true;
    }
    return false;
  }
  
  /**
   * Checks to see if the player has hit the right edge of a platform.
   */
  public boolean playerHitRightEdgePlatform() {
    // If the player's left edge + 10 (a buffer, explained below) is less than the platform's right edge,
    // then this means the player has collided with the right edge of the platform.
    // 10 must be added as a "buffer" as Processing is not fast enough to process this collision without this buffer
    if (playerCollidedPos.x + (10) >= platformCollidedPos.x + collidedPlatformWidth) {
      return true;
    }
    return false;
  }
  
  /**
   * Returns true if a player is intersected with a platform,
   * and stores all the player's and platform's position at point of collision.
   * Additionally stores platform height and width.
   */
  public boolean playerCollidedWithPlatform(Player player) {
    // Loop through all platforms and check if any of them intersect with the player
    for (Platform platform : platforms) {
      if (platform.intersects(player)) {
        // check if the player has hit any side of the goal platform
        if (platform instanceof GoalPlatform) {
          this.playerHitGoalPlatform = true;
        } 
        // positions of player and platform when they collide
        this.playerCollidedPos.x = player.position.x;
        this.playerCollidedPos.y = player.position.y;
        this.platformCollidedPos.x = platform.position.x;
        this.platformCollidedPos.y = platform.position.y;
        this.collidedPlatformHeight = platform.objHeight;
        this.collidedPlatformWidth = platform.objWidth;
        return true;
      }
    }
    // if no platforms collide with the player
    return false;
  }
  
  
  
}
