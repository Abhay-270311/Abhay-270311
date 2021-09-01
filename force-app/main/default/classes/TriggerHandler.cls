/**********************************************************************************************
@Author     : TBD   
@date       : 31.05.2019  
@description: This is an abstract class (base class) which contains methods to be implemented by
the Trigger handlers to be extended.
@group  TriggerHandler  
**********************************************************************************************/

public abstract class  TriggerHandler  {
    public string soBJectName;
    public TriggerHandler (String sName){
        this.soBJectName=sName;
    }
 
/**********************************************************************************************
@description: This method checks if the triggers are disabled for the running User by 
fetching the custom settings  triggerSettings
**********************************************************************************************/     
    
    public  Boolean isDisabled(){
        boolean isTriggerDisabledValue=false;         
        try {
            /*TriggerManager__c triggerSettings = TriggerManager__c.getInstance();
            // Check if All Triggers are disabled 
            if(triggerSettings.MuteAllTriggers__c != null && triggerSettings.MuteAllTriggers__c){
                return true;                    
            }
            // Check if Trigger is enabled for the SObject             
            if(triggerSettings.DisabledObjects__c != null ) {
                String [] objectArray = new List<String>();        
                objectArray =  triggerSettings.DisabledObjects__c.split(',');        
                // Check if SoBject type is present in disabled Trigger  List                           
                if(objectArray !=  null){
                    for(String s:objectArray){
                        if(s.equalsIgnoreCase(String.valueof(this.soBJectName))){
                            isTriggerDisabledValue=true;
                            break;
                        }
                        else {  
                            isTriggerDisabledValue=false;
                        }
                    }
                }
            }*/
        }   
        
        catch(Exception e){            
            throw e ; 
        }
        return isTriggerDisabledValue;
    }
    
/**********************************************************************************************
@description: Set of trigger event Handlers to be implemented 
**********************************************************************************************/    
    public  abstract String getName();
    public  abstract void beforeInsert(List<SObject> newItems);
    public  abstract void beforeUpdate(List<SObject> newItems, Map<Id, SObject> newItemsMap, Map<Id, SObject> oldItemsMap);
    public  abstract void beforeDelete(Map<Id, SObject> oldItemsMap);
    public  abstract void afterInsert(List<SObject> newItems, Map<Id, SObject> newItemsMap);
    public  abstract void afterUpdate(List<SObject> newItems, Map<Id, SObject> newItemsMap, Map<Id, SObject> oldItemsMap);
    public  abstract void afterDelete(Map<Id, SObject> oldItemsMap);
    public  abstract void afterUndelete(Map<Id, SObject> oldItemsMap);
}