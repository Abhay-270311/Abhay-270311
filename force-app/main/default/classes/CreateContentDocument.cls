public class CreateContentDocument {
    public static void CreateDocument(Blob fileBlobData){
        //Create Document Parent Record
        Account acc = [Select Id, Name From Account Order by CreatedDate desc limit 1];
       
        //Create Document
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Box Document';
        cv.PathOnClient = 'BoxXL.xlsx';
        cv.VersionData = fileBlobData;
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Documents
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        
        //Create ContentDocumentLink 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acc.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
    }
    
    public static void ReadFileContentDoc(){
        ContentVersion cvRecord = [Select id, VersionData from ContentVersion WHERE Id = '0685g000000gvHwAAI'];
        Blob csvFileBody =cvRecord.VersionData; 
        String csvAsString= EncodingUtil.base64Decode(EncodingUtil.base64Encode(csvFileBody)).toString();
        List<String> csvFileLines= csvAsString.split('\n');
        system.debug(csvFileLines);
        //String s = EncodingUtil.base64Decode(EncodingUtil.base64Encode(cvRecord.VersionData)).toString();
        //system.debug('Response from xlsx: ' + s);
    }
}