/**
 * Use this class to create a Firegun Item. Subclasses Item.
 *
 * Created by Lesleyjane J.
 */
public class FireballGun extends Item {
  Queue<Fireball> ammo;
  int numBullets;
  /**
   * Create a new Jetpack.
   */
  public FireballGun() {
    this.itemName = "Fireball Gun";
    this.cost = 750; // cost to purchase.
    this.description = "A fireball gun can be used whenever you like throughout all levels. However, it only holds 10 fireballs in total!";
    numBullets = 10;
    ammo = new LinkedList<>();
    initialiseAmmo();
  }
  
  void initialiseAmmo() {
    for (int i = 0; i < numBullets; i++) {
      ammo.add(new Fireball());
    }
  }
  
  Fireball getNextFireball() throws IllegalStateException {
    if (ammo.isEmpty()) {
      throw new IllegalStateException("No more fireballs left");
    }
    return ammo.remove();
    
  }

}
