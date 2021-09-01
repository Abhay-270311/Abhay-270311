public class CustomIterator
   implements Iterator<UpdateAccountBillingState.WrapperObj>{ 
 
   private List<UpdateAccountBillingState.WrapperObj> accs;
   private Integer currentIndex;
 
   public CustomIterator(List<UpdateAccountBillingState.WrapperObj> accs){
       this.accs = accs;
       this.currentIndex = 0;
   }
 
   public boolean hasNext(){ 
       return currentIndex < accs.size() - 1;
   }    
 
   public UpdateAccountBillingState.WrapperObj next(){
       if(hasNext()) {
           currentIndex++;
           return accs[currentIndex];
       } else {
           throw new NoSuchElementException();
       }
   } 
}