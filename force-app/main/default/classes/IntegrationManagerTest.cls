@isTest
public class IntegrationManagerTest {

    @testSetup 
    static void setup(){
        
        
    }
    
    @isTest
    static void testgetsObjects(){
        IntegrationManager.getsObjects();
    }
    
    @isTest
    static void testgetAllNamedCredentialURLs(){
        IntegrationManager.getAllNamedCredentialURLs();
    }
        
    @isTest
    static void testgetRelatedsObjects(){
        IntegrationManager.getRelatedsObjects('Account');
        
    }
    
    @isTest
    static void testgetExistingMetaData(){
        IntegrationManager.getExistingMetaData('Account','Nilesh_Outbound_EndPoint','GPO');
    }
    
    @isTest
    static void testgetsObjectFields(){
        IntegrationManager.getsObjectFields('Contact', 'Account');
    }
    
    @isTest
    static void testsaveMetaDataInfo(){
        IntegrationManager.saveMetaDataInfo('Account','Account','saveMetaDataInfo','GPO');
    }
    
    @isTest
    static void testsaveMetaDataMappingsInfo(){
        IntegrationManager.saveMetaDataMappingsInfo('Account','Account','Contact','Account','Contact',IntegrationManager.getsObjectFields('Contact', 'Account'));
    }
    
    @isTest
    static void testsaveMetaDataMappingsInfoBlankParentNodeName(){
        IntegrationManager.saveMetaDataMappingsInfo('Account','Account','Contact','','',IntegrationManager.getsObjectFields('Contact', 'Account'));
    }
    
    @isTest
    static void testgetPicklistValues(){
        IntegrationManager.getPicklistValues('Account','AccountSource');
    }
    
    @isTest
    static void testgetSystemNameList(){
        IntegrationManager.getSystemNameList();
    }
    
    /*
    @isTest
    static void testgetMetaDataTypeName(){
        IntegrationManager.getMetaDataTypeName('Account','Nilesh_Outbound_EndPoint');
    }
    */
    
    @isTest
    static void testgetMetaDataTypeName(){
        IntegrationManager.getExistingMetaData('Account','Nilesh_Outbound_EndPoint','GPO');
    }
    
    /*
    @isTest
    static void testsaveMetaDataMappingsInfo(){
        IntegrationManager.saveMetaDataMappingsInfo(sObjectAPI, sObjectLabel, metaDataName, parentNodeName, childNodeName, lstFieldWrapper);
    }
    */
    
}