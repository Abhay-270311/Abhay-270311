public with sharing class DataFlowAuraController {
    public DataFlowAuraController() {

    }
    @AuraEnabled
    public static List<Opportunity> getOptData(){
        try {
            return [Select Id, Name From Opportunity LIMIT 5];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void setStudentDataList(List<Object> lstOpps){
        try {
            system.debug(lstOpps);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<WrapperClass> getStudentData(){
        try {
            List<WrapperClass> studentList = new List<WrapperClass>();
            studentList.add(
                new WrapperClass( 'Abhay' , 'Lalpotu', 'A01', false)
            );
            studentList.add(
                new WrapperClass( 'Nitish' , 'Sharma', 'A02', false)
            );
            studentList.add(
                new WrapperClass( 'Ayush' , 'Khare', 'A03', false)
            );
            return studentList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

    }

    @AuraEnabled
    public static void setStudentData(String lstStudents){
        System.debug(lstStudents);
		List<WrapperClass> wrpList = (List<WrapperClass>) JSON.deserialize(lstStudents, List<WrapperClass>.class);
        for(WrapperClass temp:wrpList){
            system.debug('FirstName '+ temp.sFirstName);
        }
    }

    public class WrapperClass{
        @AuraEnabled
        public string sFirstName;
        @AuraEnabled
        public string sLastName;
        @AuraEnabled
        public string sId;
        @AuraEnabled
        public Boolean isSelected;

        public WrapperClass(String sFN, String sLN, String sID, Boolean sSelected){
            this.sFirstName = sFN;
            this.sLastName = sLN;
            this.sId = sID;
            this.isSelected = sSelected;
        }
    }
}