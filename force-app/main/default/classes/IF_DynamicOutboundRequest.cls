/*
** ____________________________________________________________________________________________
** Worked By:       Nilesh Jaiswal, Pranav Chavan, Rohit Midha
** Created Date:    15/04/2020
** ============================================================================================
** Description: Outbound Request controller which sends the request in json to endpoint
** ____________________________________________________________________________________________
*/
public class IF_DynamicOutboundRequest {
	/**
        @MethodName : getFinalJSON
        @Param1     : List of sObject records 
        @Param2     : sObject API name (ex. Account)
        @Param3     : Map of child object API name to Child Object relationship Name
        @Param4     : Map of field mappings with external attribute name
        @Param5     : Map of sObject Name to comma separated Query fields
        @Description: Method to get the JSON for Parent and Child records
        @Return     : Final JSON string
    **/
    public static string getFinalJSON(List<sObject> sObjects, String sObjectName, Map<String, String> mapChildObjNameToRelationshipName, 
                                      Map<String, Map<String, String>> mapFieldMappings, map<String, String> mapObjectNameToQueryFields,
                                      Map<String, String> sObjAPIToNodeNameMap) 
    {
        Integer parentCounter = 0 ;
        String strJSON = '';
        Map<String, String> mainObjectMapping = mapFieldMappings.get(sObjectName);
        
        //iterate over sobject record to prepare the parent child json
        for(sObject sObj : sObjects) {
            parentCounter++;
            //if counter is 1 then start the node else append in existing json
            if(parentCounter == 1) {
                strJSON += '{\"' + sObjAPIToNodeNameMap.get(sObjectName) + '\" : [{';
            }
            else {
                strJSON += ', {';
            }
            
            //iterate over field mapping to prepare attribute and value pair in json
            for(String field : mainObjectMapping.keySet()) {
                strJSON += '\"' + mainObjectMapping.get(field) + '\": \"' + sObj.get(field) + '\",';
            }
            
            String strChildJSON = '';
            Integer childCounter = 0 ; 
            //iterate over child object records to prepare attribute and value pair in json
            for(String chilObjectName : mapChildObjNameToRelationshipName.keySet()) {
                system.debug('===chilObjectName==='+chilObjectName);
                if(mapObjectNameToQueryFields.containsKey(chilObjectName)) { 
                    if(sObj.getSObjects(mapChildObjNameToRelationshipName.get(chilObjectName)) != null) {
                        childCounter++;
                        //if counter is 1 then start the node else append in existing json
                        if(childCounter != 1) {   
                            strChildJSON += ',' + getChildJSON(sObj.getSObjects(mapChildObjNameToRelationshipName.get(chilObjectName)), chilObjectName, 
                                                               mapFieldMappings.get(chilObjectName), sObjAPIToNodeNameMap);                    
                        }
                        else { 
                            strChildJSON += getChildJSON(sObj.getSObjects(mapChildObjNameToRelationshipName.get(chilObjectName)), chilObjectName, 
                                                         mapFieldMappings.get(chilObjectName), sObjAPIToNodeNameMap);
                        }
                    }
                    system.debug('===strChildJSON==='+strChildJSON);
                }   
            }
            strJSON += strChildJSON + '}';
            strJSON = strJSON.replaceAll(',(?=\\s*?[}])','');
        }
        strJSON +=']}';
        system.debug('===strJSON==='+strJSON);
        return strJSON ;
    }
    /* End */
    
    /**
        @MethodName : getChildJSON
        @Param1     : List of sObject records 
        @Param2     : child sObject API name (ex. Contact)
        @Param3     : Child relationship name (ex. Contacts)
        @Param4     : Map of field mappings with external attribute name
        @Description: Method to get the JSON for Child records
        @Return     : Final child JSON string
    **/
    public static String getChildJSON(List<sObject> sObjects, String childObjectName, Map<String, String> mapFieldMappings, Map<String, String> sObjAPIToNodeNameMap) {
        system.debug('===sObjects==='+sObjects.size());
        system.debug('===childObjectName==='+childObjectName);
        system.debug('===mapFieldMappings==='+mapFieldMappings);
        
        String strJSON = '\"' + sObjAPIToNodeNameMap.get(childObjectName) + '\" : [';
        Integer counter = 0;
        for(sObject sObj : sObjects) {
            counter++;
            
            strJSON +=  '{';
            //iterate over field mappings with external attribute name to prepare child JSON
            for(String field : mapFieldMappings.keySet()) {
                strJSON += '\"' + mapFieldMappings.get(field) + '\": \"' + sObj.get(field) + '\",';
            }
            //if counter is not equals to list size then append the JSON else end the JSON data 
            if(counter == sObjects.size()) {
                strJSON += '}]';
            } else {
                strJSON += '},';
            }
        }
        system.debug('===childstrJSON==='+strJSON);
        return strJSON;
    }
    /* End */
    
   /**
        @MethodName : sendRestRequest
        @Param1     : List of sObject record
        @Param2     : sObject API name (ex. Account)
        @Param3     : End Point URL where the request will be sent
        @Description: Method to send the request to endpoint
        @Return     : Final child JSON string    
    **/
    public static String sendRestRequest(List<sObject> sObjectList, String sObjectName, String namedCred) {
        Map<Id, sObject> sObjectMap = new Map<Id, sObject>(sObjectList) ;
        return sendRestRequest(sObjectMap.keyset(), sObjectName, namedCred);
        
    }
    
    /**
        @MethodName : sendRestRequest
        @Param1     : Set of sObject record Ids
        @Param2     : sObject API name (ex. Account)
        @Param3     : End Point URL where the request will be sent
        @Description: Method to send the request to endpoint
        @Return     : Final child JSON string
    **/
    public static String sendRestRequest(Set<Id> sOjbectIds, String sObjectName, String namedCred) {
        List<Integration_Framework__mdt> intFrameworkList = [SELECT Child_Object_Names__c, Node_Names_External_System__c, Method__c, 
                                                             Object_Name__c, Send_Request__c
                                                             FROM Integration_Framework__mdt WHERE Object_Name__c =: sObjectName
                                                             AND Named_Credential_Name__c =: namedCred];
        system.debug('===intFrameworkList==='+intFrameworkList);
        if(intFrameworkList.isEmpty())
            return '';
        
        Integration_Framework__mdt objCMT = intFrameworkList[0];
        
        //set of all sObject API names for the current request
        Set<String> setAllObjectNames = new Set<String>{sObjectName};
        system.debug('===setAllObjectNames==='+setAllObjectNames);
            
        //get external node name map
        Map<String, String> sObjAPIToNodeNameMap = IntegrationManager.getExternalNodeNamesMap(objCMT.Node_Names_External_System__c);    
        system.debug('===sObjAPIToNodeNameMap==='+sObjAPIToNodeNameMap);
        
        //Map of child object name to child object relationship name
        Map<String, String> mapChildObjNameToRelationshipName = getChildObjects(Schema.getGlobalDescribe().get(sObjectName), objCMT.Child_Object_Names__c);
        system.debug('===mapChildObjNameToRelationshipName==='+mapChildObjNameToRelationshipName);
        
        //add all child object API names
        setAllObjectNames.addAll(mapChildObjNameToRelationshipName.keySet());
        
        //Map of sObject API name to Query fields
        Map<String, String> mapObjectNameToQueryFields = getQueryFields(setAllObjectNames);
        system.debug('===mapObjectNameToQueryFields=== '+mapObjectNameToQueryFields);
        
        //map of sobject API name to map of salesforce field to external attribute name
        Map<String, Map<String, String>> mapFieldMappings = getFieldMappings(setAllObjectNames);
        system.debug('===mapFieldMappings==='+mapFieldMappings);
        
        //prepare dynamic query with inner query for child records
        String strQuery = prepareQuery(sOjbectIds, sObjectName, mapObjectNameToQueryFields, mapChildObjNameToRelationshipName);
        system.debug('===strQuery==='+strQuery);
        system.debug('===result==='+JSON.serialize(Database.query(strQuery)));
        
        //final JSON with parent and child records
        String strJSON  = getFinalJSON(Database.query(strQuery), sObjectName, mapChildObjNameToRelationshipName, mapFieldMappings,mapObjectNameToQueryFields, sObjAPIToNodeNameMap);
        system.debug('===getFinalJSON==='+strJSON);
        
        //send the request to endpoint URL
        NamedCredential namedCredObj = [SELECT Id, MasterLabel, DeveloperName, Endpoint FROM NamedCredential WHERE DeveloperName =: namedCred];
        Http http = new Http();
        HttpResponse response;  
        HttpRequest request = new HttpRequest();
        //req.setEndpoint(namedCredObj.Endpoint);
        request.setEndpoint('callout:'+namedCred);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setTimeOut(120000);
        request.setBody(strJSON);
        system.debug('====request===='+request);
        response = http.send(request);
        system.debug('====response===='+response);
        return strJSON;
    }
    /* End */
    
    /**
        @MethodName : prepareQuery
        @Param1     : Set of sObject record Ids
        @Param2     : sObject API name (ex. Account)
        @Param3     : End Point URL where the request will be sent
        @Description: Method to send the request to endpoint
        @Return     : Final child JSON string
    **/
    private static String prepareQuery(Set<Id> sOjbectIds , String sObjectName, Map<String, String> mapObjectNameToQueryFields, Map<String, String> mapChildObjNameToRelationshipName) {
        String strQuery = 'SELECT ';
        String strChildQuery = '';
        
        //prepare parent and child query dynamically based on metada records
        for(String objName : mapObjectNameToQueryFields.keySet()) {
            
            if(mapChildObjNameToRelationshipName.containsKey(objName)) {
                strChildQuery += ', (SELECT ' + mapObjectNameToQueryFields.get(objName) + ' FROM ' + mapChildObjNameToRelationshipName.get(objName) + ')';
            } else {
                strQuery += mapObjectNameToQueryFields.get(objName);
            }
        }
        strQuery += strChildQuery + ' FROM ' + sObjectName + ' WHERE Id IN : sOjbectIds' ;
        return strQuery;
    }
    /* End */
    
    /**
        @MethodName : getQueryFields
        @Param1     : Set of sObject API Names
        @Description: Method to get a map of sobject api name to comma separated fields
        @Return     : Map of sobject api name to comma separated fields
    **/    
    private static Map<String, String> getQueryFields(Set<String> setObjectNames) {
        Map<String, Set<String>> mapObjectNameToFieldSet = new Map<String, Set<String>>();
        Map<String, String> mapObjectNameToQueryFields = new Map<String, String>();
        
        //get all active field mappings to prepare a comma separated list salesforce fields
        for(Integration_Framework_Mapping__mdt objIFM : [SELECT Attribute_Name__c, Object_Name__c, Salesforce_Field__c
                                                         FROM Integration_Framework_Mapping__mdt 
                                                         WHERE Object_Name__c IN : setObjectNames 
                                                         AND Not_Include_In_Request__c = FALSE])
        {
            if(!mapObjectNameToFieldSet.containsKey(objIFM.Object_Name__c)) {
                mapObjectNameToFieldSet.put(objIFM.Object_Name__c, new Set<String>());
            }
            mapObjectNameToFieldSet.get(objIFM.Object_Name__c).add(objIFM.Salesforce_Field__c);
        }
        
        for(String objName : mapObjectNameToFieldSet.keySet()) {
            List<String> lstFields = new List<String>(mapObjectNameToFieldSet.get(objName));
            mapObjectNameToQueryFields.put(objName, String.join(lstFields, ', '));
        }
        return mapObjectNameToQueryFields;
    }
    /* End */
    
    /**
        @MethodName : getFieldMappings
        @Param1     : Set of sObject API names
        @Description: Method to get field mappings 
        @Return     : Map of object api to field mappings with extenal attribute name
    **/
    private static Map<String, Map<String, String>> getFieldMappings(Set<String> setObjectNames) {
        Map<String, Map<String, String>> mapObjectNameToFieldMapping = new Map<String, Map<String, String>>();
        
        //get all active field mappings
        for(Integration_Framework_Mapping__mdt objIFM : [SELECT Attribute_Name__c, Object_Name__c, Salesforce_Field__c
                                                         FROM Integration_Framework_Mapping__mdt 
                                                         WHERE Object_Name__c IN : setObjectNames
                                                         AND Not_Include_In_Request__c = FALSE])
        {
            if(!mapObjectNameToFieldMapping.containsKey(objIFM.Object_Name__c)) {
                mapObjectNameToFieldMapping.put(objIFM.Object_Name__c, new Map<String, String>());
            }
            mapObjectNameToFieldMapping.get(objIFM.Object_Name__c).put(objIFM.Salesforce_Field__c, objIFM.Attribute_Name__c);
        }
        return mapObjectNameToFieldMapping;
    }
    /* End */
    
    /**
        @MethodName : getChildObjects
        @Param1     : sObjectType token
        @Param2     : comma separated child object names
        @Description: Method to get all child object with relationship names
        @Return     : Map of child object name to relationship name
    **/
    private static Map<String, String> getChildObjects(Schema.SObjectType sObjectToken, String childObjectNames) {
        Map<String, String> mapChildObjNameToRelationshipName = new Map<String, String>();
        Schema.DescribeSObjectResult objDescribe = sObjectToken.getdescribe();
        List<Schema.ChildRelationship> lstChildRelationship = objDescribe.getChildRelationships();
        Set<String> setChildObjectNames = new Set<String>();

        if(String.isNotBlank(childObjectNames)) {
            for(String childObjectName : childObjectNames.split(',')) {
                setChildObjectNames.add(childObjectName.trim());                
            }
        }
        
        //iterate over child relationship object list
        for(Schema.ChildRelationship objCR : lstChildRelationship) {
            String childFieldToken = String.valueof(objCR.getField());
            String childObjectName = String.valueof(objCR.getChildSObject());
            String relationshipName = objCR.getRelationshipName();
            if(String.isNotBlank(relationshipName) && setChildObjectNames.contains(childObjectName) && childFieldToken.contains(String.ValueOf(sObjectToken))) {
                mapChildObjNameToRelationshipName.put(childObjectName, relationshipName);                
            }
        }
        return mapChildObjNameToRelationshipName;
    }
    /* End */
}