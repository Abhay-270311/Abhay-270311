trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    public static string triggerName ='OpportunityTrigger';   
    OpportunityTriggerHandler oppHandlerObj = new OpportunityTriggerHandler();
    TriggerDispatcher.run(oppHandlerObj);
}