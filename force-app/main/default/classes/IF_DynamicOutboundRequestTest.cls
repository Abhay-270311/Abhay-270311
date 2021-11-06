/*
** ____________________________________________________________________________________________
** Worked By:       Payal Ahuja/Sunil Jadhav
** Created Date:    01/06/2020
** ============================================================================================
** Description: Test class for IF_DynamicOutboundRequest class
** ____________________________________________________________________________________________
*/

@IsTest
public class IF_DynamicOutboundRequestTest implements HttpCalloutMock {
    @TestSetup 
    static void setup() {

        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();
        accounts.add(new Account(
            Name = 'Sample Account',
            Type = 'Industry'
        ));
        insert accounts;
        
        for(Account acc : accounts){
            contacts.add(new Contact(
                FirstName = acc.Name + ' ContactFirstName1',
                LastName = acc.Name + ' ContactLastName1',
                AccountId = acc.Id
            ));
            contacts.add(new Contact(
                FirstName = acc.Name + ' ContactFirstName2',
                LastName = acc.Name + ' ContactLastName2',
                AccountId = acc.Id
            ));
            contacts.add(new Contact(
                FirstName = acc.Name + ' ContactFirstName3',
                LastName = acc.Name + ' ContactLastName3',
                AccountId = acc.Id
            ));
        }
        insert contacts;
    }
    
    @Istest 
    static void testSendRestRequest(){
        System.Test.startTest();
        System.Test.setMock(HttpCalloutMock.class,new IF_DynamicOutboundRequestTest());
        String obj = IF_DynamicOutboundRequest.sendRestRequest(getAllTestAccounts() , 'Account', 'IF_DONOTDELETENAMEDCREDENTIAL');
        System.Test.stopTest();

        System.assertEquals(false, String.isBlank(obj), 'Output String Should not be Empty');
    }    
    
    @Istest 
    static void testGetFinalJSON(){
        System.Test.startTest();
        System.Test.setMock(HttpCalloutMock.class,new IF_DynamicOutboundRequestTest());
        List<sObject> sObjects = new List<sObject>{new Contact()};
        String sObjectName = 'Contact';
        Map<String, String> mapFieldMappings = new Map<String,String> {'AccountId'=>'AccountId'};
        Map<String, String> sObjAPIToNodeNameMap = new Map<String,String> {'Contact'=>'Contacts'};
        String obj = IF_DynamicOutboundRequest.getChildJSON(sObjects, sObjectName, mapFieldMappings, sObjAPIToNodeNameMap);
        System.Test.stopTest();

        System.assertEquals(false, String.isBlank(obj), 'Output String Should not be Empty');
    }    

    private static List<Account> getAllTestAccounts(){
        return [SELECT Id, Name, Type,
                (SELECT Id, FirstName, LastName, Name FROM Contacts)
                FROM Account 
                LIMIT 1];
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        res.setStatusCode(200);
        return res;
    }
}