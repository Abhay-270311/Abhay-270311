public with sharing class AccountHelper {
    @AuraEnabled (cacheable=true)
    public static List<Account> getAccountLocations(){
        return[SELECT Id, Name, BillingStreet, BillingCity, 
    BillingState, BillingPostalCode, BillingCountry 
                FROM Account
                ];
    }
}