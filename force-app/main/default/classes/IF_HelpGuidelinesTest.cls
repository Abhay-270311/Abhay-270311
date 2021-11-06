/*
** ____________________________________________________________________________________________
** Worked By:       Mukul Anand Sharma/Payal Ahuja
** Created Date:    11/06/2020
** ============================================================================================
** Description: Test class for IF_HelpGuidelines class
** ____________________________________________________________________________________________
*/
@IsTest(SeeAllData = false)
private with sharing class IF_HelpGuidelinesTest {

    @TestSetup
    static void makeData(){
        List<ContentVersion> contentVersionDocs = new List<ContentVersion>();
        
        ContentVersion conv1 = new ContentVersion();
        conv1.Title = System.Label.IF_Inbound_Sample_Request;
        conv1.PathOnClient = 'IF_Inbound_Sample_Request.pdf';
        conv1.VersionData = Blob.valueOf('IF_Inbound_Sample_Request.pdf');
        conv1.IsMajorVersion = true;
        contentVersionDocs.add(conv1);

        ContentVersion conv2 = new ContentVersion();
        conv2.Title = System.Label.IF_Outbound_Sample_Request;
        conv2.PathOnClient = 'IF_Outbound_Sample_Request.pdf';
        conv2.VersionData = Blob.valueOf('IF_Outbound_Sample_Request.pdf');
        conv2.IsMajorVersion = true;
        contentVersionDocs.add(conv2);

        insert contentVersionDocs;
    }

    @IsTest
    static void testFetchHelpGuidelines(){
        
        System.Test.startTest();
        List<IF_Help_Guidlines__mdt> fetchHelpGuidelines = IF_HelpGuidelines.fetchHelpGuidelines();
        System.Test.stopTest();
        
        System.assertEquals(false, fetchHelpGuidelines?.isEmpty(), 'Metadata records not found');
    }

    @IsTest
    static void testGetSampleRequest1(){
        
        System.Test.startTest();
        String getSampleRequest = IF_HelpGuidelines.getSampleRequest('');
        System.Test.stopTest();
        
        System.assertEquals(true, String.isBlank(getSampleRequest), 'Download URL should be empty or blank');
    }
    
    @IsTest
    static void testGetSampleRequest2(){
        
        System.Test.startTest();
        String getSampleRequest = IF_HelpGuidelines.getSampleRequest(System.Label.IF_Inbound_Guideline_Name);
        System.Test.stopTest();

        System.assertEquals(false, String.isBlank(getSampleRequest), 'Download URL shouldn\'t be empty or blank');
        
    }

    @IsTest
    static void testGetSampleRequest3(){
        
        System.Test.startTest();
        String getSampleRequest = IF_HelpGuidelines.getSampleRequest(System.Label.IF_Outbound_Guideline_Name);
        System.Test.stopTest();

        System.assertEquals(false, String.isBlank(getSampleRequest), 'Download URL shouldn\'t be empty or blank');
        
    }
    
    @IsTest
    static void testGetSampleRequest4(){
        
        System.Test.startTest();
        makeData(); // re-invoking this method to duplicate data
        String getSampleRequest = IF_HelpGuidelines.getSampleRequest(System.Label.IF_Outbound_Guideline_Name);
        System.Test.stopTest();

        System.assertEquals(false, String.isBlank(getSampleRequest), 'Method should throw an exception.');
        
    }
}