trigger AccountTriger on Account (before update) {
	if (Trigger.New[0].ExecutionCount__c != null ) Trigger.New[0].ExecutionCount__c++;
}