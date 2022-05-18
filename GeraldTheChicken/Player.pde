/**
 * Create a new Player for the game. For this game, Gerald is the player.
 * Stores properties about the player such as position, velocity, width, height and many more.
 * The player has a total number of points they have earned which can be spent in the shop. Use the purchaseItem method to spend them.
 *
 * Created by Lesleyjane J.
 */
public class Player {
  PVector position;
  PVector velocity;
  PVector acceleration;
  int playerWidth;
  int playerHeight;
  color fillColor; 
  int totalPoints; // total number of points a player has earned, can be spent in the shop.
  HashMap<String, Integer> inventory; // Name of items and number of each item the player has in their inventory.
  boolean slowed; // if the player has been slowed (triggered when hits a chilli)
  boolean onTheGround; // if the player is on the top edge of a platform
  //boolean activatedJetpack; // if the player has actived their jetpack (bought in the shop)
  Jetpack activeJetpack;
  FireballGun fireballGun;
  boolean hurt;

  
  /**
   * Create a new Player by specifying their starting x and y position.
   * Their inventory is then initialised.
   */
  Player(float x, float y) {         
    this.position = new PVector(x,y);
    // start with no velocity and no acceleration
    this.velocity = new PVector(0,0);
    this.acceleration = new PVector(0,0);
    this.playerWidth = PLAYER_WIDTH;
    this.playerHeight = PLAYER_HEIGHT;
    fillColor = color(0); // black by default but is replaced by an image of a chicken
    totalPoints = INITIAL_POINTS; // start with 0 points
    inventory = new HashMap<>();
    initialiseInventory(); // add initial lives to inventory
    slowed = false;
    //activatedJetpack = false;
    activeJetpack = null;
    //fireballGun = null;
    fireballGun = null;
    
    hurt = false;
    
  }
  
  /**
   * Draw the player to the screen as an image of Gerald the Chicken.
   * Different images of Gerald will be drawn depending on the player's state (slowed, hurt, activatedJetpack).
   * The hitbox around the player can be uncommented to view it.
   */
  void show() {
    if (slowed) {
      image(blue_gerald,position.x,position.y,playerWidth,playerHeight);
    }
    else if (hurt) {
      image(red_gerald,position.x,position.y,playerWidth,playerHeight);
    }
    else if (activeJetpack != null && fireballGun != null) {
      image(gerald_jetpack_and_gun, position.x,position.y,playerWidth,playerHeight);
    }
    // if has an active jetpack
    else if (activeJetpack != null) {
      image(jetpack_gerald,position.x,position.y,playerWidth,playerHeight);
    }
    else if (fireballGun != null) {
      image(gerald_with_gun,position.x,position.y,playerWidth,playerHeight);
    }
    else {
      image(gerald,position.x,position.y,playerWidth,playerHeight);
    }
    // uncomment to see hit box around gerald
    //fill(fillColor, 0);
    //rect(position.x,position.y,playerWidth,playerHeight);
    
  }
  
  /**
   * Adds the player's initial starting lives to their inventory.
   */
  void initialiseInventory() {
    // add initial lives to inventory
    inventory.put("Extra Life", INITIAL_LIVES);
  }
  
  /**
   * Change the colour of the fillColor for the hitbox around the player (usually invisible unless uncommented).
   */
  void changeColor(color newColor) {
    fillColor = newColor;
  }
  
  /**
   * Applies a given force to the player's acceleration.
   * For instance, a gravity vector may be passed in, which will affect the player's acceleration.
   */
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  /**
   * Updates the player's position by updating their velocity and acceleration.
   * The force of gravity is applied to the player's acceleration, causing them to fall to the bottom of the screen.
   */
  void integrate() {
    applyForce(FORCE_GRAVITY); // apply gravity
    velocity.add(acceleration);
    position.add(velocity); // update position
    // if player is using jetpack, then limit velocity to keep speed consistent.
    
    if (this.activeJetpack != null) {
      velocity.limit(MAX_VELOCITY_WITH_JETPACK);
    }
    
    velocity.limit(MAX_VELOCITY);
    // To prevent gravity from accumulating too much, set it to zero
    acceleration.mult(0);
    
    // If the player falls to the bottom of the screen, snap the player to the bottom of the screen so they don't fall past it.
    if (this.position.y > height - PLAYER_HEIGHT) {
      this.position.y = height-50;
    }
    
    // Ensure that the player cannot go past the top of the screen.
    if (this.position.y < 0) {
      this.position.y = 0;
    }
    
    // if the player has collided with a platform, check which side of the platform they have landed on/touched
    if (currentLevel.playerCollidedWithPlatform(this)) {
      // if on top edge
      if (currentLevel.playerHitTopEdgePlatform()) {
        onTheGround = true; // set to true, player's may only jump when on the ground (unless have jetpack)
        this.position.y = currentLevel.platformCollidedPos.y - this.playerHeight; // set position of player to be on top of platform they collided with
        // set velocity to 0 to reset speed of player
        velocity.mult(0);
        // if the platform is the goal platform then the player wins the level
        if (currentLevel.playerOnTopOfGoalPlatform) {
          currentLevel.levelWon = true;
        }
      }
      // if play hits bottom edge then snap them to the bottom edge of the platform
      else if (currentLevel.playerHitBottomEdgePlatform()) {
        this.position.y = currentLevel.platformCollidedPos.y + currentLevel.collidedPlatformHeight;
      }
      // if player hits left edge then snap their position to the left edge
      else if (currentLevel.playerHitLeftEdgePlatform()) {
        this.position.x = currentLevel.platformCollidedPos.x - playerWidth;
      }
      // if player hits right edge then snap their position to the right edge
      else if (currentLevel.playerHitRightEdgePlatform()) {
        this.position.x = currentLevel.platformCollidedPos.x + currentLevel.collidedPlatformWidth;
      }
      
    } else {
      onTheGround = false; // player must be in the air if they are not on the platform
    }

  }
  
  /**
   * Attempts to remove a given Item from the players inventory when provided with the item's name.
   * Throws an IllegalArgumentException if item cannot be found.
   */
  void removeItemFromInventory(String itemName) throws IllegalArgumentException{
    if (inventory.containsKey(itemName)) {
      inventory.remove(itemName);
    } else {
      throw new IllegalArgumentException("Item " + itemName + "is not in the player's inventory");
    }
  }
  
  /**
   * Attempts to purchase an item by storing it in the player's inventory and decreasing their total points.
   * Throws an InsufficientFundsException if the player does not enough points to buy the item.
   */
  void purchaseItem(Item item) throws InsufficientFundsException, PlayerAlreadyHasItemException {
    // If the cost of the item is more than the player's points, thrown an exception
    if (item.cost > totalPoints) {
      throw new InsufficientFundsException("You do not have the funds to purchase this item.");
    }
    // Otherwise the player has enough money to buy the item
    else {
      // Check if the item exists in the player's inventory, if so then increment the quantity of it.
      if (inventory.containsKey(item.itemName)) {
        // Jetpack and FireballGun are unique items which the player cannot have more than one of at a time. Throw an exception if they already have it.
        if (item instanceof Jetpack || item instanceof FireballGun) {
          throw new PlayerAlreadyHasItemException("Player already has a " + item.itemName);
        }
        int quantity = inventory.get(item.itemName);
        // update the value of the item
        inventory.put(item.itemName, quantity+1);
        // decrease players total points by cost of item
        player.totalPoints -= item.cost;
      }
      // Need to add new item to inventory
      else {
        inventory.put(item.itemName, 1);
        // decrease player's points by cost of item
        player.totalPoints -= item.cost;
        if (item instanceof FireballGun) {
          fireballGun = new FireballGun();
        }
      }
    }
    
  }
  
}
