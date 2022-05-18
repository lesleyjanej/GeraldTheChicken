/**
 * The main file for GeraldTheChicken with the game loop in the draw() method.
 * The status of the game switches through the use of a gameState. For instance,
 * the start screen is displayed when the gameState is "START", and the main game screen
 * is displayed when the gameState is "PLAY". There are other game states for showing the next level,
 * losing the game, opening the shop, etc.
 *
 * Created by Lesleyjane J.
 */
Player player; // one player for the game, player plays as Gerald
Shop inGameShop; // the in game shop which can be accessed after successfully completing a level
boolean playerIsJumping, playerIsFlying; // player is flying if has jetpack and holds down space
Level currentLevel; // the current level
Platform goal; // the platform which is the goal platform
int currentLevelNumber;
String gameState; // the state of the game (start, play, lost, etc)
HashSet<Button> purchaseButtons; // stores all the purchase buttons for the shop screen
Iterator<GameObject> itr; //iterator used in the playGame() method

// for slowing the player down when hits a chilli
int startSlowTime;
int totalSlowTime = 3000; //milliseconds
// for when the player is hurt (hits an enemy)
int startTimeHurt;
int maxHurtTime = 1000; //milliseconds
// list of fired fireballs on the screen
Queue<Fireball> firedFireballs;


// images
PImage gerald, gerald_with_gun, gerald_jetpack_and_gun, blue_gerald, red_gerald, gerald_broken_heart, jetpack_gerald, corn, chilli, goalFlag, fireball;
PImage fox, wolf, farmer;
PImage gerald_and_family;
// background images
PImage fieldImage, game_intro_image;
// keep track of number of platforms and game objects to be generated in current level
int numPlatforms, numCorn, numChillis, numEnemies;
// speed at which objects move to the left of the screen
float gameObjectSpeed;

// CONSTANTS which depend on the screen width and height must be initialised in setup()
int PLAYER_WIDTH, PLAYER_HEIGHT;
float PLAYER_START_X, PLAYER_START_Y;
int CORN_WIDTH, CORN_HEIGHT;
int CHILLI_WIDTH, CHILLI_HEIGHT;
int FOX_WIDTH, FOX_HEIGHT;
int FARMER_WIDTH, FARMER_HEIGHT;
int WOLF_WIDTH, WOLF_HEIGHT;
int FLAG_WIDTH, FLAG_HEIGHT;
// platform configurations
int MIN_PLATFORM_WIDTH, MAX_PLATFORM_WIDTH;
float FIRST_PLATFORM_X, FIRST_PLATFORM_WIDTH;
float PLATFORM_DEPTH; // depth of all platforms
float PLATFORM_START_Y;
// gaps (width and height between platforms)
int MIN_WIDTH_GAP_BETWEEN_PLATFORMS; // minimum gap between each platform
int MAX_WIDTH_GAP_BETWEEN_PLATFORMS; // Shouldn't be impossible to jump over
// buttons
int PURCHASE_BUTTON_WIDTH, PURCHASE_BUTTON_HEIGHT;
int BUTTON_WIDTH, BUTTON_HEIGHT;
// fireball gun
float FIREBALL_DIAMETER;

/**
 * Set the size of the screen to fullscreen on all monitors.
 * Use P2D renderer instead of default as gives better game performance.
 * 
 */
void settings() {
  fullScreen(P2D, SPAN);
  //size(1920, 1080, P2D);
}

/**
 * Sets all constants and variables before the game starts.
 * Loads in all images before the game starts.
 * Initialises the first level of the game.
 */
void setup() {
  // Display the start screen to the user by setting the gameState as START
  gameState = "START";
  
  // initialise constants
  PLAYER_WIDTH = 100;
  PLAYER_HEIGHT = 100;
  CORN_WIDTH = PLAYER_WIDTH/2;
  CORN_HEIGHT = PLAYER_HEIGHT/2;
  CHILLI_WIDTH = PLAYER_WIDTH/2;
  CHILLI_HEIGHT = PLAYER_HEIGHT/2;
  FOX_WIDTH = PLAYER_WIDTH * 2/3;
  FOX_HEIGHT = PLAYER_HEIGHT * 2/3;
  FARMER_WIDTH = 100; 
  FARMER_HEIGHT = 189;
  WOLF_WIDTH = PLAYER_WIDTH * 2/3;
  WOLF_HEIGHT = PLAYER_HEIGHT * 2/3;
  FLAG_WIDTH = PLAYER_WIDTH*2;
  FLAG_HEIGHT = PLAYER_HEIGHT*2;
  // platforms
  MIN_PLATFORM_WIDTH = PLAYER_WIDTH*5;
  MAX_PLATFORM_WIDTH = PLAYER_WIDTH*7;
  PLATFORM_DEPTH = PLAYER_HEIGHT*1.5;
  PLATFORM_START_Y = height/2 + PLATFORM_DEPTH;
  MIN_WIDTH_GAP_BETWEEN_PLATFORMS = PLAYER_WIDTH * 2/3;
  MAX_WIDTH_GAP_BETWEEN_PLATFORMS = PLAYER_WIDTH + (PLAYER_WIDTH/2);
  FIRST_PLATFORM_X = 0 + PLAYER_WIDTH*2; // start of screen (0) + player_width
  FIRST_PLATFORM_WIDTH = MAX_PLATFORM_WIDTH;
  // player
  PLAYER_START_X = FIRST_PLATFORM_X + FIRST_PLATFORM_WIDTH/2;
  PLAYER_START_Y = PLATFORM_START_Y - PLAYER_HEIGHT;
  player = new Player(PLAYER_START_X, PLAYER_START_Y); 
  playerIsJumping = false;
  playerIsFlying = false;
  player.totalPoints = INITIAL_POINTS;
  // fireball
  FIREBALL_DIAMETER = PLAYER_WIDTH/2;
  firedFireballs = new LinkedList<>(); //fireballs which have been fired by the user 
  // initialise the in game shop
  inGameShop = new Shop();
  //purchase buttons for the in game shop
  purchaseButtons = new HashSet<>();
  int text_size = 18;
  purchaseButtons.add(new BuyExtraLifeButton(620, 440, 100, 30, text_size, "BUY"));
  purchaseButtons.add(new BuyJetpackButton(950, 500, 100, 30, text_size, "BUY"));
  purchaseButtons.add(new BuyFireballGunButton(1000, 560, 100, 30, text_size, "BUY"));
  
  // loading the images
  gerald = loadImage("gerald.png");
  blue_gerald = loadImage("blue_gerald.png");
  red_gerald = loadImage("red_gerald.png");
  jetpack_gerald = loadImage("jetpack_gerald.png");
  corn = loadImage("corn.png");
  chilli = loadImage("chilli.png");
  fieldImage = loadImage("background.jpg");
  goalFlag = loadImage("goalflag.png");
  gerald_and_family = loadImage("gerald_and_family.png");
  fox = loadImage("fox.png");
  wolf = loadImage("wolf.png");
  farmer = loadImage("farmer.png");
  fireball = loadImage("fireball.png");
  gerald_broken_heart = loadImage("gerald_broken_heart.png");
  game_intro_image = loadImage("game_intro_image.png");
  gerald_with_gun = loadImage("gerald_with_gun.png");
  gerald_jetpack_and_gun = loadImage("gerald_jetpack_and_gun.png");

  // set the level number to 1
  currentLevelNumber = 1;
  // for the first level, the number of platforms and game objects will be:
  numPlatforms = NUM_PLATFORMS_LEVEL_1;
  numCorn = NUM_CORN_LEVEL_1;
  numChillis = NUM_CHILLIS_LEVEL_1;
  numEnemies = NUM_ENEMIES_START;
  gameObjectSpeed = OBJECT_X_SPEED;
  // initialise level 1
  initialiseLevel();
}

/**
 * This method is called before a new level starts,
 * to increase the game difficulty by adding more platforms, corn,
 * chillis, enemies and increasing their speed.
 */
void increaseGameDifficulty() {
  // increase game difficulty 
  numPlatforms += NUM_ADDED_PLATFORMS_PER_LEVEL;
  numCorn += NUM_ADDED_CORN_PER_LEVEL;
  numChillis += NUM_ADDED_CHILLIS_PER_LEVEL;
  // only increment enemies after the agreed level to introduce enemies
  if (currentLevel.levelNumber > LEVEL_NUM_INTRODUCE_ENEMIES) {
    numEnemies += NUM_ADDED_ENEMIES_PER_LEVEL;
  }
  gameObjectSpeed += INCREASED_OBJECT_SPEED_PER_LEVEL;
}

/**
 * Initialise a new level by resetting the player's position, velocity and acceleration.
 * Starts a new level with the new number of platforms, corn, chillis and enemies.
 */
void initialiseLevel() {
  // restart player position, velocity and acceleration
  player.position = new PVector(PLAYER_START_X, PLAYER_START_Y);
  player.velocity = new PVector(0,0);
  player.acceleration = new PVector(0,0);
  // Update the current level to be the next level
  currentLevel = new Level(currentLevelNumber, numPlatforms, numCorn, numChillis, numEnemies);
}

/**
 * Removes effects such as flying (from jetpack) and slow (from chilli).
 * Used when a new level starts.
 * Player's do not get to keep the jetpack
 */
void removeEffects() {
  player.slowed = false;
  // if the jetpack has been activated, remove it from their inventory
  if (player.activeJetpack != null) {
    try {
      player.removeItemFromInventory("Jetpack");
      player.activeJetpack = null;
    } catch (IllegalArgumentException e) {
      System.out.println(e.getMessage());
    }
  }
  
  
}

/**
 * The game loop.
 * Depending on the state, different methods will be called.
 * If the state is START, the start screen will be shown.
 * If the state is PLAY, then the playGame() method will loop.
 * There are methods for the following states: START, INSTRUCTIONS,
 * PLAY, LEVEL COMPLETE, OPEN SHOP, LOST and WON GAME.
 */
void draw() {
  background(96, 130, 182);
  
  if (gameState == "START") {
    startGameScreen();
  }
  else if (gameState == "INSTRUCTIONS") {
    instructionsScreen();
  }
  else if (gameState == "PLAY") {
    playGame();
  }
  else if (gameState == "LEVEL COMPLETE") {
    nextLevelScreen();
  }
  else if (gameState == "OPEN SHOP") {
    openShopScreen();
  }
  else if (gameState == "LOST") {
    lostGameScreen();
  }
  else if (gameState == "WON GAME") {
    wonGameScreen();
  }
}

/**
 * This method displays a background image representing the start menu,
 * and draws an instructions button and a start game button to the screen.
 */
void startGameScreen() {
  background(0);
  textAlign(CENTER);
  smooth();
  image(game_intro_image, 0,0, width,height);
  drawInstructionsButton();
  drawStartGameButton();
}

/**
 * This method displays the game instructions to the screen,
 * and a close instructions button which takes the user back to the start game screen if clicked.
 */
void instructionsScreen() {
  background(255,243,244);
  textAlign(CENTER);
  // show final score
  textSize(32);
  fill(0);
  text("Instructions", width/2, 100);
  textSize(20);
  text("You will play as Gerald, a chicken who has been kidnapped by a farmer :(" + "\n" + "All Gerald wants is to go home to his beloved Shirley and their newborn chick!" + "\n" + "If you beat all " + MAX_LEVELS + " levels then Gerald and his family will be reunited!", width/2, height/2 - 200);
  text("Collect as much corn as you can to increase your points! You may spend your points in the shop after successfully completing a level." + "\n"
  + "Be sure to avoid chillis as they will temporarily freeze you!" + "\n" + "Be wary of the evil foxes, wolves and farmers who are trying to eat you!", width/2, height/2);
  textSize(24);
  text("Press SPACE to jump", width/2, height/2 + 200);
  textSize(20);
  text("You start with 1 life... " + "\n" + "GOOD LUCK!", width/2, height/2 + 300);
  drawCloseInstructionsButton();
}

/**
 * Responsible for drawing an active game to the screen.
 * This includes drawing the player, the game objects and updating these as appropriate.
 * Also checks if the game has been lost or won and if the level has been won. Game state will change according to these.
 */
void playGame() {
  // Draw the background image to the screen
  image(fieldImage,0,0,width,height);
  // render level and player info
  fill(0) ;
  textSize(20);
  text("Level: "+ currentLevelNumber, 2*50, 50/2) ;
  text("Lives: " + player.inventory.get("Extra Life") , 5*50, 25);
  text("Total Points: " + player.totalPoints, 9*50, 25) ;
  // show and update the player's movement
  player.show();
  player.integrate();
  // render the current level (platform, game objects)
  currentLevel.renderLevel();
  
  // if the player is attempting to jump, then apply the up force once such that the player can only jump once at a time.
  if (playerIsJumping) {
    player.applyForce(FORCE_UP);
    playerIsJumping = false;
  }
  
  // if the player is flying (jetpack) then continously apply an up force.
  if (playerIsFlying) {
    player.applyForce(new PVector(0,-5));
  }
  
  // if the player has been slowed then decrease their x position until no longer slowed.
  // the timer will dictate whether they are no longer slowed.
  if (player.slowed) {
    player.position.x -= 0.5;
    int passedTime = millis() - startSlowTime;
    // if the timer has finished, player is no longer slowed
    if (passedTime > totalSlowTime) {
      player.slowed = false;
    }
  }
  
  // if the player has been hurt (by colliding into an enemy)
  if (player.hurt) {
    // start timer for being hurt such that the chicken becomes red for a brief period of time (Player class does this).
    int passedTime = millis() - startTimeHurt;
    if (passedTime > maxHurtTime) {
      player.hurt = false;
    }
    // remove any unique items from inventory such as jetpack or gun
    loseSpecialItems();
  }
  
  // if player has a jetpack that has been activated, check if they still have fuel
  if (player.activeJetpack != null) {
    // if ran out of fuel, then remove jetpack
    if (!player.activeJetpack.gotFuel()) {
      player.activeJetpack = null;
      player.removeItemFromInventory("Jetpack");
    } 
    // jetpack still has fuel, add timer to screen with remaining time
    else {
     fill(0) ;
     textSize(20);
     int remainingTime = player.activeJetpack.timeLeft();
     text("Remaining jetpack time: " + remainingTime, width - 200, 25);
    }
  }
  
  // If the player has a fireball gun, then print its remaining ammo to the screen
  if (player.fireballGun != null) {
    fill(0);
    textSize(20);
    text("Remaining fireballs: " + player.fireballGun.ammo.size(), width-200, 50);
  }
  
  // Iterate through all fired fireballs on the screen to update their positions and show them.
  // Also check if they have travelled out of bounds or collided into a game object.
  Iterator<Fireball> fireballItr = firedFireballs.iterator();
  while (fireballItr.hasNext()) {
    Fireball fireball = fireballItr.next();
    fireball.show();
    fireball.integrate();
    // if out of bounds, then remove the fireball.
    if (fireball.position.x < 0 || fireball.position.x > width) {
      fireballItr.remove();
      break;
    }
    // If has collided with a game object (excludes platforms), which is not a Goal or Corn,
    // then remove the fireball.
    for (GameObject gameObj : currentLevel.gameObjects)  {
      if (gameObj instanceof Goal || gameObj instanceof Corn) {
        continue; // ignore
      }
      if (fireball.intersects(gameObj)) {
        // set game object to "hit". It will be removed by the gameObjects iterator.
        gameObj.hitByFireball = true;
        // remove fire ball
        fireballItr.remove();
        break;
      }
    }
  }

  // Iterate through all game objects to check if any have been hit by a fireball, remove if they have.
  // Also checks if player has hit any of the game objects.
  itr = currentLevel.gameObjects.iterator();
  // while there is another game object in the list
  while (itr.hasNext()) {
    GameObject obj = itr.next();
    // if game object has been hit by a fireball, remove it
    if (obj.hitByFireball) {
      itr.remove();
    }
    // if game object intersects with the player
    if (obj.intersects(player)) {
      // if object is a corn, then increase the player's points and remove the corn.
      if (obj instanceof Corn) {
        // get the corns points
        Corn corn = (Corn)obj;
        int points = corn.worthPoints;
        // update player's points
        player.totalPoints += points;
        // remove corn from gameobjects list
        itr.remove();
        break;
      }
      // if object is a chilli, knock the player back with the resistance force and slow the player down temporarily.
      if (obj instanceof Chilli) {
        // slow player movement
        player.slowed = true;
        // store the current time that the player hit the chilli, such that the timer can start and the player will be slowed
        startSlowTime = millis();
        // knock the player back slightly
        player.applyForce(FORCE_RESISTANCE);
        // remove object
        itr.remove();
        break;
      }
      // if the game object is an enemy, check which type of enemy and apply negative effects to player
      if (obj instanceof Enemy) {
        int numLives = player.inventory.get("Extra Life");
        // if player has intersected with a wolf, they will lose 1 life and will fly backwards
        if (obj instanceof Wolf) {
          player.inventory.put("Extra Life", numLives-1);
          // Makes the player shoot backwards as much as their width
          player.applyForce(new PVector(-PLAYER_WIDTH,0));
        }
        // if player has intersected with a fox, they will lose one life.
        else if (obj instanceof Fox) {
          player.inventory.put("Extra Life", numLives-1);
        }
        // if player has intersected with a farmer, they will lose two lives.
        else if (obj instanceof Farmer) {
          player.inventory.put("Extra Life", numLives-2);
        }
        // knock player back slightly
        player.applyForce(FORCE_RESISTANCE);
        player.hurt = true;
        // start timer for player being "hurt"
        startTimeHurt = millis();
        // remove game object
        itr.remove();
        break;
      }
    }
  }
  // check if game status has changed
  checkLostGame();
  checkWonGame();
  checkWonLevel();
}


/**
 * Remove special items such as a jetpack and gun.
 * Called when a player is "hurt" by an enemy.
 */
void loseSpecialItems() {
  if (player.inventory.containsKey("Jetpack")) {
    try {
      player.removeItemFromInventory("Jetpack");
      player.activeJetpack = null;
    } catch(IllegalArgumentException e) {
      System.out.println(e.getMessage());
    }
  }
  else if (player.inventory.containsKey("Fireball Gun")) {
    try {
      player.removeItemFromInventory("Fireball Gun");
      player.fireballGun = null;
    } catch(IllegalArgumentException e) {
      System.out.println(e.getMessage());
    }
  }
}

/**
 * Check if the player has lost the game.
 * Player loses the game if they have gone out of the screen bounds,
 * if they have lost all lives or if they have missed the goal platform.
 * changes gameState to LOST.
 */
void checkLostGame() {
  // if the player has gone to the left of the screen (fallen off it)
  if (player.position.x < 0) {
    gameState = "LOST";
  }
  // if the player hits the ground
  else if (player.position.y + PLAYER_HEIGHT >= height) {
    gameState = "LOST";
  }
  // if out of lives
  else if (player.inventory.get("Extra Life") < 1) {
    gameState = "LOST";
  }
  // goal platform has gone off the screen and player has missed it
  else if ((currentLevel.goalPlatform.position.x +  currentLevel.goalPlatform.objWidth) < 0) {
    gameState = "LOST";
  }
  
}

/**
 * Checks if the player has won the game.
 * Changes gameState to WON GAME.
 */
void checkWonGame() {
  if (currentLevel.levelNumber > MAX_LEVELS) {
    gameState = "WON GAME";
  }
}

/**
 * Checks if the player has won the current level and changes the gameState appropriately.
 * If this level has been won and it is the last level, then the gameState changes to "WON GAME".
 */
void checkWonLevel() {
  // Check if the current level has been won
  if (currentLevel.levelWon) {
    // If the next level would be over the MAX_LEVELS number, then we have won the whole game.
    if (currentLevel.levelNumber + 1 > MAX_LEVELS) {
      gameState = "WON GAME";
    } 
    else {
      // remove any jetpack flying effect or slow effects
      removeEffects();
      gameState = "LEVEL COMPLETE";
    }
  }
}

/**
 * Draws the next level screen.
 * Shown when a user completes a level.
 * Draws the open shop button and next level button, which the user can click on.
 */
void nextLevelScreen() {
  background(255,243,128);
  textAlign(CENTER);
  textSize(32);
  fill(0);
  text("Congratulations! You completed level " + currentLevelNumber +"!", width/2, (height/2)-100);
  textSize(18);
  text("Total score: " + player.totalPoints, width/2, height/2);
  fill(255);
  textSize(14);
  fill(0, 0, 255);
  drawOpenShopButton();
  drawNextLevelButton();
}



/**
 * Responsible for drawing the elements of the in-store shop to the screen,
 * including the player's points they can spend, the items in their inventory and the items available for purchase.
 */
void openShopScreen() {
  background(243, 207, 198); // pink
  
  // text properties for the "PURCHASE ITEMS" header.
  textAlign(CENTER);
  fill(0); // set text colour to black
  textSize(32);
  text("PURCHASE ITEMS", width/2, 100);
  
  // text properties for the player's balance (money they can spend)
  textAlign(LEFT);
  textSize(20);
  text("Your points: " + player.totalPoints, 10, 150);
  
  // text properties for the player's current inventory
  textSize(22);
  text("PLAYER INVENTORY", 10, 200);
  // Display each item in the inventory
  textSize(18);
  int textHeight = 20; // variable to keep track of the y position for the text
  for (Map.Entry<String, Integer> entry : player.inventory.entrySet()) {
    String itemName = entry.getKey();
    Integer quantity = entry.getValue();
    text("Item: " + itemName + " || " + "Quantity : " + quantity.toString(), 10, 200 + textHeight);
    textHeight += 20; // increment y text position
  }
  
  // text properties for the item's from the shop which the user may purchase
  textSize(22);
  text("ITEMS AVAILABLE FOR PURCHASE", 10, 400);
  textSize(18);
  // Display each item in the shop
  textHeight = 40;
  for (Item item : inGameShop.itemsList) {
    text("Item: " + item.itemName + " || " + "Cost : " + item.cost + "\n" + "Description: " + item.description, 10, 400 + textHeight);
    
    textHeight += 60;
    }  
  // Draw the purchase item buttons for each item, these were initialised in setup(). 
  for (Button button : purchaseButtons) {
    button.show();
  }
  
  // draw the close shop button
  drawCloseShopButton();
}

/**
 * Draws the lost game screen, including the replay button for playing the game again.
 * Displays final score.
 */
void lostGameScreen() {
  background(0);
  textAlign(CENTER);
  fill(255);
  textSize(32);
  text("GAME OVER", width/2, 100);
  textSize(18);
  text("Final score : " + player.totalPoints, width/2, 200);
  image(gerald_broken_heart, width/2 - gerald_broken_heart.width/2, height/2 - gerald_broken_heart.height/2);
  // play again button
  drawReplayButton();
}

/**
 * Draws the won game screen, including the replay button for playing the game again.
 * Displays final score.
 */
void wonGameScreen() {
  background(229,211,229); // light lilac
  textAlign(CENTER);
  fill(0);
  textSize(32);
  text("YOU DID IT!", width/2, 100);
  textSize(18);
  text("Final score : " + player.totalPoints, width/2, 300);
  
  image(gerald_and_family, width/2 - gerald_and_family.width/2, height/2 - gerald_and_family.height/2);

  // play again button
  drawReplayButton();
}


// ------------------- BUTTONS ------------------- // 

/**
 * Draws the instructions button, if pressed, then updates the gameState to INSTRUCTIONS.
 */
void drawInstructionsButton() {
  textAlign(CENTER);
  fill(200);
  float startX = width/2-100;
  float startY = height-200;
  int buttonWidth = 200;
  int buttonHeight = 60;
  int text_size = 26;
  Button instructions = new Button(startX, startY, buttonWidth, buttonHeight, text_size, "INSTRUCTIONS");
  instructions.show();
  fill(0);
  // if the button has been pressed, change gameState to INSTRUCTIONS
  if (instructions.buttonPressed()) {
    gameState = "INSTRUCTIONS";
  }
}

/**
 * Draws the close instructions button, if pressed, then updates the gameState to START.
 */
void drawCloseInstructionsButton() {
  textAlign(CENTER);
  fill(200);
  float startX = 100;
  float startY = height-120;
  int buttonWidth = 200;
  int buttonHeight = 60;
  int text_size = 26;
  Button closeInstructions = new Button(startX, startY, buttonWidth, buttonHeight, text_size, "BACK");
  closeInstructions.show();
  fill(0);
 
  if (closeInstructions.buttonPressed()) {
    gameState = "START";
  }
}

/**
 *  Draws the start game button, if pressed, then updates the gameState to PLAY.
 */
void drawStartGameButton() {
  textAlign(CENTER);
  fill(200);
  float startX = width/2-100;
  float startY = height-120;
  int buttonWidth = 200;
  int buttonHeight = 60;
  int text_size = 26;
  Button startGame = new Button(startX, startY, buttonWidth, buttonHeight, text_size, "START GAME");
  startGame.show();
  fill(0);
 
  if (startGame.buttonPressed()) {
    gameState = "PLAY";
  }
}

/**
 * Draws the close shop button, if pressed, then updates the gameState to LEVEL COMPLETE.
 */
void drawCloseShopButton() {
  textAlign(CENTER);
  fill(200);
  float startX = width/2-100;
  float startY = height-80;
  int buttonWidth = 200;
  int buttonHeight = 60;
  int text_size = 26;
  Button closeShop = new Button(startX, startY, buttonWidth, buttonHeight, text_size, "CLOSE SHOP");
  closeShop.show();
  fill(0);
 
  if (closeShop.buttonPressed()) {
    gameState = "LEVEL COMPLETE";
  }

}

/**
 *  Draws the next level button, if pressed, then increases the game difficulty, level number and updates the gameState to PLAY.
 */
void drawNextLevelButton() {
  textAlign(CENTER);
  fill(200);
  float startX = width/2-100;
  float startY = height/2 + 120;
  int buttonWidth = 200;
  int buttonHeight = 60;
  int text_size = 26;
  Button nextLevel = new Button(startX, startY, buttonWidth, buttonHeight, text_size, "NEXT LEVEL");
  nextLevel.show();
  fill(0);
  // if user presses next level button then level number increases, game difficulty increases. 
  // Level is initialised and gameState changed to PLAY.
  if (nextLevel.buttonPressed()) {
    currentLevelNumber++;
    increaseGameDifficulty();
    initialiseLevel();
    gameState = "PLAY";
  }
}

/**
 * Draws the open shop button, if pressed, then updates the gameState to OPEN SHOP.
 */
void drawOpenShopButton() {
  textAlign(CENTER);
  fill(200);
  float startX = width/2-100;
  float startY = height/2 + 30;
  int buttonWidth = 200;
  int buttonHeight = 60;
  int text_size = 26;
  Button openShop = new Button(startX, startY, buttonWidth, buttonHeight, text_size, "OPEN SHOP");
  openShop.show();
  fill(0);
 
  if (openShop.buttonPressed()) {
    gameState = "OPEN SHOP";
  }
}

/**
 * Draws a replay button,
 * if clicked on then the game settings are reset and
 * the game state changes to "PLAY".
 */
void drawReplayButton() {
  textAlign(CENTER);
  fill(200);
  float startX = width/2-100;
  float startY = height-200;
  int buttonWidth = 200;
  int buttonHeight = 60;
  int text_size = 26;
  Button replay = new Button(startX, startY, buttonWidth, buttonHeight, text_size, "PLAY AGAIN");
  replay.show();
  fill(0);
  if (replay.buttonPressed()) {
    currentLevelNumber = 1; //reset  
    // reset platforms and game objects
    numPlatforms = NUM_PLATFORMS_LEVEL_1;
    numCorn = NUM_CORN_LEVEL_1;
    numChillis = NUM_CHILLIS_LEVEL_1;
    numEnemies = NUM_ENEMIES_START;
    gameObjectSpeed = OBJECT_X_SPEED;
    // remove any effects from previous game
    removeEffects();
    // remove all special items from inventory
    loseSpecialItems();
    // reset player lives and points
    player.inventory.put("Extra Life", INITIAL_LIVES);
    player.totalPoints = INITIAL_POINTS;
    initialiseLevel();
    gameState = "PLAY";
  }
}

// KEY CONTROLS

/**
 * Checks to see if the space key, 'k' or 'K' has been pressed.
 */
void keyPressed() {
  // Only allow the player to jump once each time they are on the ground and do not have an activated jetpack
  if (key == ' ' && player.onTheGround && (player.activeJetpack == null)) {
    playerIsJumping = true;
  }
  // if player has an active jetpack and is pressed space, then they may "fly"
  if (key == ' ' && player.activeJetpack != null) {
    playerIsFlying = true;
  }
  // if player presses k or K and has a jetpack, activate the jetpack.
  if (key == 'k' || key == 'K') {
    if (player.inventory.containsKey("Jetpack")) {
      player.activeJetpack = new Jetpack();
      player.activeJetpack.activate(); // start the timer
    }
  }
}

/**
 * Checks to see if the space key or LEFT,RIGHT arrow keys have been released.
 */ 
void keyReleased() {
  // If the player has an active jetpack and is pressing space, set flying to false if space key released
  if (key == ' ' && player.activeJetpack != null) {
    playerIsFlying = false;
  }
  // If key is pressed LEFT or RIGHT arrow keys and has a fireball gun, then shoot fireballs.
  if (key == CODED) {
    if (keyCode == LEFT || keyCode == RIGHT) {
      if (player.fireballGun != null) {
        // Attempt to get the next fireball from the gun. If no ammo, exception is thrown.
        try {
          Fireball nextFireball = player.fireballGun.getNextFireball();
          // set the fireballs initial position to be where the player is
          nextFireball.setInitialPosition(player.position.x + PLAYER_WIDTH/2, player.position.y + PLAYER_HEIGHT/2 - (FIREBALL_DIAMETER/2));
          // set an initial bullet velocity of 0,0 and update based on direction.
          PVector initialFireballVelocity = new PVector(0,0);
          if (keyCode == LEFT) {
            initialFireballVelocity.x -= FIREBALL_SPEED ;
          }
          if (keyCode == RIGHT) {
            initialFireballVelocity.x += FIREBALL_SPEED ;
          }
          // Set the initial velocity of the fireball.
          nextFireball.setInitialVelocity(initialFireballVelocity);
          //nextFireball.firing = true;
          firedFireballs.add(nextFireball);
        } catch (IllegalStateException e) {
          // no fireballs left
          player.fireballGun = null;
          // remove from inventory
          player.removeItemFromInventory("Fireball Gun");
          System.out.println(e.getMessage());
        }
        
      }
    }
  }
}

/**
 * Checks if the mouse has been released from clicking down.
 */
void mouseReleased() {
  // Loops through all buttons to see if the user's mouse is on the button and has been released,
  // as this means they wish to purchase something.
  for (Button button : purchaseButtons) {
    if (button.mouseOnButton()) {
      if (button instanceof BuyExtraLifeButton) {
        // Try to purchase the extra life item, checks if they have sufficient funds.
        Item item = new ExtraLife();
        try {
          player.purchaseItem(item);
        } catch (InsufficientFundsException e) {
          System.out.println(e.getMessage());
        } catch (PlayerAlreadyHasItemException e) {
          System.out.println(e.getMessage());
        }
        
        return;
      }
      else if (button instanceof BuyJetpackButton) {
        Item item = new Jetpack();
        // Try to purchase the jetpack item, checks if they have sufficient funds and if they already have the jetpack.
        try {
          player.purchaseItem(item);
        } catch (InsufficientFundsException e) {
          System.out.println(e.getMessage());
        } catch (PlayerAlreadyHasItemException e) {
          System.out.println(e.getMessage());
        }
        return;
      }
      
      else if (button instanceof BuyFireballGunButton) {
        Item item = new FireballGun();
        // Try to purchase the fireball gun item, checks if they have sufficient funds and if they already have the fireball gun.
        try {
          player.purchaseItem(item);
        } catch (InsufficientFundsException e) {
          System.out.println(e.getMessage());
        } catch (PlayerAlreadyHasItemException e) {
          System.out.println(e.getMessage());
        }
        return;
      }
      
    }
  }
}
