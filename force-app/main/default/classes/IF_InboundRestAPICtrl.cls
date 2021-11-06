/*
** ____________________________________________________________________________________________
** Worked By:       Komal Deshmukh, Archana Pawar, Arti Fogla
** Created Date:    19/07/2019
** ============================================================================================
** Description: Inbound Request setup Lightning Component controller(Component Name:IF_InboundRestAPI)
** ____________________________________________________________________________________________
*/
public class IF_InboundRestAPICtrl{
    /* SOjectWrapper - Start */
    public class SOjectWrapper {
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public String value {get;set;}
    }
    /* SOjectWrapper - End */
    
    /* FieldWrapper - Start */
    public class FieldWrapper {
        @AuraEnabled
        public String fieldAPI {get;set;}
        @AuraEnabled
        public String attributeValue {get;set;}
    }
    /* FieldWrapper - End */
    
    /**
@MethodName : getsObjects
@Description: Method to get list of all sObject in your organization
@Return     : List of SOjectWrapper with label and value
**/
    @AuraEnabled   
    public Static List<SOjectWrapper> getsObjects() {
        List<SOjectWrapper> lstsObjectWrapperWithManagedPackageObj = new List<SOjectWrapper>();
        List<SOjectWrapper> lstsObjectWrapperWithoutManagedPackageObj = new List<SOjectWrapper>();
        //Returns a map of all sObject names (keys) to sObject tokens (values) for the standard and custom objects defined in your organization.
        Map<String, Schema.SObjectType> mapsObjects = Schema.getGlobalDescribe();
        List<String> lstsObjects = new List<String>(mapsObjects.keySet());
        lstsObjects.sort();
        Pattern regEx = Pattern.compile('^\\w*?__\\B\\w*__'); 
        for(String sObjName : lstsObjects) {
            Schema.DescribeSObjectResult sObjResult = mapsObjects.get(sObjName).getDescribe();
            SOjectWrapper objWrapper = new SOjectWrapper();
            objWrapper.label = sObjResult.getLabel();
            objWrapper.value = sObjResult.getName();
            if(regEx.matcher(sObjResult.getName()).find() == true){
                lstsObjectWrapperWithManagedPackageObj.add(objWrapper);
            }
            else{
                lstsObjectWrapperWithManagedPackageObj.add(objWrapper);
                lstsObjectWrapperWithoutManagedPackageObj.add(objWrapper);
            }
        }
        system.debug('===lstsObjectWrapperWithManagedPackageObj==='+lstsObjectWrapperWithManagedPackageObj);
        system.debug('===lstsObjectWrapperWithoutManagedPackageObj==='+lstsObjectWrapperWithoutManagedPackageObj);
        
        if(System.Label.IF_Display_Managed_Pkg_Objects.contains('true'))
            return lstsObjectWrapperWithManagedPackageObj;
        else
            return lstsObjectWrapperWithoutManagedPackageObj;
    }
    /* End */
    /**
@MethodName : getRelatedsObjects
@Param1     : sObject API Name
@Description: Method to get list of all child object names related to a sObject
@Return     : List of SOjectWrapper with label and value
**/
    @AuraEnabled
    public static List<SOjectWrapper> getRelatedsObjects(String sObjectAPI) {
        List<SOjectWrapper> lstsObjectWrapper = new List<SOjectWrapper>();
        Map<String, Schema.SObjectType> mapsObjects = Schema.getGlobalDescribe();
        Schema.DescribeSObjectResult objDescribe = mapsObjects.get(sObjectAPI).getDescribe();
        List<Schema.ChildRelationship> lstChildRelationship = objDescribe.getChildRelationships();
        
        SOjectWrapper objWrapper = new SOjectWrapper();
        objWrapper.label = objDescribe.getLabel();
        objWrapper.value = objDescribe.getName() + '#' + objDescribe.getLabel();
        lstsObjectWrapper.add(objWrapper);
        
        for(Schema.ChildRelationship objCR : lstChildRelationship) {
            Schema.DescribeSObjectResult sObjResult = objCR.getChildSObject().getDescribe();
            if(objDescribe.getName() != sObjResult.getName()){
                objWrapper = new SOjectWrapper();
                objWrapper.label = sObjResult.getLabel() + ' ( ' + objCR.getField() + ' )';
                objWrapper.value = sObjResult.getName() + '#' + sObjResult.getLabel() + '#' + objCR.getField();
                lstsObjectWrapper.add(objWrapper);    
            }
        }
        return lstsObjectWrapper;
    }
    /* End */
    
    /**
@MethodName : getsObjectFields
@Param1     : sObject API Name
@Param2     : Parent metadata name to relate
@Param3     : System name
@Param4     : Connection type as New/Existing
@Description: Method to get all fields for a sobject
@Return     : List of FieldWrapper with field Api and attribute value
**/
    @AuraEnabled   
    public Static List<FieldWrapper> getsObjectFields(String sObjectAPI, String parentMetaDataId, String sysName,String connType) {
        system.debug('===sObjectAPI==='+sObjectAPI);
        List<FieldWrapper> lstFieldWrapper = new list <FieldWrapper>();    
        Schema.SObjectType sObj = Schema.getGlobalDescribe().get(sObjectAPI);
        Map<String, String> mapSFFieldToAttributeName = new Map<String, String>();
        Map<String, Boolean> mapSFFieldToIncluededInReq = new Map<String, Boolean>();
        if(String.isNotBlank(parentMetaDataId)) {
            for(Node_Name__mdt objNodeNm : [Select MasterLabel, System_Name__c, Attribute_Name__c,Not_include_in_Request__c,Node_Name__c,Field_Name__c, Salesforce_Object__c FROM Node_Name__mdt
                                            where Salesforce_Object__c =: sObjectAPI and Node_Name__c = null and System_Name__c =:sysName])
            {
                //Field Name :Saleforce Field Name and attribute Name is Name used in external System.
                mapSFFieldToAttributeName.put(objNodeNm.Field_Name__c, objNodeNm.Attribute_Name__c);
                mapSFFieldToIncluededInReq.put(objNodeNm.Field_Name__c, objNodeNm.Not_include_in_Request__c);
            }    
        }
        
        for(Schema.SObjectField field : sObj.getDescribe().fields.getMap().values()){
            if(field.getDescribe().getType() != Schema.DisplayType.REFERENCE){
                FieldWrapper objWrapper = new FieldWrapper();
                objWrapper.fieldAPI = field.getDescribe().getName();
                if(objWrapper.fieldAPI != System.Label.IF_External_Id_API_Name){
                    if(connType == 'Existing'){
                        if(mapSFFieldToAttributeName.containsKey(field.getDescribe().getName()) && !mapSFFieldToIncluededInReq.get(field.getDescribe().getName())) {
                            objWrapper.attributeValue = mapSFFieldToAttributeName.get(field.getDescribe().getName());
                        } else {
                            objWrapper.attributeValue = null;    
                        }    
                    }
                    else if(connType == 'New'){
                        objWrapper.attributeValue = null;      
                    }
                    lstFieldWrapper.add(objWrapper);     
                }
            }
        }
        List<FieldWrapper> lstFieldWrapperWithoutNull = new list <FieldWrapper>(); 
        List<FieldWrapper> lstFieldWrapperwithNull = new list <FieldWrapper>(); 
        List<FieldWrapper> finalLst = new list <FieldWrapper>();  
        for(FieldWrapper val : lstFieldWrapper){
            if(val.attributeValue!= null){
                lstFieldWrapperWithoutNull.add(val);
            }
            if(val.attributeValue == null){
                lstFieldWrapperwithNull.add(val);
            }
        }
        if(lstFieldWrapperWithoutNull!=null && lstFieldWrapperWithoutNull.size()>0){
            finalLst.addAll(lstFieldWrapperWithoutNull);    
        }
        if(lstFieldWrapperwithNull !=null && lstFieldWrapperwithNull.size()>0){
            finalLst.addAll(lstFieldWrapperwithNull);    
        }
        system.debug('===finalLst==='+finalLst);
        return finalLst;
    }
    /* End */
    
    /**
@MethodName : getMap
@Param1     : sObject API Name
@Param2     : System name
@Description: Method to get map for all fields from metadata where Node_Name__c is null
@Return     : Map with Salesforce Field name and external attribute name
**/
    public static Map<String, String> getMap(String sObjectAPI, String systemName){
        Map<String, String> mapSFFieldToAttributeName = new Map<String, String>();
        for(Node_Name__mdt objNodeNm : [Select MasterLabel, Attribute_Name__c,Node_Name__c,Field_Name__c, Salesforce_Object__c FROM Node_Name__mdt
                                        where Salesforce_Object__c =: sObjectAPI and Node_Name__c = null and System_Name__c =: systemName])
        {
            mapSFFieldToAttributeName.put(objNodeNm.Field_Name__c, objNodeNm.Attribute_Name__c);
        } 
        return mapSFFieldToAttributeName;
    }
    /* End */
    
    /**
@MethodName : saveMetaDataMappingsInfo
@Param1     : sObject API Name
@Param2     : sObject Label
@Param3     : childSObject API Name
@Param4     : childSObject Label
@Param5     : relationship Name (if parent child relationship selected)
@Param6     : List of Field wrapper with Attribute Value
@Param7     : External Parent node name
@Param8     : External Child node name
@Param9     : System name
@Description: Method to save mapping information in custom metadata types
@Return     : Success or failure msg
**/
    @AuraEnabled
    public static String saveMetaDataMappingsInfo(String sObjectAPI, String sObjectLabel,String childSObjectAPI, String childSObjectLabel, String relationshipName,List<FieldWrapper> lstFieldWrapper, String nodeNm, String subNodeNm, String sysName) { 
        try{
            system.debug('==sObjectAPI=='+sObjectAPI);
            system.debug('==sObjectLabel=='+sObjectLabel);
            system.debug('==childSObjectAPI=='+childSObjectAPI);
            system.debug('==childSObjectLabel=='+childSObjectLabel);
            system.debug('==lstFieldWrapper=='+lstFieldWrapper);
            system.debug('==nodeNm=='+nodeNm);
            if(subNodeNm != null){system.debug('==subNodeNm=='+subNodeNm);}
            if(sysName != null){system.debug('==sysName=='+sysName);}
            
            Map<String,String> existingMTDMap = getExistingMTDMap();
            Map<String,String> existingMTDMapForRelMdt = getExistingMTDMapForRelationMtd();
            system.debug('==existingMTDMap=='+existingMTDMap);
            String systemNameAbbreviation = getsObjectAbbreviation(sysName);
            String sObjectAbbreviation = getsObjectAbbreviation(childSObjectLabel);
            Metadata.DeployContainer objCMTDeployContainer = new Metadata.DeployContainer();
            Map<String, String> resultMap = getMap(childSObjectAPI,sysName);
            for(FieldWrapper objWrapper : lstFieldWrapper) {
                if(String.isNotBlank(objWrapper.attributeValue)) {
                    String fieldAPI = objWrapper.fieldAPI;
                    System.debug('fieldAPI********'+fieldAPI);
                    String cmDevloperName = systemNameAbbreviation + '_' + sObjectAbbreviation + '_' + getsObjectAbbreviation(objWrapper.fieldAPI);
                    cmDevloperName = getUniqueDeveloperName(cmDevloperName,childSObjectAPI,sysName,fieldAPI,existingMTDMap);
                    system.debug('cmDevloperName*********'+cmDevloperName);
                    Metadata.CustomMetadata objCMT =  new Metadata.CustomMetadata();
                    objCMT.FullName = System.Label.IF_Node_Metadata_API_Name + '.'+ cmDevloperName;
                    objCMT.Label = cmDevloperName;
                    // Add all the field values
                    objCMT.values.add(getMetaDataFieldMapping(System.Label.IF_Field_Name_MdtField, objWrapper.fieldAPI));
                    objCMT.values.add(getMetaDataFieldMapping(System.Label.IF_Salesforce_Object_MdtField, childSObjectAPI));
                    objCMT.values.add(getMetaDataFieldMapping(System.Label.IF_Attribute_Name_MdtField, objWrapper.attributeValue));
                    objCMT.values.add(getMetaDataFieldMapping(System.Label.IF_Not_include_in_Request_MdtField, false));
                    objCMT.values.add(getMetaDataFieldMapping(System.Label.IF_System_Name_MdtField, sysName)); 
                    system.debug('=====objWrapper======'+objWrapper);
                    objCMTDeployContainer.addMetadata(objCMT);
                }
                else{
                    if(resultMap!=null && resultMap.keySet().size()>0){
                        if(resultMap.containsKey(objWrapper.fieldAPI)){
                            String cmDevloperName = systemNameAbbreviation + '_' + sObjectAbbreviation + '_' + getsObjectAbbreviation(objWrapper.fieldAPI);
                            cmDevloperName = getUniqueDeveloperName(cmDevloperName,childSObjectAPI,sysName,objWrapper.fieldAPI,existingMTDMap);
                            Metadata.CustomMetadata objCMT =  new Metadata.CustomMetadata();
                            objCMT.FullName = System.Label.IF_Node_Metadata_API_Name + '.' + cmDevloperName;
                            objCMT.Label = cmDevloperName;
                            // Add all the field values
                            objCMT.values.add(getMetaDataFieldMapping(System.Label.IF_Field_Name_MdtField, objWrapper.fieldAPI));
                            objCMT.values.add(getMetaDataFieldMapping(System.Label.IF_Salesforce_Object_MdtField, childSObjectAPI));
                            objCMT.values.add(getMetaDataFieldMapping(System.Label.IF_Attribute_Name_MdtField, null));
                            objCMT.values.add(getMetaDataFieldMapping(System.Label.IF_Not_include_in_Request_MdtField, true));
                            objCMT.values.add(getMetaDataFieldMapping(System.Label.IF_System_Name_MdtField, sysName));
                            system.debug('=====objWrapper======'+objWrapper);
                            objCMTDeployContainer.addMetadata(objCMT);
                        }
                    }
                }
            }
            //External Id Record
            String cmDevloperName3 = systemNameAbbreviation + '_' + getsObjectAbbreviation(sObjectAPI) + '_' + getsObjectAbbreviation('External_Id__c');
            cmDevloperName3 = getUniqueDeveloperName(cmDevloperName3,sObjectAPI,sysName,System.Label.IF_External_Id_API_Name,existingMTDMap);
            Metadata.CustomMetadata objCMT2=  new Metadata.CustomMetadata();
            objCMT2.FullName = System.Label.IF_Node_Metadata_API_Name + '.' + cmDevloperName3;
            objCMT2.Label = cmDevloperName3;
            objCMT2.values.add(getMetaDataFieldMapping(System.Label.IF_Field_Name_MdtField, System.Label.IF_External_Id_API_Name));
            objCMT2.values.add(getMetaDataFieldMapping(System.Label.IF_Salesforce_Object_MdtField, sObjectAPI));                
            objCMT2.values.add(getMetaDataFieldMapping(System.Label.IF_Attribute_Name_MdtField, System.Label.IF_External_ID_Label));
            objCMT2.values.add(getMetaDataFieldMapping(System.Label.IF_System_Name_MdtField, sysName));
            objCMTDeployContainer.addMetadata(objCMT2); 
            
            if(relationshipName!=null){
                //Parent Record 
                String cmDevloperName1 = systemNameAbbreviation + '_' + getsObjectAbbreviation(sObjectAPI) + '_' + getsObjectAbbreviation(childSObjectAPI);
                cmDevloperName1 = getUniqueDeveloperName(cmDevloperName1,sObjectAPI,sysName,childSObjectAPI,existingMTDMap);
                Metadata.CustomMetadata objCMT =  new Metadata.CustomMetadata();
                objCMT.FullName = System.Label.IF_Node_Metadata_API_Name + '.' + cmDevloperName1;
                objCMT.Label = cmDevloperName1;
                objCMT.values.add(getMetaDataFieldMapping(System.Label.IF_Field_Name_MdtField, childSObjectAPI));
                objCMT.values.add(getMetaDataFieldMapping(System.Label.IF_Salesforce_Object_MdtField, sObjectAPI));
                objCMT.values.add(getMetaDataFieldMapping(System.Label.IF_Attribute_Name_MdtField, childSObjectAPI));
                objCMT.values.add(getMetaDataFieldMapping(System.Label.IF_System_Name_MdtField, sysName));
                objCMTDeployContainer.addMetadata(objCMT);
                
                //Child Record 
                String cmDevloperName2 = systemNameAbbreviation + '_' + getsObjectAbbreviation(childSObjectAPI);
                cmDevloperName2 = getUniqueDeveloperName(cmDevloperName2,childSObjectAPI,sysName,relationshipName,existingMTDMap);
                Metadata.CustomMetadata objCMT1 =  new Metadata.CustomMetadata();
                objCMT1.FullName = System.Label.IF_Node_Metadata_API_Name + '.' + cmDevloperName2;
                objCMT1.Label = cmDevloperName2;
                // Add all the field values
                objCMT1.values.add(getMetaDataFieldMapping(System.Label.IF_Field_Name_MdtField, relationshipName));
                objCMT1.values.add(getMetaDataFieldMapping(System.Label.IF_Salesforce_Object_MdtField, childSObjectAPI));
                objCMT1.values.add(getMetaDataFieldMapping(System.Label.IF_Attribute_Name_MdtField, childSObjectAPI));
                objCMT1.values.add(getMetaDataFieldMapping(System.Label.IF_System_Name_MdtField, sysName));
                objCMTDeployContainer.addMetadata(objCMT1);
                
                //Child External Id Record 
                String cmDevloperName4 = systemNameAbbreviation + '_' + getsObjectAbbreviation(childSObjectAPI) + '_' + getsObjectAbbreviation('ChExternal_Id__c');
                cmDevloperName4 = getUniqueDeveloperName(cmDevloperName4,childSObjectAPI,sysName,'Ch'+ System.Label.IF_External_Id_API_Name,existingMTDMap);
                Metadata.CustomMetadata objCMT3 =  new Metadata.CustomMetadata();
                objCMT3.FullName = System.Label.IF_Node_Metadata_API_Name + '.' + cmDevloperName4;
                objCMT3.Label = cmDevloperName4;
                objCMT3.values.add(getMetaDataFieldMapping(System.Label.IF_Field_Name_MdtField, System.Label.IF_External_Id_API_Name));
                objCMT3.values.add(getMetaDataFieldMapping(System.Label.IF_Salesforce_Object_MdtField, childSObjectAPI));                
                objCMT3.values.add(getMetaDataFieldMapping(System.Label.IF_Attribute_Name_MdtField, 'Child External Id'));
                objCMT3.values.add(getMetaDataFieldMapping(System.Label.IF_System_Name_MdtField, sysName));
                objCMTDeployContainer.addMetadata(objCMT3);  
                
                createRelationshipMetadata(relationshipName,childSObjectAPI,sObjectAPI,sysName,existingMTDMapForRelMdt);
            } 
            
            //Parent Node name record
            if(nodeNm != null){
                String cmDevloperNameNode;
                if((sObjectAPI.length()+sysName.Length()) <= 40){
                    cmDevloperNameNode = sysName + '_' + sObjectAPI;
                }
                else{
                    cmDevloperNameNode = systemNameAbbreviation +'_' + sObjectAbbreviation ;
                }    
                string uniqueDeveloperNameNode = getUniqueDeveloperName(cmDevloperNameNode,sObjectAPI,sysName,null,existingMTDMap);
                Metadata.CustomMetadata objCMT =  new Metadata.CustomMetadata();
                objCMT.FullName = System.Label.IF_Node_Metadata_API_Name + '.' + uniqueDeveloperNameNode;
                objCMT.Label = uniqueDeveloperNameNode;
                objCMT.values.add(getMetaDataFieldMapping(System.Label.IF_Node_Name_MdtField, nodeNm));
                objCMT.values.add(getMetaDataFieldMapping(System.Label.IF_Salesforce_Object_MdtField, sObjectAPI)); 
                objCMT.values.add(getMetaDataFieldMapping(System.Label.IF_System_Name_MdtField, sysName));
                objCMTDeployContainer.addMetadata(objCMT);      
            }
            // SubNode name record
            if(subNodeNm!=null){
                String cmDevloperNamesubNode;
                if((childSObjectAPI.length()+sysName.length()+5) <= 40){
                    cmDevloperNamesubNode = sysName + '_' + childSObjectAPI +  '_' + 'Child';
                }
                else{
                    cmDevloperNamesubNode = systemNameAbbreviation +'_' + getsObjectAbbreviation(childSObjectAPI) + '_' + getsObjectAbbreviation('Child');
                }   
                System.debug('cmDevloperNamesubNode******'+cmDevloperNamesubNode);
                string uniqueDeveloperNameSubNode = getUniqueDeveloperName(cmDevloperNamesubNode,childSObjectAPI,sysName,'Child',existingMTDMap);
                Metadata.CustomMetadata objCMT =  new Metadata.CustomMetadata();
                objCMT.FullName = System.Label.IF_Node_Metadata_API_Name + '.' + uniqueDeveloperNameSubNode;
                objCMT.Label = uniqueDeveloperNameSubNode;
                objCMT.values.add(getMetaDataFieldMapping(System.Label.IF_Node_Name_MdtField, subNodeNm));
                objCMT.values.add(getMetaDataFieldMapping(System.Label.IF_Salesforce_Object_MdtField, childSObjectAPI)); 
                objCMT.values.add(getMetaDataFieldMapping(System.Label.IF_System_Name_MdtField, sysName));
                objCMT.values.add(getMetaDataFieldMapping(System.Label.IF_Is_Child_MdtField, true)); 
                objCMTDeployContainer.addMetadata(objCMT);      
            }
            System.debug('objCMTDeployContainer****************'+objCMTDeployContainer);
            CustomMetadataCallback objCMTCallBack = new CustomMetadataCallback();
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            Id jobId = Metadata.Operations.enqueueDeployment(objCMTDeployContainer, objCMTCallBack);
            return System.Label.IF_SuccessMsg;
        }catch(Exception ex){
            system.debug(ex.getLineNumber()+'===exception==='+ex.getMessage());
            return ex.getMessage();
        }
    }
    /* End */
    
    /**
@MethodName : createRelationshipMetadata
@Param1     : relationship name
@Param2     : Child object API name
@Param3     : Parnet Object API name
@Param4     : System name
@Param5     : Map of custom metadata Relationship_Metadata__mdt
@Description: Method to save mapping information in custom metadata types
@Return     : void
**/
    public static void createRelationshipMetadata(String relatedId,String labelNm,String parentObj, String sysName,Map<String,String> existingMTDMapForRelMdt){
        String developerName = getsObjectAbbreviation(sysName) +'_'+ getsObjectAbbreviation(parentObj)+'_'+getsObjectAbbreviation(labelNm);
        developerName = getUniqueDeveloperName(developerName,labelNm,sysName,parentObj,existingMTDMapForRelMdt);
        try{
            Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
            customMetadata.fullName = System.Label.IF_Relationship_Metadata_API_Name+ '.'+ developerName;
            customMetadata.label = labelNm;
            // Add all the field values 
            customMetadata.values.add(getMetaDataFieldMapping(System.Label.IF_Parent_Object_Name_MdtField, parentObj));
            customMetadata.values.add(getMetaDataFieldMapping(System.Label.IF_RelatedId_MdtField, relatedId));
            customMetadata.values.add(getMetaDataFieldMapping(System.Label.IF_System_Name_MdtField, sysName));
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            mdContainer.addMetadata(customMetadata);
            CustomMetadataCallback callback = new CustomMetadataCallback();
            if(!System.Test.isRunningTest()){
                Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);    
            }
        }catch(Exception ex){
            System.debug(ex.getLineNumber()+' ==== Exception ===='+ex.getMessage());
            // System.assert(false,ex.getMessage()); 
        } 
    }
    /* End */
    
    /**
@MethodName : getsObjectAbbreviation
@Param1     : sObject Label
@Description: Method to get abbreviation of a sObject
@Return     : abbreviated name of sObject
**/
    public static String getsObjectAbbreviation(String sObjectLabel) {
        if(sObjectLabel != null){
            sObjectLabel = sObjectLabel.replaceAll( '\\s+', '');
        }
        system.debug('===getsObjectAbbreviation==='+sObjectLabel);
        String sObjectAbbreviation = '';       
        if(sObjectLabel.length()<11){
            sObjectAbbreviation += sObjectLabel;
        }
        else{ 
            sObjectAbbreviation += sObjectLabel.substring(0, 10);
        }
        system.debug('===getsObjectAbbreviation==='+sObjectAbbreviation);
        return sObjectAbbreviation;
    }
    /* End */
    
    /**
@MethodName : getMetaDataFieldMapping
@Param1     : Field API Name
@Param2     : field Value
@Description: Method to get instance of Metadata.CustomMetadataValue with value
@Return     : Custom metadata field mapping
**/
    private static Metadata.CustomMetadataValue getMetaDataFieldMapping(String fieldName, Object fieldValue) {
        Metadata.CustomMetadataValue objCMField = new Metadata.CustomMetadataValue();
        objCMField.Field = fieldName;
        objCMField.Value = fieldValue;
        return objCMField;
    }
    /* End */
    
    /**
@MethodName : getNodenSubNodeNmFromMtd
@Param1     : sObject API Name
@Param2     : childSObject API Name
@Param3     : System Name
@Param4     : Relationship name for lookup field
@Description: Method to get List of Parent and child node name for selected parent and child resp.
@Return     : List of String with parent and child External system name from metadata
**/
    @AuraEnabled   
    public static List<String> getNodenSubNodeNmFromMtd(String sObjectAPI, String childSObjectAPI,String sysName,String relationshipName){
        List<String> objectList = new List<String>();
        if(sObjectAPI != null){objectList.add(sObjectAPI);}
        if(childSObjectAPI != null){objectList.add(childSObjectAPI);}    
        List<String> externalNodeNmLst = new List<String>();
        List<Node_Name__mdt> nodeNameMtdLst;
        if(objectList != null && objectList.size() >0){
            nodeNameMtdLst = [SELECT Id, Node_Name__c, Attribute_Name__c, Field_Name__c,
                              Salesforce_Object__c,Is_Child__c FROM Node_Name__mdt 
                              where Node_Name__c != null And System_Name__c =:sysName And
                              Salesforce_Object__c IN :objectList]; 
            if(nodeNameMtdLst !=null && nodeNameMtdLst.size() >0){
                String nodeName = null;
                String subNodename = null;
                for(Node_Name__mdt node : nodeNameMtdLst){
                    if(!node.Is_Child__c && node.Salesforce_Object__c == sObjectAPI){
                        nodeName = node.Node_Name__c;  
                    }
                    else if(node.Is_Child__c  && node.Salesforce_Object__c == childSObjectAPI && relationshipName != null){
                        subNodename = node.Node_Name__c;       
                    }
                }
                if(nodeName!=null){externalNodeNmLst.add(nodeName);}
                else{externalNodeNmLst.add(System.Label.IF_NA_Value);}
                if(subNodename!=null){externalNodeNmLst.add(subNodename);}
                else{externalNodeNmLst.add(System.Label.IF_NA_Value);}
            }
            else{
                externalNodeNmLst.add(System.Label.IF_NA_Value);
                externalNodeNmLst.add(System.Label.IF_NA_Value);
            }
        }
        System.debug('externalNodeNmLst*******'+externalNodeNmLst);
        return externalNodeNmLst;
    }
    /* End */
    
    /**
@MethodName : getSystemNameLst
@Description: Method to get all System Name/Connection Name from metadata.
@Return     : List of all System Name/Connection Name
**/
    @AuraEnabled   
    public static List<String> getSystemNameLst(){
        Set<String> systemNameSet = new Set<String>();
        List<Node_Name__mdt> nodeNameMdtLst = [SELECT Id, System_Name__c FROM Node_Name__mdt where System_Name__c != null and System_Name__c!= :System.Label.IF_ExcludeSampleSystemName];
        for(Node_Name__mdt node: nodeNameMdtLst){
            systemNameSet.add(node.System_Name__c);
        }
        List<String> systemNameLst = new List<String>();
        systemNameLst.addAll(systemNameSet);
        return systemNameLst;
    }
    /* End */
    
    /**
@MethodName : getExistingMTDMap
@Description: Method to get data present in metadata Node_Name__mdt
@Return     : Map of key(SystemName + obj Name + Field Name) & metadata Devloper name
**/
    Public static Map<String,String> getExistingMTDMap(){
        Map<String, String> existingMTDMap = new Map<String, String>(); 
        List<Node_Name__mdt> existingMTDList = New List<Node_Name__mdt>();
        existingMTDList = [SELECT DeveloperName, MasterLabel, Id, Field_Name__c, Salesforce_Object__c, System_Name__c FROM Node_Name__mdt];
        if(existingMTDList != null && existingMTDList.Size()>0){
            for(Node_Name__mdt mtdRec : existingMTDList){
                String key = mtdRec.System_Name__c + '|' + mtdRec.Salesforce_Object__c + '|' + mtdRec.Field_Name__c;
                existingMTDMap.put(key, mtdRec.DeveloperName);
            }
        }   
        return existingMTDMap;
    }
    /* End */
    
    /**
@MethodName : getNodeNameLst
@Param1     : System Name
@Description: Method to get all node name present in Node_Name__mdt metadata
@Return     : List of Node names
**/
    @AuraEnabled   
    public static List<String> getNodeNameLst(String sysName){
        Set<String> systemNameSet = new Set<String>();
        List<Node_Name__mdt> nodeNameMdtLst = [SELECT Id, Node_Name__c FROM Node_Name__mdt where System_Name__c =:sysName and Node_Name__c!=null];
        for(Node_Name__mdt node: nodeNameMdtLst){
            systemNameSet.add(node.Node_Name__c);
        }
        List<String> systemNameLst = new List<String>();
        systemNameLst.addAll(systemNameSet);
        return systemNameLst;
    }
    /* End */
    
    /**
@MethodName : getUniqueDeveloperName
@Param1     : Developer name of metadata
@Param2     : Api name of child object
@Param3     : System Name
@Param4     : Field API name
@Param5     : Map of key(SystemName + obj Name + Field Name) & metadata Developer name
@Description: Method to get all node name present in Node_Name__mdt metadata
@Return     : String as unique develoer name
**/
    Public static String getUniqueDeveloperName(String cmDevloperName, String childSObjectAPI, String sysName,String fieldAPI,Map<String,String> existingMTDMap){
        String uniqueDevName;
        cmDevloperName = cmDevloperName.replaceAll( '\\s+', '');
        String tempDevName = cmDevloperName.replaceAll('__', '_');
        String key = sysName + '|' + childSObjectAPI + '|' + fieldAPI;
        if(existingMTDMap != null && existingMTDMap.containsKey(key)){            
            String devName = existingMTDMap.get(key);
            uniqueDevName = devName;
        }
        else{
            Integer cnt = 0;
            for(String devNamekey : existingMTDMap.values()){
                if(devNamekey.contains(tempDevName)){ 
                    cnt = cnt +  1;
                }
            } 
            if(cnt > 0){
                uniqueDevName = tempDevName + '_' + cnt;    
            }
            else{
                uniqueDevName = tempDevName;    
            }
        }   
        System.debug('Final*******'+uniqueDevName);
        return uniqueDevName;
    }
    /* End */
    
    /**
@MethodName : getExistingMTDMapForRelationMtd
@Description: Method to get data present in metadata Relationship_Metadata__mdt
@Return     : Map of key(SystemName + label + Parent Object name) & metadata Developer name
**/
    Public static Map<String,String> getExistingMTDMapForRelationMtd(){
        Map<String, String> existingMTDMap = new Map<String, String>(); 
        List<Relationship_Metadata__mdt> relatedIdLst = [SELECT Id, DeveloperName,MasterLabel, System_Name__c, RelatedId__c,Parent_Object_Name__c FROM Relationship_Metadata__mdt];
        if(relatedIdLst != null && relatedIdLst.Size()>0){
            for(Relationship_Metadata__mdt mtdRec : relatedIdLst){
                String key = mtdRec.System_Name__c + '|' + mtdRec.MasterLabel + '|' + mtdRec.Parent_Object_Name__c;
                existingMTDMap.put(key, mtdRec.DeveloperName);
            }
        }   
        return existingMTDMap;
    }
    /* End */
}