/**
 * Use this class to create a Jetpack Item. Subclasses Item.
 * 
 * Created by Student 210033811.
 */
public class Jetpack extends Item {
  boolean active;
  int maxTime; // maximum amount of time a jetpack can be active
  int startTime; // the start time a jetpack became active
  int passedTime; // how much time has been passed since the jetpack was activated
  /**
   * Create a new Jetpack.
   */
  public Jetpack() {
    this.itemName = "Jetpack";
    this.cost = 400; // cost to purchase.
    this.description = "Jetpacks last for 5 seconds in one level once activated. Hit 'k' to activate the jetback and hold space to fly!";
    maxTime = 5000;
  }
  
  /**
   * Activate a jetpack by setting the startTime.
   */
  void activate() {
    active = true;
    startTime = millis();
  }
  
  /**
   * Returns true if the jetpack has not run out of time and is therefore still active.
   */
  boolean gotFuel() {
    passedTime = millis() - startTime;
    if (passedTime > maxTime) {
      active = false;
      return false;
    }
    return true;
  }
  
  /**
   * Returns the remaining time for the jetpack to be active in seconds.
   */
  int timeLeft() {
    int timeLeft = (maxTime - passedTime)/1000;
    return timeLeft;
  }
}
