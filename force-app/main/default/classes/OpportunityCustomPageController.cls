public class OpportunityCustomPageController {
	public Opportunity opt { get; set; }
  
    public OpportunityCustomPageController(){
       opt = new Opportunity();
       
       String optId = ApexPages.currentPage().getparameters().get('id');
       opt = [SELECT Id, Name, AccountId, StageName, Type FROM Opportunity WHERE Id = :optId LIMIT 1];
    }

   
}