@isTest
public class IF_InboundRestAPICtrlTest {
    
    @isTest
    static void testGetsObjectFields(){
        IF_InboundRestAPICtrl.getsObjectFields('Account','INB_ACCOUNT',System.Label.IF_ExcludeSampleSystemName,'Existing');
    }
    
    @isTest
    static void testGetsObjectFieldsNew(){
        IF_InboundRestAPICtrl.getsObjectFields('Account','INB_ACCOUNT',System.Label.IF_ExcludeSampleSystemName,'New');
    }
    
    @isTest
    static void testgetMap(){
         IF_InboundRestAPICtrl.getMap('Account',System.Label.IF_ExcludeSampleSystemName );
    }
    
    @isTest
    static void testgetNodenSubNodeNmFromMtd(){
       IF_InboundRestAPICtrl.getNodenSubNodeNmFromMtd('Account','Contact', System.Label.IF_ExcludeSampleSystemName, 'Contacts');  
    }
    
    @isTest
    static void testgetNodeNameLst(){
        IF_InboundRestAPICtrl.getNodeNameLst(System.Label.IF_ExcludeSampleSystemName);
    }
    
    @isTest
    static void testgetsObjectAbbreviation(){
        List<Schema.SObjectType>  objTyp = Schema.getGlobalDescribe().Values();
        String objAPIName = objTyp[0].getDescribe().getName();
        IF_InboundRestAPICtrl.getsObjectAbbreviation(objTyp[0].getDescribe().getLabel());
    }
    
    @isTest
    static void testgetRelatedsObjects(){
        IF_InboundRestAPICtrl.getRelatedsObjects('Account');
    }

    @isTest
    static void testsaveMetaDataMappingsInfo(){
        IF_InboundRestAPICtrl.saveMetaDataMappingsInfo('Account', 'Account' ,'Contact','Contact','Contacts', IF_InboundRestAPICtrl.getsObjectFields('Account','Account',System.Label.IF_ExcludeSampleSystemName,'Existing'),'INB_CONTACT','INB_CONTACT', System.Label.IF_ExcludeSampleSystemName);
    }
    @isTest
    static void testgetsObjects(){
       IF_InboundRestAPICtrl.getsObjects();
    }
    
    @isTest
    static void testgetSystemNameLst(){
        IF_InboundRestAPICtrl.getSystemNameLst();
    }
    
     @isTest
    static void testgetExistingMTDMap(){
        IF_InboundRestAPICtrl.getExistingMTDMap();
    }
    
       @isTest
    static void testgetExistingMTDMapForRelationMtd(){
        IF_InboundRestAPICtrl.getExistingMTDMapForRelationMtd();
    }
    
    @isTest
    static void testgetUniqueDeveloperName(){
        IF_InboundRestAPICtrl.getUniqueDeveloperName('Node_Name__mdt', 'Contact',System.Label.IF_ExcludeSampleSystemName,'AccountId',IF_InboundRestAPICtrl.getExistingMTDMapForRelationMtd());
    }
}