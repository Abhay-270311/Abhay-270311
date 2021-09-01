trigger ContactTrigger on Contact (before insert) {

    if(trigger.isExecuting){
    }
    List<Account> lstAcc=[SELECT Id FROM Account Order by Name limit 1];
    for(Contact c:trigger.New){
        Contact obj=new Contact();
        obj.AccountId=lstAcc[0].Id;
        obj.LastName='LastName';
        insert obj;
    }
 }