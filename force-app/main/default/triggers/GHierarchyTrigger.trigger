trigger GHierarchyTrigger on GetHierarchy__c (before insert, after insert, after update) {
    if(Trigger.isInsert){
        if(trigger.isbefore){
			System.debug(' Before Insert--->');
        } else {
            System.debug('After Insert--->');
        }
    }
       
    if(Trigger.isupdate){
        if(trigger.isbefore){
			System.debug(' Before Update--->');
        } else {
            System.debug('After Update--->');
        }
        
    }
}