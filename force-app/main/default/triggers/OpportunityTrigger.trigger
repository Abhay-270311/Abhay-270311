trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    public static string triggerName ='OpportunityTrigger'; 
    String st = Trigger.New[0].TrackingNumber__c;
    OpportunityTriggerHandler1 oppHandlerObj = new OpportunityTriggerHandler1();
    TriggerDispatcher1.run(oppHandlerObj);
}