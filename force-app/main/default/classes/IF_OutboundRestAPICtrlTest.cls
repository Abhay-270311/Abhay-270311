@IsTest
public class IF_OutboundRestAPICtrlTest {
    
    @IsTest
    static void testgetsObjects(){
        System.Test.startTest();
        List<IF_OutboundRestAPICtrl.SOjectWrapper> obj = IF_OutboundRestAPICtrl.getsObjects();
        System.Test.stopTest();

        System.assertEquals(false, obj.isEmpty(), 'List<IF_OutboundRestAPICtrl.SOjectWrapper> should not be empty');
    }
    
    @IsTest
    static void testgetAllNamedCredentialURLs(){
        System.Test.startTest();
        List<IF_OutboundRestAPICtrl.SOjectWrapper> obj = IF_OutboundRestAPICtrl.getAllNamedCredentialURLs();
        System.Test.stopTest();

        System.assertEquals(false, obj.isEmpty(), 'List<IF_OutboundRestAPICtrl.SOjectWrapper> should not be empty');
    }
        
    @IsTest
    static void testgetRelatedsObjects(){
        System.Test.startTest();
        List<IF_OutboundRestAPICtrl.SOjectWrapper> obj = IF_OutboundRestAPICtrl.getRelatedsObjects('Account');
        obj.sort();
        System.Test.stopTest();

        System.assertEquals(false, obj.isEmpty(), 'List<IF_OutboundRestAPICtrl.SOjectWrapper> should not be empty');
        
    }
    
    @IsTest
    static void testgetExistingMetaData(){
        System.Test.startTest();
        IF_OutboundRestAPICtrl.IntegrationFrameworkWrapper obj = IF_OutboundRestAPICtrl.getExistingMetaData('Account','IF_DONOTDELETENAMEDCREDENTIAL','IF_DONOTDELETESYSTEM');
        System.Test.stopTest();

        System.assertEquals(false, String.isBlank(obj.parentMetaDataName), 'parentMetaDataName should not be empty');
    }
    
    @IsTest
    static void testgetsObjectFields(){
        System.Test.startTest();
        List<IF_OutboundRestAPICtrl.FieldWrapper> obj = IF_OutboundRestAPICtrl.getsObjectFields('Contact', 'Account');
        System.Test.stopTest();

        System.assertEquals(false, obj.isEmpty(), 'List<IF_OutboundRestAPICtrl.FieldWrapper> should not be empty');
    }
    
    @IsTest
    static void testsaveMetaDataInfo(){
        System.Test.startTest();
        String obj = IF_OutboundRestAPICtrl.saveMetaDataInfo('Account','Account','IF_DONOTDELETENAMEDCREDENTIAL','IF_DONOTDELETESYSTEM');
        System.Test.stopTest();

        System.assertEquals(false, String.isBlank(obj), 'Output String shouln\'t be empty');
    }
    
    @IsTest
    static void testsaveMetaDataMappingsInfo(){
        System.Test.startTest();
        String obj = IF_OutboundRestAPICtrl.saveMetaDataMappingsInfo('Account','Account','Contact','Account','Contact',IF_OutboundRestAPICtrl.getsObjectFields('Contact', 'Account'));
        System.Test.stopTest();

        System.assertEquals(false, String.isBlank(obj), 'Output String shouln\'t be empty');
    }
    
    @IsTest
    static void testsaveMetaDataMappingsInfoBlankParentNodeName(){
        System.Test.startTest();
        String obj = IF_OutboundRestAPICtrl.saveMetaDataMappingsInfo('Account','Account','Contact','','',IF_OutboundRestAPICtrl.getsObjectFields('Contact', 'Account'));
        System.Test.stopTest();

        System.assertEquals(false, String.isBlank(obj), 'Output String shouln\'t be empty');
    }
    
    @IsTest
    static void testgetPicklistValues(){
        System.Test.startTest();
        List<IF_OutboundRestAPICtrl.SOjectWrapper> obj = IF_OutboundRestAPICtrl.getPicklistValues('Account','AccountSource');
        System.Test.stopTest();

        System.assertEquals(false, obj.isEmpty(), 'List<IF_OutboundRestAPICtrl.SOjectWrapper> should not be empty');
    }
    
    @IsTest
    static void testgetSystemNameList(){
        System.Test.startTest();
        List<String> obj= IF_OutboundRestAPICtrl.getSystemNameList();
        System.Test.stopTest();

        System.assertEquals(false, obj.isEmpty(), 'List<String> should not be empty');
    }
    
    @IsTest
    static void testgetMetaDataTypeName(){
        System.Test.startTest();
        IF_OutboundRestAPICtrl.IntegrationFrameworkWrapper obj = IF_OutboundRestAPICtrl.getExistingMetaData('Account','IF_DONOTDELETENAMEDCREDENTIAL','IF_DONOTDELETESYSTEM');
        System.Test.stopTest();

        System.assertEquals(false, String.isBlank(obj.parentMetaDataName), 'parentMetaDataName should not be Blank');
    }
}