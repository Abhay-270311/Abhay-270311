public with sharing class AccountController 
{
@AuraEnabled(cacheable=true)
public static List<Account> getaccount(){
    List<Account> acc = [select id,name from account];
    return acc;
}
@AuraEnabled
public static List<Opportunity> getOpps(String id){

    List<Opportunity> ops = [select id,name,amount,stagename from Opportunity where account.id = : id];
    return ops;
}
}