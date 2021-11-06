public with sharing class OHDE_ObjectData {
    @AuraEnabled(cacheable=true)
    public static List<ObjectWrapper> getsObjects(){
        List<ObjectWrapper> objectWrapperL = new List<ObjectWrapper>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
            String name = objTyp.getDescribe().getName();
            String label = objTyp.getDescribe().getLabel();
            if(!name.containsignorecase('history') && !name.containsignorecase('tag') &&
               !name.containsignorecase('share') && !name.containsignorecase('feed') && 
               !name.containsignorecase('group') && !name.containsignorecase('public') &&
               !objTyp.getDescribe().isCustomSetting() && objTyp.getDescribe().isCreateable() &&
               objTyp.getDescribe().getRecordTypeInfos().size() > 0){      
                   ObjectWrapper owObj = new ObjectWrapper();
                   owObj.label = label;
                   owObj.value = name;                   
                   objectWrapperL.add(owObj);
               }            
        }
        System.debug(objectWrapperL);
        return objectWrapperL;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getCustomFields(String selectedObject){         
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap();
        List<String> strList = new List<String>();  
        for(String str : objectFields.keySet()){
            if(str.endsWith('__c')){
                strList.add(str);
            }
        }    
        System.debug('cFields'+strList);
        if(strList.size() > 0){
            return strList;
        }
        else{
            return new List<String>{'No Custom Fields Found on Selected Object...'};
        }
    }

    public class ObjectWrapper{
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;
    }
}