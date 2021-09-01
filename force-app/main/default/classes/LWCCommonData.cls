/************************************
* Created By  : Abhay
* Created Date: 15-Apr-2021
* Description : Test the LWC call to Apex in Imperative way
************************************/
public with sharing class LWCCommonData {
    @AuraEnabled
    public static List<Opportunity> getoptyData(){
        try {
            return [ Select Id, Name, Amount, StageName, Type, CloseDate From Opportunity
                    WITH_SECURITY_ENFORCED];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    } 
    
    @AuraEnabled
    public static Map<String,List<Contact>> getAccttContacts(){
        Map<String,List<contact>> mAc = new Map<String,List<contact>>();
        try {
            
            for(List<Account> actL: [Select Id, (Select FirstName, LastName From Contacts) From Account]){
                for(Account ac: actL){
                    mAc.put(ac.Id,ac.contacts);
                }
            }
            
            return mAc;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<Object> getRestCalloutData(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            // Cast the values in the 'animals' key as a list
            List<Object> animals = (List<Object>) results.get('animals');
            System.debug('Received the following animals:');
            for (Object animal: animals) {
                System.debug(animal);
            }
            return animals;
        }else {
            return null;
        }
        
    }
    /*
==================

Apex snippets file:
{
// Place your snippets for apex here. Each snippet is defined under a snippet name and has a prefix, body and 
// description. The prefix is what is used to trigger the snippet and the body will be expanded and inserted. Possible variables are:
// $1, $2 for tab stops, $0 for the final cursor position, and ${1:label}, ${2:another} for placeholders. Placeholders with the 
// same ids are connected.
// Example:
// "Print to console": {
// 	"prefix": "log",
// 	"body": [
// 		"console.log('$1');",
// 		"$2"
// 	],
// 	"description": "Log output to console"
// }

"author": {
"prefix": "auth",
"body": [
"/ ************************************",
" * Created By  : ${1:Name}",
" * Created Date: ${2:Date}",
" * Description : ${3:Description}",
" ************************************ /"
],
"description":"Insert Author"
}
}
==================
Global Snippets file
{
// Place your LWC workspace snippets here. Each snippet is defined under a snippet name and has a scope, prefix, body and 
// description. Add comma separated ids of the languages where the snippet is applicable in the scope field. If scope 
// is left empty or omitted, the snippet gets applied to all languages. The prefix is what is 
// used to trigger the snippet and the body will be expanded and inserted. Possible variables are: 
// $1, $2 for tab stops, $0 for the final cursor position, and ${1:label}, ${2:another} for placeholders. 
// Placeholders with the same ids are connected.
// Example:
// "Print to console": {
// 	"scope": "javascript,typescript",
// 	"prefix": "log",
// 	"body": [
// 		"console.log('$1');",
// 		"$2"
// 	],
// 	"description": "Log output to console"
// }

"Expander": {
"scope": "javascript,typescript,html",
"prefix": "Expander",
"body": [
"<c-expand-collapse-cmp title-lc=\"$1\">",
"<span slot=\"innerElement\">",
"$2",
"</span></c-expand-collapse-cmp>"
],
"description": "To wrap component with Expand Collapse"
},

"Targets": {
"scope": "javascript,typescript,xml",
"prefix": "targets",
"body": [
"<targets>",
"<target>lightning__AppPage</target>",
"<target>lightning__HomePage</target>",
"<target>lightning__RecordPage</target>",
"<target>lightning__UtilityBar</target>",
"</targets>"
],
"description": "To add targets"
}
}

*/
    
    
    @AuraEnabled
    public static List<RecordsData> searchRecords(String objectName, String filterField, String searchString, String value) {
        System.debug('objectName :: ' + objectName);
        List<RecordsData> recordsDataList = new List<RecordsData>();
        try {
            
            String query = 'SELECT Id, ' + filterField + ' FROM '+objectName;
            if(String.isNotBlank(value)) {
                query += ' WHERE Id = \''+ value + '\' LIMIT 100';
            } else {
                query += ' WHERE '+filterField+
                    ' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\' LIMIT 100';
            }
            for(SObject s : Database.query(query)) {
                recordsDataList.add( new RecordsData((String)s.get(filterField), (String)s.get('id')) );
            }
            return recordsDataList;
        } catch (Exception err) {
            if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                //throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                //throw new AuraHandledException(err.getMessage());
            }
        }
        return recordsDataList;
        
    }
    
    public class RecordsData {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        public RecordsData(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
    
}