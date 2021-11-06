/*
** ____________________________________________________________________________________________
** Worked By:       Komal Deshmukh, Archana Pawar, Arti Fogla, Kirti Deshpande
** Created Date:    19/07/2019
** ============================================================================================
** Description:  Class for Inbound Web services
** ____________________________________________________________________________________________
*/
@RestResource(urlMapping='/SalesforceInboundRestAPI/*')
global with sharing class IF_InboundRestAPIWebservices{
     /* ResponseWrapper - Start */
    global class ResponseWrapper{
        public String responseMsg;
        public List<Id> insertedRecordIds;
        public List<Id> updatedRecordsIds;
    }
    /* ResponseWrapper - End */
    
    /**
    @MethodName : postwebService
    @Description: Exposing post web service call for third party system
    @Return     : void
    **/
    //services/apexrest/SalesforceInboundRestAPI?SystemName=TestA
    @HttpPost
    global static ResponseWrapper postwebService(){
        ResponseWrapper respWrap = new ResponseWrapper();
        String inbondjson = RestContext.request.requestBody.toString();
        String sysName = RestContext.request.params.get('SystemName');
        System.debug('sysName*****'+sysName);
        if(sysName == null){
            respWrap.responseMsg = 'Failure -->Paramter name should be SystemName, please modify URL e.g services/apexrest/SalesforceInboundRestAPI?SystemName=YourSystemName';
            respWrap.insertedRecordIds = null;
            respWrap.updatedRecordsIds = null;
            return respWrap;
        }
        //Build a map of attribute node name and a list of custom metadata for the node name
        List<Node_Name__mdt> woMetaDataList = [SELECT Id, System_Name__c,Node_Name__c, Attribute_Name__c, Field_Name__c,
                                               Salesforce_Object__c FROM Node_Name__mdt where System_Name__c =:sysName];
        system.debug('woMetaDataList:'+woMetaDataList);
        if(woMetaDataList == null || woMetaDataList.isEmpty()){
            respWrap.responseMsg = 'Failure -->System Name ' + sysName+ ' does not exist in database';
            respWrap.insertedRecordIds = null;
            respWrap.updatedRecordsIds = null;
            return respWrap;  
        }
        Map<String, Map<String,String>> metadataAttributeToFieldName;
        Map<String, List<String>> metaDataMap = new Map<String, List<String>>();
        Map<String,String> nodeNmToSfdcNmMap = new Map<String,String>();
        metadataAttributeToFieldName = new Map<String, Map<String, String>>();
        for(Node_Name__mdt mw : woMetaDataList){
            if(mw.Node_Name__c == null){
                system.debug('mw:'+mw);
                if(metaDataMap.containsKey(mw.Salesforce_Object__c)){
                    metaDataMap.get(mw.Salesforce_Object__c).add(mw.Attribute_Name__c);
                    metadataAttributeToFieldName.get(mw.Salesforce_Object__c).put(mw.Attribute_Name__c,mw.Field_Name__c);
                    system.debug('metaDataMapin:'+metaDataMap);
                }
                else{
                    system.debug('in else');
                    metaDataMap.put(mw.Salesforce_Object__c,new List<String>{mw.Attribute_Name__c});
                    metadataAttributeToFieldName.put(mw.Salesforce_Object__c, new  Map<String, String>{mw.Attribute_Name__c=>mw.Field_Name__c});
                    system.debug('metaDataMapinelse:'+metaDataMap);
                }    
            }
            else{
                nodeNmToSfdcNmMap.put(mw.Node_Name__c, mw.Salesforce_Object__c);
            }
        }
        system.debug('metaDataMap:'+metaDataMap);
        system.debug('metadataAttributeToFieldName:'+metadataAttributeToFieldName);
        system.debug('metaDataMap.keySet:'+metaDataMap.keySet());
        System.debug('nodeNmToSfdcNmMap****'+nodeNmToSfdcNmMap);
        
        try{
            Map<String,Map<String,String>> relatedIdMap = new Map<String,Map<String,String>>();
            List<Relationship_Metadata__mdt> relatedIdLst = [SELECT Id, MasterLabel, System_Name__c, RelatedId__c,Parent_Object_Name__c FROM Relationship_Metadata__mdt where System_Name__c =:sysName];
            if(relatedIdLst!=null && relatedIdLst.size()>0){
                for(Relationship_Metadata__mdt rec :relatedIdLst){
                    if(relatedIdMap.containskey(rec.Parent_Object_Name__c)){
                        relatedIdMap.get(rec.Parent_Object_Name__c).put(rec.MasterLabel,rec.RelatedId__c);    
                    }
                    else{
                        Map<String,String> childMap = new Map<String,String>();
                        childMap.put(rec.MasterLabel,rec.RelatedId__c);
                        relatedIdMap.put(rec.Parent_Object_Name__c,childMap);
                    }
                }
            } 
            Map<String, Object> mapJsonStr = (Map<String, Object>)JSON.deserializeUntyped(inbondjson);   
            system.debug('mapJsonStr:'+mapJsonStr);
            //get outer most node name & its value
            String objName = '';
            String externalNodeNm = '';
            for (String name : mapJsonStr.keySet())
            {
                if(nodeNmToSfdcNmMap!=null && nodeNmToSfdcNmMap.size()>0 && nodeNmToSfdcNmMap.containsKey(name)){
                    objName = nodeNmToSfdcNmMap.get(name);
                    externalNodeNm = name;
                }
            }
            //Replace Node and subnode value with SFDC Objects
            Map<String, Object> mapJson = parseMapJSON(inbondjson,nodeNmToSfdcNmMap, externalNodeNm, objName);
            //check the key present in incoming JSON with metadata map & created a map which is to be inserted
            List<Map<String,Object>> mapToInsert = new List<Map<String,Object>>();
            for (String key : metaDataMap.keySet())
            {   
                System.debug('key:'+key);             
                if(mapJson.containsKey(key))
                {
                    Object objvalue =  mapJson.get(key);
                    System.debug('objvalue:'+objvalue); 
                    String strValueJson = JSON.serialize(objvalue);
                    try{
                        List< Object> mapValue = (List<Object>) JSON.deserializeUntyped(strValueJson);
                        system.debug('mapValue===>'+mapValue);
                        for(Object objList : mapValue)
                        {
                            String str = JSON.serialize(objList);
                            Map<String,Object> mapObj = (  Map<String,Object>) JSOn.deserializeUntyped(str);
                            system.debug('mapObj ===>'+mapObj );
                            Map<String, Object> tempMap = new Map<String, Object>();
                            for(String value : metaDataMap.get(key))
                            {       
                                system.debug('value====>'+value);
                                if (mapObj.containsKey(value))
                                {
                                    system.debug('Insided If====>'+value);
                                    tempMap.put(value ,mapObj.get(value));
                                }
                                
                            } 
                            mapToInsert.add(tempMap);
                        }
                    }
                    catch(Exception e)
                    {
                        throw e;
                    }
                }
            }
            system.debug('mapToInsert:'+mapToInsert);
            system.debug('objName:'+objName);
            //created a list of outer most node object & inserted it in db
            List<Sobject> listObject = new List<Sobject>();
            List<Sobject> listObjectToUpdate = new List<Sobject>();
            List<Sobject> childListObject = new List<Sobject>();
            //gets fields particular to sobject
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objName);
            system.debug('targetType:'+targetType);
            Map<String, Schema.sObjectField> targetFields = targetType.getDescribe().fields.getMap();
            system.debug('targetFields=>'+targetFields);
            Map<string,string>fieldMap=new Map<string,string>();
            for (String fieldName: targetFields.keySet()) {
                string str=targetFields.get(fieldName).getDescribe().getLabel();
                fieldMap.put(str,fieldName);
            }
            system.debug(fieldMap);
            Map<String,List<Sobject>> ExternalIdChildMap = new  Map<String,List<Sobject>>();
            String externalId;
            Boolean ClosedWO;
            //storing the sobjects to update from this method call
            List<Map<String,Object>>mapToUpdate=updateorInsertSobject(mapToInsert,objName);
            for(Map<String,Object> mapInsert : mapToInsert)
            {
                //String exid = String.valueOf(mapInsert.get('External Id'));
                String exid = String.valueOf(mapInsert.get(System.Label.IF_External_ID_Label));
                system.debug('exid:'+exid);
                System.debug('mapInsert keyset=='+mapInsert.keyset());
                SObject newSobject = targetType.newSObject();
                
                for (String key : mapInsert.keySet())
                { 
                    System.debug('key=='+key);
                    Object value = mapInsert.get(key);
                    System.debug('value=='+value);
                    if(key == System.Label.IF_External_ID_Label){
                        externalId = String.valueOf(value);
                        system.debug('externalid:'+externalid);
                        exid=externalid;
                        system.debug('exid before:'+exid);
                        newSobject.put(fieldMap.get(key),externalId);
                    }
                    system.debug('exid after:'+exid);
                    IF(key == System.Label.IF_Closed_Wo){
                        ClosedWO = Boolean.valueOf(value);
                        newSobject.put(fieldMap.get(key),ClosedWO);  
                    }
                    System.debug('newSobject:'+newSobject);
                    if( value instanceof List<Object>){
                        system.debug('child value'+value);
                        //childListObject = new List<Sobject>();
                        string childObj = key;
                        system.debug('childObj'+childObj);
                        Schema.SObjectType childType = Schema.getGlobalDescribe().get(childObj);
                        Map<String, Schema.sObjectField> childFields = childType.getDescribe().fields.getMap();
                        List<Object> lstLineItems = (List<Object>)value;
                        system.debug('lstLineItems:'+lstLineItems);
                        for(Object obj : lstLineItems){
                            Map<String, Object> mapChldFields = (Map<String, Object>)obj;
                            SObject newChildSobject = childType.newSobject();
                            for(String strKey: mapChldFields.keySet()){
                                Object val = mapChldFields.get(strKey);
                                string sval = (string)val;
                                newChildSobject = assignValues(childFields,strKey,sval,newChildSobject,metadataAttributeToFieldName);
                            }
                            //childListObject.add(newChildSobject);
                            //system.debug('externalid::'+externalid);
                            if(ExternalIdChildMap.containsKey(exid)){
                                ExternalIdChildMap.get(exid).add(newChildSobject);    
                            }
                            else{
                                childListObject = new List<Sobject>();
                                childListObject.add(newChildSobject);
                                ExternalIdChildMap.put(exid,childListObject);
                                
                            }
                        }
                        // ExternalIdChildMap.put(exid,childListObject);
                        system.debug('ExternalIdChildMap:'+ExternalIdChildMap);
                    }
                    String svalue = String.valueof(value);
                    system.debug('svalue=>'+svalue);
                    System.debug('targetFields###########'+targetFields);
                    System.debug('Key###########'+Key);
                    System.debug('svalue###########'+svalue);
                    System.debug('newSobject###########'+newSobject);
                     System.debug('metadataAttributeToFieldName###########'+metadataAttributeToFieldName);
                    newSobject = assignValues(targetFields,Key,svalue,newSobject,metadataAttributeToFieldName);
                    system.debug('newSobject=>'+newSobject);
                }
                if(mapToUpdate !=null && mapToUpdate.contains(mapInsert))
                {    for(Map<String,Object> mapUpdate:mapToUpdate)
                {    if(mapUpdate.get(System.Label.IF_External_ID_Label) == mapInsert.get(System.Label.IF_External_ID_Label) )
                {
                    newSobject.put('Id',mapUpdate.get('Id'));
                    break;
                }
                }
                 listObjectToUpdate.add(newSobject);
                }
                else{
                    listObject.add(newSobject);
                }
                system.debug('listObject=>'+listObject);
                system.debug('listObjectToUpdate=>'+listObjectToUpdate);
            } 
            if(listObject!=null)
            {
                List<Database.SaveResult> insertResults = Database.insert(listObject);
                List<Id> listOfIds = new List<Id>();
                for (Database.SaveResult sr : insertResults) {
                    if (sr.isSuccess()) {
                        listOfIds.add(sr.getId());
                        System.debug('ID****'+sr.getId());
                    }
                    else{
                        System.debug('Error ****');   
                    }
                }
                if(listOfIds != null && listOfIds.size()>0){
                    respWrap.insertedRecordIds = listOfIds;
                    respWrap.responseMsg ='Success';
                }
            }
            if(listObjectToUpdate!=null)
            {
                List<Database.SaveResult> updateResults = Database.update(listObjectToUpdate); 
                List<Id> listOfIds = new List<Id>();
                for (Database.SaveResult sr : updateResults) {
                    if (sr.isSuccess()) {
                        listOfIds.add(sr.getId());
                        System.debug('ID****'+sr.getId());
                    }
                    else{
                        System.debug('Error ****');   
                    }
                }
                if(listOfIds != null && listOfIds.size()>0){
                    respWrap.updatedRecordsIds = listOfIds;
                    respWrap.responseMsg ='Success';
                }
            }
            string keySearch;
            List<Sobject>childToInsert=new List<Sobject>();
            Map<String, List<sObject>> sObjectNametoRecordMapping = new Map<String, List<sObject>>();
            
            listObject.addAll(listObjectToUpdate);
            
            for(sobject s:listObject){
                system.debug('listObject:'+listObject);
                object o= s.get(System.Label.IF_External_Id_API_Name);   
                system.debug('o:'+o);
                keySearch=String.valueof(o);
                System.debug('ExternalIdChildMap*******'+ExternalIdChildMap);
                list<sobject> childList=ExternalIdChildMap.get(keySearch);
                System.debug('childList*****'+childList);
                if(childList!=Null && childList.size()>0){
                    for(sobject s1:childList)
                    {    
                        System.debug('s1****'+s1);
                        String childObjname = String.valueOf(s1).split(':')[0];
                        System.debug('s1****'+childObjname);
                        System.debug('NMap********'+relatedIdMap);
                        Map<String,String> childObjMap = relatedIdMap.get(objName);
                        if(childObjMap!=null && childObjMap.containsKey(childObjname)){
                            String relationshipNm = childObjMap.get(childObjname); 
                            s1.put(relationshipNm,s.id);
                            childToInsert.add(s1);
                              if(sObjectNametoRecordMapping.ContainsKey(childObjname)){
                                sObjectNametoRecordMapping.get(childObjname).add(s1);
                            }
                            else {
                                sObjectNametoRecordMapping.put(childObjname, new List<sObject> {s1});
                                
                            }
                        }
                        
                    }
                }
            }
            system.debug('sObjectNametoRecordMapping====>'+sObjectNametoRecordMapping);
            //List<Database.SaveResult> res = Database.insert(childToInsert);
            if(sObjectNametoRecordMapping != NULL && sObjectNametoRecordMapping.Values().Size() > 0){
                dynamicUpsert(sObjectNametoRecordMapping);
            }
            system.debug('inserted child:'+childToInsert);
        }
        
        catch(Exception ex){
            respWrap.responseMsg ='Failure->'+ex;
            respWrap.insertedRecordIds = null;
            respWrap.updatedRecordsIds = null;
            throw ex;
        }
        return respWrap;
        
    }
    /* End */
    
    /**
    @MethodName : updateorInsertSobject
    @Param1     : Map with attribute name and Sobject 
    @Param2     : SObject API Name for parent
    @Description: Method to get list of Map to insert and update record seperately based on the External Id
    @Return     : Map with attribute name and Sobject with existing ids to be updated 
    **/
    public static  List<Map<String,Object>> updateorInsertSobject(List<Map<String,Object>>mapToInsertOrUpdate,String objName){
        
        List<Map<String,Object>>mapToUpdate=new List<Map<String,Object>>();
        Set<String>ExternalIDSet=new Set<String>();
        Map<String,Id>IdExternalIdMap=new Map<String,Id>();
        
        for(Map<String,Object> mapInsert : mapToInsertOrUpdate)
        {
            String exid = String.valueOf(mapInsert.get(System.Label.IF_External_ID_Label));
            ExternalIDSet.add(exid);
            
        }
        system.debug('ExternalIDSet:'+ExternalIDSet);
        //String queryStr='select Id,External_Id__c  from ' + objName + ' where External_Id__c in :ExternalIDSet';
        String queryStr='select Id,'+System.Label.IF_External_Id_API_Name+'  from ' + objName + ' where '+System.Label.IF_External_Id_API_Name+' in :ExternalIDSet';
        system.debug('queryStr:'+queryStr);
        List<Sobject> SobjectList=Database.query(queryStr);
        if(SobjectList!=null )
        {
            for(SObject sObj:SobjectList)
            {
                //existingExtIDS.add((String.valueOf(sObj.get('External_Id__c'))));
                IdExternalIdMap.put(String.valueOf(sObj.get(System.Label.IF_External_Id_API_Name)),sObj.Id);
            }
        }
        for(Map<String,Object> mapInsert : mapToInsertOrUpdate)
        {
            if(IdExternalIdMap.containsKey(String.valueOf(mapInsert.get(System.Label.IF_External_ID_Label))))
            {
                mapInsert.put('Id',IdExternalIdMap.get(String.valueOf(mapInsert.get(System.Label.IF_External_ID_Label))));
                mapToUpdate.add(mapInsert);
            }
        }
        system.debug('mapToUpdate:'+mapToUpdate);
        if(mapToUpdate!=null)
            return mapToUpdate;
        else
            return null;
    }
    /* End */
    
    /**
    @MethodName : assignValues
    @Param1     : Map with field label and Schema.sObjectField
    @Param2     : External attribute name
    @Param3     : Value provided for external attribute in request
    @Param4     : Sobject with all fields and values from request
    @Param5     : Map of Salesforce Object Name to Map of external attribute name to salesforce field Api name
    @Description: Method to convert and map field values to appropriate datatype
    @Return     : return Sobject 
    **/
    public static Sobject assignValues(Map<String, Schema.sObjectField>fieldMap,string attributeKey,string value,sobject newSObject, Map<String, Map<String,String>> attributeToFieldAPIMap)
    {    
        system.debug('check key=>'+attributeKey);
        system.debug('check object=>'+newSObject);
        String key;
        String ObjectName = String.ValueOf(newSObject).substringBefore(':');
        Map<String, String> fieldAPINameMapByObject = attributeToFieldAPIMap.get(ObjectName);
        if(fieldAPINameMapByObject != Null && fieldAPINameMapByObject.get(attributeKey) != Null){
            key = fieldAPINameMapByObject.get(attributeKey);
            system.debug('fieldMap.get(key)'+fieldMap.get(key));
        }
        
        if(key != Null && fieldMap.get(key)!=null){
            Schema.DisplayType ValueType = fieldMap.get(key).getDescribe().getType();
            system.debug('ValueType=>'+ValueType);
            if(ValueType == Schema.DisplayType.DATETIME){
                newSObject.put(key, DateTime.valueOf(value));  
            }
            else if(ValueType == Schema.DisplayType.DATE){
                newSObject.put(key, Date.valueOf(value));  
            }
            else if(ValueType == Schema.DisplayType.EMAIL || ValueType == Schema.DisplayType.URL || ValueType == Schema.DisplayType.PHONE){
                newSObject.put(key,value);  
            }
            else if(ValueType == Schema.DisplayType.PERCENT){
                newSObject.put(key, Integer.valueOf(value));     
            }
            else if(ValueType == Schema.DisplayType.TEXTAREA){
                newSObject.put(key, value);        
            }
            else if(ValueType == Schema.DisplayType.TIME){
                List<String> lst = value.split(':');
                newSObject.put(key,Time.newInstance(Integer.valueOf(lst[0]), Integer.valueOf(lst[1]), 0, 0));  
            }
            else if(ValueType == Schema.DisplayType.PICKLIST){
                newSObject.put(key, value); 
            }
            else if(ValueType == Schema.DisplayType.STRING){
                newSObject.put(key, value); 
            }
            else if(ValueType == Schema.DisplayType.Boolean){
                newSObject.put(key, Boolean.valueOf(value)); 
            }
            else if(ValueType == Schema.DisplayType.Currency){
                newSObject.put(key, Decimal.valueOf(value)); 
            }
            else if(ValueType == Schema.DisplayType.LOCATION){
                newSObject.put(key, double.valueOf(value));  
            }
            else if(ValueType == Schema.DisplayType.Double){
                newSObject.put(key, Double.valueOf(value)); 
            }
            else if(ValueType == Schema.DisplayType.Integer){
                newSObject.put(key, Integer.valueOf(value)); 
            }
            else if(ValueType == Schema.DisplayType.REFERENCE){
                
            }
            else{
            	 newSObject.put(key, value);     
            }
               
        }
        return newSObject;
    }
    /* End */
    
     /**
    @MethodName : parseMapJSON
    @Param1     : Request Json in string format
    @Param2     : Map with external node name and SFDC object API name from metadata
    @Param3     : External node name for parent Object
    @Param4     : SObject API Name for parent
    @Description: Method to replace node and subnode external name with SFDC object API name .
    @Return     : Return Map with requested JSON after parsing with SFDC Object API name format in Map format
    **/
    public static Map<String, Object> parseMapJSON(String inbondjson, Map<String,String> nodeNmToSfdcNmMap, String externalNodeNm, String objName){
        Map<String, Object> mapJson1 = (Map<String, Object>)JSON.deserializeUntyped(inbondjson);   
        Map<String, Object> mapJson = New Map<String, Object>();   
        system.debug('mapJson1:'+mapJson1);
        
        Object objvalue =  mapJson1.get(externalNodeNm);
        String strValueJson = JSON.serialize(objvalue);
        try{
            List< Object> mapValue = (List<Object>) JSON.deserializeUntyped(strValueJson);
            List< Object> mapValueNew = new List<Object>();
            system.debug('mapValue===>'+mapValue);
            for(Object objList : mapValue)
            {
                Map<String,Object> mapObjnew = new Map<String,Object>();
                String str = JSON.serialize(objList);
                Map<String,Object> mapObj = ( Map<String,Object>) JSOn.deserializeUntyped(str);
                system.debug('mapObj ===>'+mapObj);
                for(String s : mapObj.keySet()){
                    if(mapObj.get(s) instanceof List<Object>){
                        mapObjnew.put(nodeNmToSfdcNmMap.get(s),mapObj.get(s));
                    }
                    else{
                        mapObjnew.put(s,mapObj.get(s));
                    }
                }
                System.debug('mapObjnew----------'+mapObjnew);
                mapValueNew.add(mapObjnew);
            }
            mapJson.put(objName,mapValueNew);
            System.debug('mapJson*******'+JSON.serialize(mapJson));
        }
        catch(Exception e)
        {
            throw e;
        } 
        return mapJson;
    }
    /* End */
    
    
     /**
    @MethodName : dynamicUpsert
    @Param1   : Map of Child Object Name to List of Child records
    @Description: Method to dynamically Upsert the child records accepted in the request.
    @Return     : Void
    **/
    
    public static void dynamicUpsert( Map<String, List<sObject>> objectDetails)
    {
        List<sObject> objectsTobeUpserted = new List<sObject>();
        if (objectDetails != null && objectDetails.Values().size() > 0)
        {
            for(String key : objectDetails.keySet()){
                SObjectType sObjType = ((SObject) Type.forName(key).newInstance()).getSObjectType();
                String listType = 'List<' + sObjType  + '>';
                List<SObject> castRecords = (List<SObject>)Type.forName(listType).newInstance();
                castRecords.addAll(objectDetails.get(key));
                Schema.SObjectField extId = Schema.getGlobalDescribe().get(key).getDescribe().fields.getMap().get(System.Label.IF_External_Id_API_Name);
                system.debug('extId====>'+ extId);
                if(extId != NULL)
                   Database.Upsert(castRecords, extId);
                
            }
        }
    }
      /* End */
    
}