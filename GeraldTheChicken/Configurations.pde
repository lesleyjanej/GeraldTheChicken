// This file stores constants which are frequently used by other classes.
// Does not store any constants which use the display height or width, these are in the main file and are initialised in setup().


// players initial lives
int INITIAL_LIVES = 1;
int INITIAL_POINTS = 0;

// valid enemy types
enum EnemyTypes {
  FOX,
  WOLF,
  FARMER
}
  
// forces
PVector FORCE_GRAVITY = new PVector(0, 0.4);
PVector FORCE_UP = new PVector(0,-16);
PVector FORCE_RESISTANCE = new PVector(-4,0);
int MAX_VELOCITY = 15;
int MAX_VELOCITY_WITH_JETPACK = 3;

// levels
int MAX_LEVELS = 6;
int NUM_PLATFORMS_LEVEL_1 = 5;
int NUM_CORN_LEVEL_1 = 10;
int NUM_CHILLIS_LEVEL_1 = 2;
int LEVEL_NUM_INTRODUCE_ENEMIES = 2;
int NUM_ENEMIES_START = 1;
float OBJECT_X_SPEED = 3;

// Increasing difficulty in levelling.
int NUM_ADDED_PLATFORMS_PER_LEVEL = 2;
int NUM_ADDED_CORN_PER_LEVEL = 3;
int NUM_ADDED_CHILLIS_PER_LEVEL = 1;
int NUM_ADDED_ENEMIES_PER_LEVEL = 2;

// speed at which platforms and game objects are travelling to the left.
float INCREASED_OBJECT_SPEED_PER_LEVEL = 0.3;

// fireball speed at which fireballs travel on the screen
int FIREBALL_SPEED = 3;
