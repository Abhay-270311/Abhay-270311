/*
** ____________________________________________________________________________________________
** Worked By:       Pooja Sharma, Payal Ahuja
** Created Date:    21/03/2021
** ============================================================================================
** Description: Controller Class for Lightning component - 	IF_IntegrationFramework_Tabs
** ____________________________________________________________________________________________
*/
public class IF_HelpGuidelines {     
    /**
        @MethodName : fetchHelpGuidelines
        @Description: To fetch help guidelines for Integration Framework Inbound and Outbound from Custom Metadata 
        @Return     : List of record with label and value
    **/
    
    @AuraEnabled
    public static List <IF_Help_Guidlines__mdt> fetchHelpGuidelines() {
        return [ SELECT Label , Inbound_Help_Guidelines__c, Outbound_Help_Guidelines__c FROM IF_Help_Guidlines__mdt ORDER BY Label];
    }
    /* End */
    
    /**
        @MethodName : getSampleRequest
        @Param      : guidelineName
        @Description: Pulls the sample request file for Integration Framework Inbound and Outbound.
                      Sample request files are stored in Asset Library of the Organization.
        @Return     : Download URL for file.
    **/
    @AuraEnabled 
    public static String getSampleRequest(String guidelineName){
        String BaseURL = ''; 
        String URlDownload ='';
        
        ContentDocument documents = new ContentDocument();
        try {
            if(guidelineName == System.Label.IF_Inbound_Guideline_Name){
                documents = [SELECT ID, Title FROM ContentDocument Where Title =: System.Label.IF_Inbound_Sample_Request];
            }
            else if(guidelineName == System.Label.IF_Outbound_Guideline_Name){
                documents = [SELECT ID, Title FROM ContentDocument Where Title =: System.Label.IF_Outbound_Sample_Request]; 
            }
            
            if(String.isNotBlank(guidelineName) && documents.Id != null) {
                BaseURL =  URL.getSalesforceBaseUrl().toExternalForm();
                URlDownload = BaseURL+'/sfc/servlet.shepherd/document/download/'+documents.Id+'?operationContext=S1'; 
            }
            return URlDownload;
        }
        catch(Exception ex){
            return ex.getMessage();
        }       
    }
    /* End */
}