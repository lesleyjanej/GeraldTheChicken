/**
 * Use this class to create a new Button and check if the player has clicked on it.
 * Contains a method show() for displaying the button to the screen.
 *
 * Created by Lesleyjane J.
 */
public class Button {
 float startX; // start X coordinate of the button
 float startY;  // start Y coordinate of the button
 float leftEdge; // most left x point of the button
 float rightEdge; // most right x point of the button
 float topEdge; // highest y point of the button
 float bottomEdge; // lowest y point of the button
 float buttonHeight;
 float buttonWidth;
 int text_size; // size of text to be displayed on the button
 String buttonText; // text to be displayed on the button
 boolean buttonPressed;
 
 /**
  * Create a new button by specifying the start x and y coordinates, the width and height,
  * size of text and String of text to be displayed on the button.
  */
 public Button(float startX, float startY, int buttonWidth, int buttonHeight, int text_size, String buttonText) {
   this.startX = startX;
   this.startY = startY;
   this.buttonWidth = buttonWidth;
   this.buttonHeight = buttonHeight;
   this.leftEdge = startX;
   this.rightEdge = startX + buttonWidth;
   this.topEdge = startY;
   this.bottomEdge = startY + buttonHeight;
   this.text_size = text_size;
   this.buttonText = buttonText;
   buttonPressed = false; //initially false
   
 }
 
 /**
  * Display the button as a coloured rectangle with text.
  */
 public void show() {
   fill(161,199,155);
   rect(startX, startY, buttonWidth, buttonHeight);
   fill(0);
   textAlign(CENTER);
   textSize(text_size);
   text(buttonText, startX + buttonWidth/2, startY + buttonHeight/2);
 }
 
 /**
  * Returns true if the button was pressed.
  */
 public boolean buttonPressed() {
   if (mousePressed == true &&
    mouseX > leftEdge &&
    mouseX < rightEdge &&
    mouseY < bottomEdge &&
    mouseY > topEdge){
      return true;
   }
   return false;
 }
 
 /**
  * Returns true if the user's mouse if hovering over the button.
  */
 public boolean mouseOnButton() {
   if (
    mouseX > leftEdge &&
    mouseX < rightEdge &&
    mouseY < bottomEdge &&
    mouseY > topEdge) {
      return true;
   }
   return false;
 }
 
 
}
