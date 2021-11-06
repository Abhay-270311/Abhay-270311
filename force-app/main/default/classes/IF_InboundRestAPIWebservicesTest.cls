/*
** ____________________________________________________________________________________________
** Worked By:       Payal Ahuja / Mukul Anand Sharma
** Created Date:    25/03/2020
** ============================================================================================
** Description: Test class for IF_HelpGuidelines class
** ____________________________________________________________________________________________
*/
@isTest(SeeAllData = false)
private with sharing class IF_InboundRestAPIWebservicesTest {
    
    @TestSetup
    static void makeData(){
        Map<String, Object> rawAccount = new Map<String, Object> {'Name' => 'INB_ACCOUNT', System.Label.IF_External_Id_API_Name => 'ACC001'};
        Map<String, Object> rawContact = new Map<String, Object> {'LastName' => 'INB_CONTACT', System.Label.IF_External_Id_API_Name => 'CON001'};
                
        Account acc = (Account)JSON.deserialize(JSON.serialize(rawAccount), Account.class);
        insert acc;
        
        Contact con = (Contact)JSON.deserialize(JSON.serialize(rawContact), Contact.class);
        con.AccountId = acc.Id;
        insert con;
    }
    
    static testMethod void testPostwebService(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        IF_InboundRestAPIWebservices.ResponseWrapper resp = new IF_InboundRestAPIWebservices.ResponseWrapper();
        req.requestURI = '/services/apexrest/SalesforceInboundRestAPI/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(getFormattedJSONString());
        RestContext.request = req;
        RestContext.response= res;
        RestContext.request.params.put('SystemName',System.Label.IF_ExcludeSampleSystemName);
        System.Test.startTest();
        resp = IF_InboundRestAPIWebservices.postwebService();
        System.Test.stopTest();
        
        System.assertEquals(true, String.valueOf(resp.responseMsg)?.equalsIgnoreCase('Success'), 'Account Not Updated Successfully.');
    }
    
    static testMethod void testPostwebService2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        IF_InboundRestAPIWebservices.ResponseWrapper resp = new IF_InboundRestAPIWebservices.ResponseWrapper();
        req.requestURI = '/services/apexrest/SalesforceInboundRestAPI/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(getFormattedJSONString());
        RestContext.request = req;
        RestContext.response= res;
        RestContext.request.params.put('SystemName',null);
        System.Test.startTest();
        resp = IF_InboundRestAPIWebservices.postwebService();
        System.Test.stopTest();
        
        System.assertEquals(true, resp.insertedRecordIds == null, 'No records should be inserted');
        
    }
    static testMethod void testPostwebService3(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        IF_InboundRestAPIWebservices.ResponseWrapper resp = new IF_InboundRestAPIWebservices.ResponseWrapper();
        req.requestURI = '/services/apexrest/SalesforceInboundRestAPI/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(getFormattedJSONString());
        RestContext.request = req;
        RestContext.response= res;
        RestContext.request.params.put('SystemName','IRONTREK');
        System.Test.startTest();
        resp = IF_InboundRestAPIWebservices.postwebService();
        System.Test.stopTest();
        
        System.assertEquals(true, resp.insertedRecordIds == null);
        
    }
    
    private static String getFormattedJSONString(){
        JSONGenerator jsonGen = JSON.createGenerator(true);
        for(Account acc : getAllTestAccounts()){
            jsonGen.writeStartObject();
            jsonGen.writeFieldName(acc.Name);
            jsonGen.writeStartArray();
            jsonGen.writeStartObject();
            jsonGen.writeStringField('INB_NAME',acc.Name);
            jsonGen.writeStringField('External Id',String.valueOf(acc.get(System.Label.IF_External_Id_API_Name)));
            jsonGen.writeStringField(System.Label.IF_Closed_Wo,'false');
            jsonGen.writeFieldName('INB_CONTACT');
            jsonGen.writeStartArray();
            for(Contact con : acc.Contacts){
                jsonGen.writeStartObject();
                jsonGen.writeStringField('INB_LASTNAME',con.LastName);
                jsonGen.writeStringField('Child External Id',String.valueOf(con.get(System.Label.IF_External_Id_API_Name)));
                jsonGen.writeStringField(System.Label.IF_Closed_Wo,'false');
                jsonGen.writeEndObject();
            }
            jsonGen.writeEndArray();
            jsonGen.writeEndObject();
            jsonGen.writeEndArray();
            jsonGen.writeEndObject();
        }
        return String.isBlank(jsonGen.getAsString()) ? '{}' : jsonGen.getAsString();
    }
    
    private static List<Account> getAllTestAccounts(){
        final String COM = ',';
        final String WH = ' ';
        final String qrySep = COM + WH;
        List<String> sQuery = new List<String>();
        
        sQuery.add('SELECT');
        sQuery.add(String.join(new List<String>{'Id', 'Name', System.Label.IF_External_Id_API_Name}, qrySep));
        sQuery.add(',(SELECT');
        sQuery.add(String.join(new List<String>{'Id', 'LastName', System.Label.IF_External_Id_API_Name}, qrySep));
        sQuery.add('FROM Contacts)');
        squery.add('FROM Account LIMIT 1');
                
        return Database.query(String.join(squery, WH));
        
    }
    
}