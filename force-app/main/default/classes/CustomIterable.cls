public class CustomIterable {
	public Iterator<UpdateAccountBillingState.WrapperObj> iterator(){
      List<UpdateAccountBillingState.WrapperObj> accs = new List<UpdateAccountBillingState.WrapperObj>();
        for( Account accT: [SELECT ID,Name,BillingState,BillingCountry, (Select FirstName, email from Contacts) FROM Account]){
            accs.add(new UpdateAccountBillingState.WrapperObj(accT, accT.Contacts));
        }
           
           
      return new CustomIterator(accs);
   }
}