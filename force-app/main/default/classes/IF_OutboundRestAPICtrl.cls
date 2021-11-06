/*
** ____________________________________________________________________________________________
** Worked By:       Nilesh Jaiswal, Pranav Chavan, Rohit Midha
** Created Date:    15/04/2020
** ============================================================================================
** Description: Outbound Request setup Lightning Component controller
** ____________________________________________________________________________________________
*/
public class IF_OutboundRestAPICtrl {
    
    /* SOjectWrapper - Start */
    public class SOjectWrapper implements Comparable {
        public Integer compareTo(Object compareTo) {
            SOjectWrapper SOjectWrapper = (SOjectWrapper ) compareTo;
            if(label == SOjectWrapper.label) return 0;
            if(label > SOjectWrapper.label) return 1;
            return -1;        
        }
        
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
    
    /* IntegrationFrameworkWrapper - Start */
    public class IntegrationFrameworkWrapper {
        @AuraEnabled
        public Map<String, String> externalNodeNameMap {get;set;}
        @AuraEnabled
        public String parentMetaDataName {get;set;}
    }
    /* IntegrationFrameworkWrapper - End */
    
    /**
        @MethodName : getSystemNameList
        @Description: Method to get all System Name/Connection Name from metadata.
        @Return     : List of all System Name/Connection Name
    **/
    @AuraEnabled   
    public static List<String> getSystemNameList(){
        Set<String> systemNameSet = new Set<String>();
        List<Integration_Framework__mdt> metadataList = [SELECT Id, System_Name__c FROM Integration_Framework__mdt 
                                                         WHERE System_Name__c != null AND System_Name__c !=: System.Label.IF_ExcludeSampleSystemName];
        for(Integration_Framework__mdt metadata : metadataList){
            systemNameSet.add(metadata.System_Name__c);
        }
        return new List<String>(systemNameSet);
    }
    /* End */
    
    /**
        @MethodName : getAllNamedCredentialURLs
        @Description: Method to get all Named Credentials
        @Return     : URL/Endpoint of all the named credentials
    **/
    @AuraEnabled
    public static List<SOjectWrapper> getAllNamedCredentialURLs() {
        List<SOjectWrapper> lstNamedCreds = new List<SOjectWrapper>();
        for(NamedCredential namedCredRec : [SELECT Id, MasterLabel, DeveloperName, Endpoint FROM NamedCredential 
                                            WHERE DeveloperName !=: 'IF_DONOTDELETENAMEDCREDENTIAL']) {
            SOjectWrapper objWrapper = new SOjectWrapper();
            objWrapper.label = namedCredRec.MasterLabel;
            objWrapper.value = namedCredRec.DeveloperName;
            lstNamedCreds.add(objWrapper);
        }
        return lstNamedCreds;
    }
    /* End */
    
    /**
        @MethodName : getPicklistValues
        @Param1		: sObject API Name
		@Param2		: Picklist field API Name
        @Description: Method to get all Picklist values of a field from given sObject 
        @Return     : the label value wrapper list of picklist values
    **/
    @AuraEnabled
    public static List<SOjectWrapper> getPicklistValues(String sObjectAPI, String fieldName) {
        List<SOjectWrapper> lstListView = new List<SOjectWrapper>();
        Schema.SObjectType sObjectToken = Schema.getGlobalDescribe().get(sObjectAPI) ;
        
        //iterate over all picklist entries
        for(Schema.PicklistEntry objPE : sObjectToken.getDescribe().fields.getMap().get(fieldName).getDescribe().getPicklistValues()){
            SOjectWrapper objWrapper = new SOjectWrapper();
            objWrapper.label = objPE.getLabel();
            objWrapper.value = objPE.getValue();
            lstListView.add(objWrapper);
        }    
        return lstListView;
    }
    /* End */
 
    /**
        @MethodName : getsObjects
        @Description: Method to get all sObject list 
        @Return     : the label value wrapper list of sObject 
    **/
    @AuraEnabled   
    public Static List<SOjectWrapper> getsObjects() {
        List<SOjectWrapper> lstsObjectWrapper = new List<SOjectWrapper>();
        Map<String, Schema.SObjectType> mapsObjects = Schema.getGlobalDescribe();
        List<String> lstsObjects = new List<String>(mapsObjects.keySet());
        List<SOjectWrapper> lstsObjectWrapperWithManagedPackageObj = new List<SOjectWrapper>();
        List<SOjectWrapper> lstsObjectWrapperWithoutManagedPackageObj = new List<SOjectWrapper>();
        
        //sort list of sobjects
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
                lstsObjectWrapperWithoutManagedPackageObj.add(objWrapper);
            }
            lstsObjectWrapper.add(objWrapper);
        }
        system.debug('===lstsObjectWrapper==='+lstsObjectWrapper);
        if(System.Label.IF_Display_Managed_Pkg_Objects.contains('true')){
            return lstsObjectWrapperWithManagedPackageObj;
        } else {
            return lstsObjectWrapperWithoutManagedPackageObj;
        }
        //lstsObjectWrapper.sort();
        //return lstsObjectWrapper;
    }
    /* End */
    
    /**
        @MethodName : getRelatedsObjects
        @Param1		: sObject API Name
        @Description: Method to get all child object names related to a sObject
        @Return     : label and value of all related child sobjects
    **/
    @AuraEnabled
    public static List<SOjectWrapper> getRelatedsObjects(String sObjectAPI) {
        List<SOjectWrapper> lstsObjectWrapper = new List<SOjectWrapper>();
        if(String.isNotBlank(sObjectAPI)) {
            Map<String, Schema.SObjectType> mapsObjects = Schema.getGlobalDescribe();
            Schema.DescribeSObjectResult objDescribe = mapsObjects.get(sObjectAPI).getDescribe();
            List<Schema.ChildRelationship> lstChildRelationship = objDescribe.getChildRelationships();
            
            SOjectWrapper objWrapper = new SOjectWrapper();
            objWrapper.label = objDescribe.getLabel();
            objWrapper.value = objDescribe.getName() + '#' + objDescribe.getLabel();
            lstsObjectWrapper.add(objWrapper);
            
            //iterate over childrelationship list and prepare wrapper list
            //also added the relationship field
            for(Schema.ChildRelationship objCR : lstChildRelationship) {
                Schema.DescribeSObjectResult sObjResult = objCR.getChildSObject().getDescribe();
                objWrapper = new SOjectWrapper();
                objWrapper.label = sObjResult.getLabel() + ' ( ' + objCR.getField() + ' )';
                objWrapper.value = sObjResult.getName() + '#' + sObjResult.getLabel();
                lstsObjectWrapper.add(objWrapper);
            }    
        }
        return lstsObjectWrapper;
    }
    /* End */
    
    /**
        @MethodName : getsObjectFields
        @Param1		: sObject API Name
		@Param2		: Parent metadata name to relate
        @Description: Method to get all fields for a sobject
        @Return     : list of label and value wrapper of field api and attribute
    **/
    @AuraEnabled   
    public Static List<FieldWrapper> getsObjectFields(String sObjectAPI, String parentMetaDataName) {
        system.debug('===sObjectAPI==='+sObjectAPI+'==parentMetaDataName=='+parentMetaDataName);
        List<FieldWrapper> lstFieldWrapper = new list <FieldWrapper>(); 
        if(String.isNotBlank(sObjectAPI)) {
            Schema.SObjectType sObj = Schema.getGlobalDescribe().get(sObjectAPI);
            Map<String, String> mapSFFieldToAttributeName = new Map<String, String>();
            
            //if parent Metadata name is not blank then fetch existing field mapping related to parent metadata
            if(String.isNotBlank(parentMetaDataName)) {
                mapSFFieldToAttributeName = getExistingFieldMappings(sObjectAPI, parentMetaDataName);
            }
            
            //iterate over all fields and fille the wrapper
            //add existing attribute if mapping is available
            for(Schema.SObjectField field : sObj.getDescribe().fields.getMap().values()){
                FieldWrapper objWrapper = new FieldWrapper();
                objWrapper.fieldAPI = field.getDescribe().getName();
                if(mapSFFieldToAttributeName.containsKey(field.getDescribe().getName())) {
                    objWrapper.attributeValue = mapSFFieldToAttributeName.get(field.getDescribe().getName());
                } else {
                    objWrapper.attributeValue = null;    
                }
                lstFieldWrapper.add(objWrapper);     
            }
        }
        system.debug('===lstFieldWrapper==='+lstFieldWrapper);
        return lstFieldWrapper;
    }
    /* End */
    
    /**
        @MethodName : getExistingFieldMappings
        @Param1		: sObjectType API Name
		@Param2		: Parent metadata name
        @Description: Method to get existing field mappings
        @Return     : Map of salesforce field to attribute name
    **/
    private static Map<String, String> getExistingFieldMappings(String sObjectAPI, String parentMetaDataName) {
        Map<String, String> mapSFFieldToAttributeName = new Map<String, String>();
        for(Integration_Framework_Mapping__mdt objIFM : [SELECT Id, Attribute_Name__c, Salesforce_Field__c 
                                                         FROM Integration_Framework_Mapping__mdt
                                                         WHERE Parent_Detail__r.DeveloperName =: parentMetaDataName 
                                                         AND Object_Name__c =: sObjectAPI
                                                         AND Not_Include_In_Request__c = FALSE])
        {
            mapSFFieldToAttributeName.put(objIFM.Salesforce_Field__c, objIFM.Attribute_Name__c);
        }
        return mapSFFieldToAttributeName;
    }
    /* End */
    
    /**
        @MethodName : getExistingMetaData
        @Param1		: sObjectType API Name
		@Param2		: End point URL
        @Description: Method to Integration details
        @Return     : Integrationwrapper instance
    **/
    @AuraEnabled   
    public Static IntegrationFrameworkWrapper getExistingMetaData(String sObjectAPI, String namedCredName, String systemName) {
     	system.debug('==sObjectAPI=='+sObjectAPI+'==namedCredName=='+namedCredName+'==systemName=='+systemName);
        
        String queryStr = 'SELECT Id, DeveloperName, Child_Object_Names__c, Send_Request__c, Node_Names_External_System__c ';
        queryStr += 'FROM Integration_Framework__mdt WHERE Object_Name__c = \'' + sObjectAPI + '\' AND Named_Credential_Name__c = \'' + namedCredName + '\' ';                 
        queryStr += 'AND System_Name__c = \'' + systemName + '\' ';
        if(!System.Test.isRunningTest()) {
            queryStr += 'AND System_Name__c != \'' + System.Label.IF_ExcludeSampleSystemName + '\'';
        }
        
        List<Integration_Framework__mdt> lstIF = Database.query(queryStr);
        if(!lstIF.isEmpty()) {
            Integration_Framework__mdt objIF = lstIF[0];
            IntegrationFrameworkWrapper objWrapper = new IntegrationFrameworkWrapper();
            objWrapper.externalNodeNameMap = getExternalNodeNamesMap(objIF.Node_Names_External_System__c);
            objWrapper.parentMetaDataName = objIF.DeveloperName;
            return objWrapper;
        }
        return null;
    }
    /* End */
    
    /**
        @MethodName : getMetaDataTypeName
        @Param1		: sObjectType API name
		@Param2		: Endpoint URL
        @Description: Method to get unique metadata API name
        @Return     : Unique metadata api name
    **/
    private static String getMetaDataTypeName(String sObjectAPI, String namedCredName, String systemName) {
        List<Integration_Framework__mdt> lstIFE = [SELECT DeveloperName FROM Integration_Framework__mdt 
                                                   WHERE Object_Name__c =: sObjectAPI 
                                                   AND Named_Credential_Name__c =: namedCredName 
                                                   AND System_Name__c =: systemName 
                                                   AND System_Name__c !=: System.Label.IF_ExcludeSampleSystemName
                                                   LIMIT 1]; 
        //if metadata record found then return the API name else prepare the metadata unique name
        //with combination of sobject api and number series
        if(!lstIFE.isEmpty()) {
            return lstIFE[0].DeveloperName;
        } else {
            List<Integration_Framework__mdt> lstIFN = [SELECT DeveloperName FROM Integration_Framework__mdt 
                                                       WHERE Object_Name__c =: sObjectAPI 
                                                       AND System_Name__c !=: System.Label.IF_ExcludeSampleSystemName
                                                       ORDER BY DeveloperName DESC LIMIT 1]; 
            if(!lstIFN.isEmpty()) {
                return sObjectAPI + '_' + String.valueOf(Integer.valueOf(lstIFN[0].DeveloperName.substringAfter('_')) + 1).leftPad(2,'0');
            }
            return sObjectAPI.replace('__c', '') + '_01';               
        }          
    }
    /* End */
    
    /**
        @MethodName : saveMetaDataInfo
        @Param1		: sObject API Name
		@Param2		: sObject Label
		@Param3		: End point URL
		@Param4		: Http Method Name
        @Description: Method to save parent metadata type
        @Return     : Success or failure msg
    **/
    @AuraEnabled   
    public Static String saveMetaDataInfo(String sObjectAPI, String sObjectLabel, String namedCredName, String systemName) { 
        try {
            //get the unique name with format Name_##
            String strMetaDataName = getMetaDataTypeName(sObjectAPI, namedCredName, systemName);
            // Set up custom metadata to be created in the subscriber org.
            Metadata.CustomMetadata objCMT =  new Metadata.CustomMetadata();
            objCMT.FullName = 'Integration_Framework__mdt.' + strMetaDataName;
            objCMT.Label = strMetaDataName;
            
            // Add all the field values 
            //objCMT.values.add(getMetaDataFieldMapping('Child_Object_Names__c', childObjectNames));
            objCMT.values.add(getMetaDataFieldMapping('Object_Name__c', sObjectAPI));
            objCMT.values.add(getMetaDataFieldMapping('Object_Label__c', sObjectLabel));
            objCMT.values.add(getMetaDataFieldMapping('Named_Credential_Name__c', namedCredName));
            objCMT.values.add(getMetaDataFieldMapping('Method__c', 'POST'));
            objCMT.values.add(getMetaDataFieldMapping('Send_Request__c', TRUE));
            objCMT.values.add(getMetaDataFieldMapping('System_Name__c', systemName));
            
            System.debug('====objCMT====' + objCMT );
            Metadata.DeployContainer objCMTDeployContainer = new Metadata.DeployContainer();
            objCMTDeployContainer.addMetadata(objCMT);
            
            // Setup deploy callback, MyDeployCallback implements
            // the Metadata.DeployCallback interface 
            CustomMetadataCallback objCMTCallBack = new CustomMetadataCallback();
            
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(!System.Test.isRunningTest()) {
            	Id jobId = Metadata.Operations.enqueueDeployment(objCMTDeployContainer, objCMTCallBack);    
            }
            return 'SUCCESS#' + strMetaDataName;
        }catch(Exception ex){
            system.debug(ex.getLineNumber()+'===exception==='+ex.getMessage());
            return ex.getMessage();
        }
    }
    /* End */
    
    /**
        @MethodName : saveMetaDataMappingsInfo
        @Param1		: sObject API Name
		@Param2		: sObject Label
		@Param3		: Parent Metadata Name
		@Param4		: List of Field wrapper with Attribute Value
        @Description: Method to save mapping information in custom metata types
        @Return     : Success or failure msg
    **/
    @AuraEnabled
    public static String saveMetaDataMappingsInfo(String sObjectAPI, String sObjectLabel, String metaDataName, 
                                                  String parentNodeName, String childNodeName, List<FieldWrapper> lstFieldWrapper) { 
        try{
            system.debug('=sObjectAPI='+sObjectAPI+'=sObjectLabel='+sObjectLabel+'=metaDataName='+metaDataName+'=lstFieldWrapper='+lstFieldWrapper);
            system.debug('=parentNodeName='+parentNodeName+'=childNodeName='+childNodeName);
                         
            if(!lstFieldWrapper.isEmpty()) {
                Map<String, String> mapSFFieldToAttributeName = getExistingFieldMappings(sObjectAPI, metaDataName);
                String sObjectAbbreviation = getsObjectAbbreviation(sObjectLabel, metaDataName);
                Metadata.DeployContainer objCMTDeployContainer = new Metadata.DeployContainer();
                
                //iterate over sobject field wrapper to create mapping records
                for(FieldWrapper objWrapper : lstFieldWrapper) {
                    String cmDevloperName = sObjectAbbreviation + '_' + objWrapper.fieldAPI.removeEnd('__c');
                    Metadata.CustomMetadata objCMT =  new Metadata.CustomMetadata();
                    //if attribute value is there then create a mapping
                    if(String.isNotBlank(objWrapper.attributeValue)) {
                        objCMT.FullName = 'Integration_Framework_Mapping__mdt.' + cmDevloperName;
                        objCMT.Label = cmDevloperName;
                        
                        // Add all the field values 
                        objCMT.values.add(getMetaDataFieldMapping('Object_Name__c', sObjectAPI));
                        objCMT.values.add(getMetaDataFieldMapping('Salesforce_Field__c', objWrapper.fieldAPI));
                        objCMT.values.add(getMetaDataFieldMapping('Attribute_Name__c', objWrapper.attributeValue));
                        objCMT.values.add(getMetaDataFieldMapping('Parent_Detail__c', metaDataName));
                        objCMT.values.add(getMetaDataFieldMapping('Not_Include_In_Request__c', FALSE));
                        objCMTDeployContainer.addMetadata(objCMT);
                    } 
                    //if attribute name is removed from any mapping then set Not_Include_In_Request__c to TRUE
                    else if(mapSFFieldToAttributeName.containsKey(objWrapper.fieldAPI)) {
                        objCMT.FullName = 'Integration_Framework_Mapping__mdt.' + cmDevloperName;
                        objCMT.Label = cmDevloperName;
                        
                        // Add all the field values 
                        objCMT.values.add(getMetaDataFieldMapping('Not_Include_In_Request__c', TRUE));
                        objCMT.values.add(getMetaDataFieldMapping('Attribute_Name__c', objWrapper.attributeValue));
                        objCMTDeployContainer.addMetadata(objCMT);
                    }
                }

                //get existing child names and external node names
                //and update it to the Parent Metadata record
                List<Integration_Framework__mdt> lstIF = [SELECT Child_Object_Names__c, Node_Names_External_System__c 
                                                          FROM Integration_Framework__mdt
                                                          WHERE DeveloperName =: metaDataName];
                system.debug('==lstIF==='+lstIF);
                String childObjectNames;
                String parentsObjectAPI = metaDataName.substringBefore('_');
                Map<String, String> sObjAPIToNodeNameMap = new Map<String, String>();
                
                //to update parent metadata with child object names and external node names
                Metadata.CustomMetadata objParentCMT =  new Metadata.CustomMetadata();
                objParentCMT.FullName = 'Integration_Framework__mdt.' + metaDataName;
                objParentCMT.Label = metaDataName;
                
                if(!lstIF.isEmpty()) {
                    if(lstIF[0].Child_Object_Names__c != null) {
                        childObjectNames = lstIF[0].Child_Object_Names__c;                    
                    }
                    if(lstIF[0].Node_Names_External_System__c != null) {
                        sObjAPIToNodeNameMap = getExternalNodeNamesMap(lstIF[0].Node_Names_External_System__c);
                    }
                    
                    //if current object name is not equals to the parent object name then only add childobject names
                    if(sObjectAPI != metaDataName.substringBefore('_')) {
                        if(String.isNotBlank(childObjectNames) && !childObjectNames.contains(sObjectAPI)) {
                            childObjectNames += ',' + sObjectAPI;
                        } else if(String.isBlank(childObjectNames)) {
                            childObjectNames = sObjectAPI;
                        } 
                        objParentCMT.values.add(getMetaDataFieldMapping('Child_Object_Names__c', childObjectNames));
                    }
                }
                
                //if user entered external node name then use it else use the plural label of that sobject
                if(String.isNotBlank(parentNodeName)) {
                    system.debug('==if==');
                    sObjAPIToNodeNameMap.put(parentsObjectAPI, parentNodeName);    
                } else {
                    system.debug('==else==');
                    Schema.SObjectType sObj = Schema.getGlobalDescribe().get(parentsObjectAPI);
                    sObjAPIToNodeNameMap.put(parentsObjectAPI, sObj.getDescribe().getLabelPlural());    
                }
                
                if(String.isNotBlank(childNodeName)) {
                    sObjAPIToNodeNameMap.put(sObjectAPI, childNodeName);    
                } else if(sObjectAPI != parentsObjectAPI) {
                    Schema.SObjectType sObj = Schema.getGlobalDescribe().get(sObjectAPI);
                    sObjAPIToNodeNameMap.put(sObjectAPI, sObj.getDescribe().getLabelPlural());    
                }
                system.debug('==sObjAPIToNodeNameMap=='+sObjAPIToNodeNameMap);
                system.debug('==getExternalNodeNames=='+getExternalNodeNames(sObjAPIToNodeNameMap));
                
                //add value to the metadata instance for external node name
                if(String.isNotBlank(getExternalNodeNames(sObjAPIToNodeNameMap))) {
                    objParentCMT.values.add(getMetaDataFieldMapping('Node_Names_External_System__c', getExternalNodeNames(sObjAPIToNodeNameMap)));
                }
                objCMTDeployContainer.addMetadata(objParentCMT);
                system.debug('==objCMTDeployContainer==='+objCMTDeployContainer);
                
                // Setup deploy callback, MyDeployCallback implements
                // the Metadata.DeployCallback interface 
                CustomMetadataCallback objCMTCallBack = new CustomMetadataCallback();
                
                // Enqueue custom metadata deployment
                // jobId is the deployment ID
                if(!System.Test.isRunningTest()) {
					Id jobId = Metadata.Operations.enqueueDeployment(objCMTDeployContainer, objCMTCallBack);
                }
            }
            return 'SUCCESS';
        }catch(Exception ex){
            system.debug(ex.getLineNumber()+'===exception==='+ex.getMessage());
            return ex.getMessage();
        }
    }
    /* End */
    
    /**
        @MethodName : getsObjectAbbreviation
		@Param2		: sObject Label
		@Param3		: Parent Metadata Name
        @Description: Method to get abbreviation of a sObject
        @Return     : abbreviated name of sObject
    **/
    public static String getsObjectAbbreviation(String sObjectLabel, String metaDataName) {
        system.debug('===getsObjectAbbreviation==='+sObjectLabel);
        String sObjectAbbreviation = '';
        for(String str : sObjectLabel.split(' ')) {
            sObjectAbbreviation += str.substring(0, 3);
        }
        system.debug('===getsObjectAbbreviation==='+sObjectAbbreviation);
        return sObjectAbbreviation + '_' + metaDataName.substringAfter('_');
    }
    /* End */

    /**
        @MethodName : getMetaDataFieldMapping
        @Param1		: Field API Name
		@Param2		: field Value
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
        @MethodName : getExternalNodeNamesMap
        @Param1		: External Node Names ex. Accounts=>Customers
        @Description: Method to convert the external node names string to a Map
        @Return     : Map of sobject API name to External Node Name
    **/
    public static Map<String, String> getExternalNodeNamesMap(String externalNodeNames) {
        Map<String, String> sObjAPIToNodeNameMap = new Map<String, String>();
        
        if(String.isNotBlank(externalNodeNames)) {
            for(String node : externalNodeNames.split(',')) {
                List<String> nodeList = node.split('=>');
                sObjAPIToNodeNameMap.put(nodeList[0], nodeList[1]);
            }    
        }
        return sObjAPIToNodeNameMap;
    }
    /* End */
    
    /**
        @MethodName : getExternalNodeNames
        @Param1		: External Node Names Map 
        @Description: Method to get the External Node Names string ex. ex. Accounts=>Customers,Contact=>Persons
        @Return     : External Node Names string
    **/
    private static String getExternalNodeNames(Map<String, String> sObjAPIToNodeNameMap) {
        String externalNodeNames='';
        for(String sObjAPI : sObjAPIToNodeNameMap.keySet()) {
            String nodeNameStr = sObjAPI + '=>' + sObjAPIToNodeNameMap.get(sObjAPI);
            externalNodeNames += String.isNotBlank(externalNodeNames) ? ',' + nodeNameStr : nodeNameStr;
        }
        return externalNodeNames;
    }
    /* End */
}