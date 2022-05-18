/**
 * Represents an PlayerAlreadyHasItemException which subclasses the Exception class.
 * Used when a player already has a unique item which cannot be purchased more than once.
 * 
 * Created by Lesleyjane J.
 */
public class PlayerAlreadyHasItemException extends Exception {

  /**
   * Create a new PlayerAlreadyHasItemException by specifying the exception message.
   */
  PlayerAlreadyHasItemException(String message) {
    super(message);
  }
  

  
  
}
