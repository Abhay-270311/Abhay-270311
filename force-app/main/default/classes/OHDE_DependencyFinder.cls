/**
* This Contains all common functions
* Created by - Abhay
* Created Date - 01-Oct-21
* The Union of deleteMetaCompList(customField, List of fields having one standare field name for selected object) and getToolingCompDependency(field defination Id)
* For getting field defination id from getFieldDefIdMap()
* IMP**** Does not allow dependency for standard field
*/
public with sharing class OHDE_DependencyFinder {
    public static OHDE_MetadataService.MetadataWebSer mtObj;
    public static String[] errMsgDeleteMetadata;
    public static List<FieldDetails> deleteApiData;
    public static List<FieldDetails> metadataCompDepenData;
    public static List<FieldDetails> finalUnionResult;
    public static Map<String, String> fieldApiDefId;
    public static Map<String, String> fieldApiDefIdRevId;
    // Get the Metadata API Object for making calls
    public static void getObj(){
        OHDE_MetadataService.AllOrNoneHeader_element alOrNone = new OHDE_MetadataService.AllOrNoneHeader_element();
        alOrNone.allOrNone = true;
        OHDE_MetadataService.SessionHeader_element sHeader = new OHDE_MetadataService.SessionHeader_element();
        sHeader.sessionId = getSessionIdFromVFPage(Page.OHDE_SessionHandler);
        mtObj = new OHDE_MetadataService.MetadataWebSer();
        mtObj.SessionHeader = sHeader;
        mtObj.AllOrNoneHeader = alOrNone;
        mtObj.timeout_x = 20000;
    }
    
    // Contains the Field dependecy details
    public class FieldDetails{
        @AuraEnabled public String fieldName;
        @AuraEnabled public List<OHDE_DependencyFinder.FieldErrors> fielderrors;
        public FieldDetails(String fnm, List<OHDE_DependencyFinder.FieldErrors> errMsgs){
            this.fieldName = fnm;
            this.fielderrors = errMsgs;
        }
    }
    
    public class FieldErrors{
        @AuraEnabled public String errType;
        @AuraEnabled public List<String> errmessages;
        public FieldErrors(String erTp, List<String> errMsgs){
            this.errType = erTp;
            this.errmessages = errMsgs;
        }
    }
    
    // NOT TO BE USED NOW INSTEAD USE deleteMetaCompList
    public static Map<String,Map<String,List<String>>> deleteMetadataComp(String componentType, String[] compData,String fname){
        return new Map<String,Map<String,List<String>>>();
    }
    
    //This will give the component dependency using Metadata API to delete component
    //Pass field Name to ensure the field is not actually deleted
    // param1 : componentType - CustomField
    // param2 : compData - Opportunity.TrackingNumber__c, Opportunity.StageName etc // no need to pass standard fields as those can not be deleted
    // param3 : Object Name - as of now you can pass one or multiple object custom fields if multiple object then we need to modify the fName to contain objectName.fieldName
    @AuraEnabled(Cacheable=true)
    public static List<FieldDetails> deleteMetaCompList(String componentType, String[] compData, String objectName){
        OHDE_MetadataService.DeleteResult[] results;
        if(mtObj == null){
            getObj();
            // To avoid field delete add Name field in the compData list
            compData.add(objectName + '.Name');
            results = mtObj.deleteMetadata( componentType, compData);
        } 
		
        // Variables declaration
        Map<String,List<String>> innerErrorMap 				= new Map<String,List<String>>(); 
        List<OHDE_DependencyFinder.FieldErrors> fielderrors = new List<OHDE_DependencyFinder.FieldErrors>();
        Map<String,Map<String,List<String>>> errorMap 		= new Map<String,Map<String,List<String>>>();
        List<FieldDetails> fDetails 						= new List<FieldDetails>();
        String fname										= '';
        
        for(OHDE_MetadataService.DeleteResult dR:results){
            fname = dR.fullName.split('\\.')[1]; // Get the Field Name
            errMsgDeleteMetadata = new List<String>();
            for(OHDE_MetadataService.Error err: dR.errors){
				// TO Do : Take the replace strings from MetadataType
                String errMsg = err.message.replace('This custom field is referenced elsewhere in salesforce.com. :', ''); 
                System.debug('--- '+errMsg);
                errMsgDeleteMetadata = errMsg.split('\\.');
                innerErrorMap 	= new Map<String,List<String>>();
                for(String str : errMsgDeleteMetadata){
                    String [] strArr = str.split('-');
                    if(strArr.size() > 1) {
                        String strIndex0	= strArr[0].trim().replace(': Open the process in the ','');
                        String strIndex1	= strArr[1].trim();
                        if(innerErrorMap.containsKey(strIndex0)){
                            List<String> strChkDup = innerErrorMap.get(strIndex0);
                            Boolean flagChk = true;
                            for(String strVal:strChkDup){
                                if(strIndex1.endsWithIgnoreCase(strVal)){
                                    flagChk = false;
                                }
                            }
                            if(flagChk) {
                                List<String> errorLst = new List<String>();
                                errorLst = innerErrorMap.get(strIndex0);
                                errorLst.add(strIndex1);
                                innerErrorMap.get(strIndex0).add(strIndex1);
                            }
                        }else {
                            List<String> errorLst = new List<String>();
                            errorLst.add(strIndex1);
                            innerErrorMap.put(strIndex0, errorLst);
                        }
                    }
                }
                errorMap.put(fname,innerErrorMap);
            } 
        }
        // Get the MetadataComponentDependency data as well
        fieldApiDefId = getFieldDefIdMap(objectName);
        system.debug('fieldApiDefId ' + fieldApiDefId);
        List<String> fieldDefId = new List<String>();
        system.debug('compData ' + compData);
        String compFieldName = '';
        for(String strApiName: compData){
            compFieldName = strApiName.split('\\.')[1];
            if(compFieldName == 'Name'){
                continue;
            }
            fieldDefId.add(fieldApiDefId.get(compFieldName));
        }
        system.debug(' fieldDefId ' + fieldDefId);
        // Call method to find the additional dependency using tooling api
        Map<String,Map<String,List<String>>> comToolingMap = getToolingCompDependency(fieldDefId, '');
        system.debug(' metadataCompDepenData ' + metadataCompDepenData);
        // Do comparison of delete api and tooling api and union the result
        // String[] strArr = new List<String>{'abhay', 'arun', 'ajay'};
    	// String target = 'abhay';
    	// system.debug((new Set<String>(strArr)).contains(target));
        
        for(String fname1: errorMap.keySet()){
            if(fname1 == 'Name'){
                continue;
            }
            fielderrors 	= new List<OHDE_DependencyFinder.FieldErrors>();
            for(String fType: errorMap.get(fname1).keySet()){
                fielderrors.add(new OHDE_DependencyFinder.FieldErrors(fType,errorMap.get(fname1).get(fType) ));
            }
            fDetails.add(new FieldDetails(fname1, fielderrors));
        }
        deleteApiData = fDetails;
        
        // TODO: combine the Delete api and Tooling api result below 
        // metadataCompDepenData + deleteApiData
        finalUnionResult = new List<FieldDetails>();
        finalUnionResult = combinedResultUnion(errorMap,comToolingMap);
        system.debug(' deleteApiData ' + finalUnionResult);
        return finalUnionResult;
    }
    
    public static List<FieldDetails> combinedResultUnion(Map<String,Map<String,List<String>>> fd1, Map<String,Map<String,List<String>>> fd2){
        // Variables
        Map<String,Map<String,List<String>>> unionResult 	= new Map<String,Map<String,List<String>>> ();
        Map<String,List<String>> innerErrorMap 				= new Map<String,List<String>>();
        List<String> errorLst 								= new List<String>();
        String fType2 										= '';
        Set<String> matchedFields 							= new Set<string>();
		Set<String> matchedFieldTypes 						= new Set<string>();
        
        //set<String> found matching and mis match keys to complete the union
        for(String fname1: fd1.keySet()){
            if(fname1 == 'Name'){
                continue;
            }
            if(fd2.containsKey(fname1)){
                matchedFields.add(fname1);
                System.debug('inside ' + fname1);
                system.debug('fd1 ftype key set ' + fd1.get(fname1).keySet());
                system.debug('fd2 ftype key set ' + fd2.get(fname1).keySet());
                innerErrorMap 	= new Map<String,List<String>>();
                for(String fType: fd1.get(fname1).keySet()){
                    
                    errorLst = new List<String>();
                    fType2 			= fType;
                    switch on fType {
                        when 'Apex Class' {		
                            fType2 = 'ApexClass';
                        }	
                        when 'Apex Trigger' {		
                            fType2 = 'ApexTrigger';
                        }
                        when else {	
                            // code block 4
                        }
                    }
                    if((fd2.get(fname1)).keySet().contains(fType2)){
                        matchedFieldTypes.add(fType2);
                        System.debug('inside fType ' + fType);
                        System.debug(fd1.get(fname1).get(fType));
                        System.debug(fd2.get(fname1).get(fType2));
                        List<String> ls1 = new List<String>();
                        List<String> ls2 = new List<String>();
                        ls1.addAll(fd1.get(fname1).get(fType));
                        ls2.addAll(fd2.get(fname1).get(fType2));
                        ls1.addAll(ls2);
                        // Combine the lists to get unique list
                        Set<String> setStr1 = new Set<String>(ls1);
						errorLst = new List<String>(setStr1);
                    } else {
                        errorLst = fd1.get(fname1).get(fType);
                    }
                    innerErrorMap.put(fType2, errorLst);
            	}
                unionResult.put(fname1,innerErrorMap);
            } else {
                unionResult.put(fname1,fd1.get(fname1));
            }
            
        }
        
        //Adding missing inner field types details
        Boolean flag = false;
        for(String fname2: fd2.keySet()){
            flag = false;
            if(matchedFields.contains(fname2)){
                
                innerErrorMap 	= new Map<String,List<String>>();
                for(String fTypeIn: fd2.get(fname2).keySet()){
                    errorLst = new List<String>();
                    if(!matchedFieldTypes.contains(fTypeIn)){
                       errorLst = fd2.get(fname2).get(fTypeIn);
                    }else{
                        continue;
                    }
                    innerErrorMap = unionResult.get(fname2);
                    innerErrorMap.put(fTypeIn, errorLst);
            	}
                unionResult.put(fname2,innerErrorMap);
            } 
            
        }
        system.debug('Final Array ---> ' + unionResult);
        
        //creating wrapper object for union result
        List<OHDE_DependencyFinder.FieldErrors> fielderrors = new List<OHDE_DependencyFinder.FieldErrors>();
        List<FieldDetails> fDetails 						= new List<FieldDetails>();
        for(String fname1: unionResult.keySet()){
            fielderrors 	= new List<OHDE_DependencyFinder.FieldErrors>();
            for(String fType: unionResult.get(fname1).keySet()){
                fielderrors.add(new OHDE_DependencyFinder.FieldErrors(fType,unionResult.get(fname1).get(fType) ));
            }
            fDetails.add(new FieldDetails(fname1, fielderrors));
        }
        // Get the additional inforamtion from fd2
        system.debug('Final Wrapper Array ---> ' + fDetails);
        return fDetails;
    }
    /*  public static boolean deleteMetadataCall(String objectName, String cmpType){
logDeleteActionList = new List<Component_Delete_Detail__c>();
Boolean flag = true;
Integer cnter;
Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(ObjectName).getDescribe().Fields.getMap();
system.debug(' fMap.values() ' + fMap.values());
list<string> selectFields = new list<string>();
if (fMap != null){
for (Schema.SObjectField ft : fMap.values()){

selectFields.add(objectName + '.' + String.valueOf(ft));
}

deleteMetadataComp(cmpType, selectFields);
}


return flag;
}*/
    //Get the session Id with the help of VF page
    public static String getSessionIdFromVFPage(PageReference visualforcePage){                       
        String content = visualforcePage.getContent().toString();
        Integer startSess = content.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
            endSess = content.indexOf('End_Of_Session_Id');
        return content.substring(startSess, endSess);
    }
    
    // Get the field dependency from MetadataComponentDependency 
    // param fieldId from getFieldDefIdMap
    @AuraEnabled(cacheable=true)
    public static Map<String,Map<String,List<String>>> getToolingCompDependency(List<String> fieldIds, String fieldApiName){
        //TODO: Pass field names along with type value
        //     
        system.debug(fieldIds);
        List<OHDE_DependencyFinder.FieldErrors> fielderrors = new List<OHDE_DependencyFinder.FieldErrors>();
        List<FieldDetails> fDetails 						= new List<FieldDetails>();
        //System.debug('&&&& ' + strSplit);

        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + getSessionIdFromVFPage(Page.OHDE_SessionHandler)); //Get user Session ID
        req.setHeader('Content-Type', 'application/json');
        String sfDomainUrl = URL.getSalesforceBaseUrl().toExternalForm();
        String query = 'SELECT MetadataComponentName, MetadataComponentType,RefMetadataComponentId,RefMetadataComponentName FROM MetadataComponentDependency WHERE RefMetadataComponentId IN (\'' + String.join(fieldIds,'\',\'') + '\') order by MetadataComponentName ';
        System.debug('query====> '+ query);
        query = query.replace(' ', '+');
        //TODO - Get this from Metadata
        req.setEndpoint(sfDomainUrl + '/services/data/v52.0/tooling/query/?q=' + query);
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse response = h.send(req);
        String resBdy = response.getBody();
        System.debug('Response====> '+ resBdy );
        System.debug('fieldApiDefIdRevId -> '+ fieldApiDefIdRevId);
        Map<String,List<String>> innerErrorMap = new Map<String,List<String>>();      
        Map<String,Map<String,List<String>>> errorMap = new Map<String,Map<String,List<String>>>();  
        try{
            Map<String,Object> lst_JsonParse = (Map<String,Object>)Json.deserializeUntyped(resBdy);
            List<Object> cObjList = (List<Object>) lst_JsonParse.get('records');
            for(Object strObj:cObjList){
                Map<String,Object> lst = (Map<String,Object>)strObj;
                String nodeValue 	= (String)lst.get('MetadataComponentName');
                String node 		= (String)lst.get('MetadataComponentType');
                fieldApiName 		= (String)lst.get('RefMetadataComponentName');
                String refId		= (String)lst.get('RefMetadataComponentId'); 
                system.debug(' refId ' + refId);
                innerErrorMap = new Map<String,List<String>>();
                if(errorMap.containsKey(fieldApiDefIdRevId.get(refId.left(15)))){
                    innerErrorMap = errorMap.get(fieldApiDefIdRevId.get(refId.left(15)));
                    if(innerErrorMap.containsKey(node)){
                        innerErrorMap.get(node).add(nodeValue);
                    } else {
                        List<String> errorLst = new List<String>();
                        errorLst.add(nodeValue);
                        innerErrorMap.put(node,errorLst);
                    }
                    errorMap.put(fieldApiDefIdRevId.get(refId.left(15)), innerErrorMap); 
                    
                } else {
                    List<String> errorLst = new List<String>();
                    errorLst.add(nodeValue);
                    innerErrorMap.put(node,errorLst);
                    errorMap.put(fieldApiDefIdRevId.get(refId.left(15)), innerErrorMap); 
                }
                // Since ref Id is 18 chars long take only first 15 chars to match the key
                //errorMap.put(fieldApiDefIdRevId.get(refId.left(15)), innerErrorMap);   
            }
            
            
        }  catch(Exception e){
            //errorMap = deleteMetadataComp('CustomField', new List<String>{strSplit[2]+'.'+strSplit[1],strSplit[2]+'.Name'},strSplit[1]); 
        }
        /* List<soBject> sObjList=getFieldDataAnalysisReport(strSplit[2],strSplit[1]);

for(Sobject sObj:sObjList){
System.debug(sObj);    
}*/
        for(String fname1: errorMap.keySet()){
            fielderrors 	= new List<OHDE_DependencyFinder.FieldErrors>();
            for(String fType: errorMap.get(fname1).keySet()){
                fielderrors.add(new OHDE_DependencyFinder.FieldErrors(fType,errorMap.get(fname1).get(fType) ));
                system.debug('fname1 ' + fname1 + ' fType' + fType + ' Map' + errorMap.get(fname1).get(fType) );
            }
            fDetails.add(new FieldDetails(fname1, fielderrors));
        }
        metadataCompDepenData = fDetails;
        return errorMap;
        
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> getSobjectList()
    {
        List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();   
        List<Map<String,String>> lst=new List<Map<String,String>>();
        
        
        List<OHDE_MapWrapper> myList = new OHDE_MapWrapper[]{};
            
        for(Schema.SObjectType f : gd) {
            Map<String,String> options = new Map<String,String>();
            options.put('value',f.getDescribe().getName());
            options.put('label',f.getDescribe().getLabel());
            
            myList.add(new OHDE_MapWrapper(options));           
        }     
        myList.sort();
        
        for(OHDE_MapWrapper mw : myList) {
            Map<String,String> options = new Map<String,String>();
            options.put('value',mw.record.get('value'));
            options.put('label',mw.record.get('label'));
            
            lst.add(options);           
        }
        return lst;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> getFieldName(String objName)
    {
        List<Map<String,String>> lst = new List<Map<String,String>>();
        
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + getSessionIdFromVFPage(Page.OHDE_SessionHandler)); //Get user Session ID
        req.setHeader('Content-Type', 'application/json');
        String sfDomainUrl = URL.getSalesforceBaseUrl().toExternalForm();
        String query = 'SELECT QualifiedApiName, DurableId, Label from FieldDefinition where EntityDefinition.QualifiedApiName= \''+objName+'\' order by Label';
        query=query.replace(' ', '+');
        system.debug( ' SFdomainUrl ' + sfDomainUrl);
        system.debug( ' query ' + query);
        req.setEndpoint(sfDomainUrl + '/services/data/v52.0/tooling/query/?q='+query);
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse response = h.send(req);
        String resBdy = response.getBody();
        
        Map<String,Object> lst_JsonParse = (Map<String,Object>)Json.deserializeUntyped(resBdy);
        List<Object> cObjList=(List<Object>) lst_JsonParse.get('records');
        for(Object objField:cObjList) {
            
            Map<String,Object> mapField=(Map<String,Object>)objField;
            
            String lastThreeCh=(String)mapField.get('QualifiedApiName'); 
            if(lastThreeCh.right(3)=='__c'){
                Map<String,String> fieldMap=new map<String,String>();
                List<String> splitStr=String.valueOf(mapField.get('DurableId')).split('\\.');  
                
                fieldMap.put('value',splitStr[1]+'#'+(String)mapField.get('QualifiedApiName') + '#' + objName);
                fieldMap.put('label',(String)mapField.get('Label'));                
                lst.add(fieldMap); 
            }
        }               
        return lst;             
    }
    
    // This will give the map of field api name and field defination id
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getFieldDefIdMap(String objName)
    {
        // Map with field defination API Name - Id
        Map<String,String> fieldMap = new Map<String,String>();
        fieldApiDefIdRevId = new Map<String,String>();
        try {
            HttpRequest req = new HttpRequest();
            req.setHeader('Authorization', 'Bearer ' + getSessionIdFromVFPage(Page.OHDE_SessionHandler)); //Get user Session ID
            req.setHeader('Content-Type', 'application/json');
            String sfDomainUrl = URL.getSalesforceBaseUrl().toExternalForm();
            String query = 'SELECT QualifiedApiName, DurableId, Label FROM FieldDefinition WHERE EntityDefinition.QualifiedApiName= \'' + objName + '\' order by Label';
            query = query.replace(' ', '+');
            req.setEndpoint(sfDomainUrl + '/services/data/v52.0/tooling/query/?q=' + query);
            req.setMethod('GET');
            Http h = new Http();
            HttpResponse response = h.send(req);
            String resBdy = response.getBody();
            system.debug(resBdy);
            Map<String,Object> lst_JsonParse = (Map<String,Object>)Json.deserializeUntyped(resBdy);
            List<Object> cObjList = (List<Object>) lst_JsonParse.get('records');
            // TODO use apex wrapper class to parse response
            // Sample Response {"size":54,"totalSize":54,"done":true,"queryLocator":null,"entityTypeName":"FieldDefinition","records":[{"attributes":
            // {"type":"FieldDefinition","url":"/services/data/v52.0/tooling/sobjects/FieldDefinition/Opportunity.Account"},
            // "QualifiedApiName":"AccountId","DurableId":"Opportunity.Account","Label":"Account Name"}]}
            for(Object objField:cObjList) {
                Map<String,Object> mapField = (Map<String,Object>)objField;
                String lastThreeCh = (String)mapField.get('QualifiedApiName'); 
                if(lastThreeCh.right(3) == '__c'){
                    List<String> splitStr		= String.valueOf(mapField.get('DurableId')).split('\\.');  
                    fieldMap.put( (String) mapField.get('QualifiedApiName'), splitStr[1]); //((String) mapField.get('QualifiedApiName')).toLowercase()
                    fieldApiDefIdRevId.put(splitStr[1], (String) mapField.get('QualifiedApiName'));
                }
            }
        } catch (Exception e) {
            //TODO - handle exception
        }
        system.debug(fieldMap);
        return fieldMap;             
    }
    
    /*  @AuraEnabled
public static Map<String,List<String>> deleteSObjectField(String fieldId){             
Map<String,List<String>> errorMap=new map<String,List<String>>();
errorMap=getTheDependency(fieldId);
return errorMap;       
}*/
    
    @AuraEnabled
    public static List<sObject> getFieldDataAnalysisReport(String sObj,String fieldName){  
        String [] strSplit=fieldName.split('#');
        String dyQuery = 'SELECT CALENDAR_YEAR(CreatedDate), count(id) FROM ' + sObj + ' WHERE ' + strSplit[0] + '!= null  GROUP BY CALENDAR_YEAR(CreatedDate) ORDER BY CALENDAR_YEAR(CreatedDate)';               
        return Database.query(dyQuery);       
    } 
}