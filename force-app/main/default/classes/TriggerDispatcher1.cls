/**********************************************************************************************
@author     : TBD    
@date       : 27-07-2021    
@description: This Class is invoked from the trigger and used to dispatch execution to the handler
methods depending on the event 
@group   TriggerDispatcher 
**********************************************************************************************/

public with sharing class TriggerDispatcher1 {    
    private static Map<String, List<String>> recordsAlreadyProcessedByContext;
    static {
        recordsAlreadyProcessedByContext = new Map<String, List<String>>();
    }
    
/**********************************************************************************************
@description: Run methods check if the trigger is enabled and if the records have been executed in the context
@param: TriggerHandler obj
**********************************************************************************************/
    public static void run(TriggerHandler1 handler){
        if(handler != null){        
            if (handler.isDisabled()){            
                return;
            }        
            if(!(Trigger.isBefore && Trigger.isInsert) && wereObjectsAlreadyExecutedInContext(Trigger.new)){                       
                return;
            }
            if (Trigger.isBefore){
                if (Trigger.isInsert){
                    handler.beforeInsert(Trigger.new);
                }
                else if (Trigger.isUpdate){
                    handler.beforeUpdate(Trigger.new, Trigger.newMap, Trigger.oldMap);
                }
                else if (Trigger.isDelete){
                    handler.beforeDelete(Trigger.oldMap);
                }
            }    
            else if (Trigger.isAfter){
                if (Trigger.isInsert){
                    handler.afterInsert(Trigger.new, Trigger.newMap);
                }
                else if (Trigger.isUpdate){
                    handler.afterUpdate(Trigger.new, Trigger.newMap, Trigger.oldMap);
                }
                else if (Trigger.isDelete){
                    handler.afterDelete(Trigger.oldMap);
                }
                else if (Trigger.isUndelete){
                    handler.afterUndelete(Trigger.oldMap);
                }
            }
        }
        
    }
    
    private static TriggerContext getTriggerContext(){
        TriggerContext context;
        if (Trigger.isBefore){
            if (Trigger.isInsert){
                context = TriggerContext.BEFORE_INSERT;
            }
            else if (Trigger.isUpdate){
                context = TriggerContext.BEFORE_UPDATE;
            }
            else if (Trigger.isDelete){
                context = TriggerContext.BEFORE_DELETE;
            }
        }    
        else if (Trigger.isAfter){
            if (Trigger.isInsert){
                context = TriggerContext.AFTER_INSERT;
            }
            else if (Trigger.isUpdate){
                context = TriggerContext.AFTER_UPDATE;
            }
            else if (Trigger.isDelete){
                context = TriggerContext.AFTER_DELETE;
            }
            else if (Trigger.isUndelete){
                context = TriggerContext.AFTER_UNDELETE;
            }
        }
         return context;
    }
    
/******************************************************************
@Description :Validates whether the same list of records were already
executed by this trigger in this context
*******************************************************************/
    private static Boolean wereObjectsAlreadyExecutedInContext(List<SObject> objects){
        String recordIdString = '';
         if(objects != null){
            for(SObject obj : objects){
                recordIdString += obj.get('Id');
            }
            // Build a composite key from the trigger context and the object type
            String contextKey = getTriggerContext().name() + '-' + objects.get(0).getSObjectType().getDescribe().getName();
            if(recordsAlreadyProcessedByContext.containsKey(contextKey)){
                for(String prevIdString : recordsAlreadyProcessedByContext.get(contextKey)){
                    if(prevIdString.equals(recordIdString)){
                        return true;
                    }
                }
                recordsAlreadyProcessedByContext.get(contextKey).add(recordIdString);
            }
            else{
                recordsAlreadyProcessedByContext.put(contextKey, new List<String>{recordIdString});
            }
        }
         return false;
    }
    
/****************************************************************************************************
@Description : Accepts an sObject which needs to be ignored by wereObjectsAlreadyExecutedInContext
from being tracked against repetitive invocations. This is of good use, when testing a object which
could get called repeatedly.For ex. unit testing of Product Basket.
*****************************************************************************************************/ 
    public static void skipObjectfromRecursiveCall(SObject obj) {
        //  String recId = '';  // comment this line for code smell
        String contextKey ;
        List<String> contextVariables = new List<String> {'BEFORE_INSERT','BEFORE_UPDATE','BEFORE_DELETE','AFTER_INSERT','AFTER_UPDATE','AFTER_DELETE','AFTER_UNDELETE'};
                for (String trgCxt : contextVariables ) {
                    contextKey = trgCxt + '-' + obj.getSObjectType().getDescribe().getName();
                    if (recordsAlreadyProcessedByContext.containsKey(contextKey)){
                        recordsAlreadyProcessedByContext.remove(contextKey);
                    }
                }
    }
    public static void skipObjectfromRecursiveCall() {
        recordsAlreadyProcessedByContext.clear(); 
    }
    
    
/******************************************************************************************
@Description : Enum object that will be used in the method skipObjectfromRecursiveCall  
*******************************************************************************************/     
    private enum TriggerContext {
        BEFORE_INSERT, 
            BEFORE_UPDATE, 
            BEFORE_DELETE,
            AFTER_INSERT, 
            AFTER_UPDATE, 
            AFTER_DELETE,
            AFTER_UNDELETE
            }
}