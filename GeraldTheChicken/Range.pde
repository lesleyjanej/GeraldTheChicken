/**
 * Use this class to create a range of float numbers by specifiying the lowest and highest float allowed.
 * Contains method to check if a number is in the range.
 * 
 * Created by Student 210033811.
 */
class Range {
   float low;
   float high;

   /**
    * Create a new Range by specifying the lowest and highest number in the range.
    */
   public Range(float low, float high){
      this.low = low;
      this.high = high;

   }

   /**
    * Returns true if a given number if within the range.
    */
   public boolean contains(float number){
        return (number >= low && number <= high);
   }
   
   /**
    * Prints out the entire range.
    */
   public void printRange() {
     for (float f = low; f < high; f++) {
        System.out.println(f);
     }
   }
}
