trigger AccountTrigger on Account (after update) {
    if(Trigger.new[0].Description == 'Account Channel'){
        Account_Channel__e newsEvent = new Account_Channel__e(
           Account_Id__c = Trigger.new[0].Id);
        // Call method to publish events
        Database.SaveResult sr = EventBus.publish(newsEvent);
        system.debug('Inside sr ' + sr);
    }
}