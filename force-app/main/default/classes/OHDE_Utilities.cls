/**
 * This Contains all common functions
 * Created by - Abhay
 * Created Date - 27-Sept-21
 */
public with sharing class OHDE_Utilities {
    
    public Integer standardObjCnt, customObjCnt;
    //Object Wrapper
    
    public class objectName implements Comparable {
        @AuraEnabled public Boolean isStandard; // true - standard ; false custom 
        @AuraEnabled public String objName;
        @AuraEnabled public String objAPIName;
        @AuraEnabled public Boolean isNameSpacePrefix;
        public ObjectName(Boolean type, String oname, String oapiname, Boolean prefix){
            this.isStandard = type;
            this.objName    = oname;
            this.objAPIName = oapiname;
            this.isNameSpacePrefix = prefix;
        }

        public Integer compareTo(Object compareTo) {
            ObjectName compareToMap = (ObjectName)compareTo;
            if (this.objName == compareToMap.objName) return 0;
            if (this.objName > compareToMap.objName) return 1;
            return -1;        
        }
    }
    
    public class fieldName implements Comparable {
        @AuraEnabled public Boolean isStandard; // true - standard ; false custom 
        @AuraEnabled public String fieldApiName;
        @AuraEnabled public String fieldName;
        @AuraEnabled public String fieldType;
        @AuraEnabled public Boolean isNameSpacePrefix;
        public fieldName(Boolean stand, String fname, String fapiname, String ftype, Boolean prefix){
            this.isStandard = stand;
            this.fieldName    = fname;
            this.fieldApiName = fapiname;
            this.fieldType = ftype;
            this.isNameSpacePrefix = prefix;
        }
        public Integer compareTo(Object compareTo) {
            fieldName compareToMap = (fieldName)compareTo;
            if (this.fieldName == compareToMap.fieldName) return 0;
            if (this.fieldName > compareToMap.fieldName) return 1;
            return -1;        
        }
    }

    // Get the List of Objects
    @AuraEnabled(cacheable=true)
    public static List<objectName> getObjectsList(Boolean skipReadOnly){
        List<objectName> objects = new List<objectName>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
            // TODO - get the object names to skip from metadata setting
            // SELECT NameList__c FROM OHDE_Settings__mdt WHERE label = 'ObjectNamesToSkip'  separated by #
            // Skip read Only objects 
            if( !objTyp.getDescribe().isCreateable() && !objTyp.getDescribe().isSearchable() && skipReadOnly){
                continue;
            }
            //String.valueOf('box_Object__c').split('\\__', 2)[0].contains('__');    
            if(objTyp.getDescribe().isCustom() == false && objTyp.getDescribe().getRecordTypeInfos().size() > 0) {
                objects.add(new objectName(true, objTyp.getDescribe().getLabel(), objTyp.getDescribe().getName( ),
                                          String.valueOf(objTyp.getDescribe().getName( )).split('\\__', 2)[0].contains('__')));
            } else if( objTyp.getDescribe().isCustom()) {
                objects.add(new objectName(false, objTyp.getDescribe().getLabel(), objTyp.getDescribe().getName( ),
                                          String.valueOf(objTyp.getDescribe().getName( )).split('\\__', 2)[0].contains('__')));
            }
        }
        if(objects.size() > 0){
            objects.sort();
        }
        system.debug('Obj ' + objects);
        return objects;
    }

    //
    @AuraEnabled(cacheable=true)
    public Static List<objectName> getObjectsListAPI(String endPoint, String token){
        return new List<objectName>();
    }

    @AuraEnabled(cacheable=true)
    public static List<fieldName> getObjectFields(String objName){
        List<fieldName> fields = new List<fieldName>();
        try{
            Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap();
            for(Schema.SObjectField sfield: fieldMap.Values()) {
                schema.describefieldresult dfield = sfield.getDescribe();
                if(dfield.isCustom() == false ) {
                    fields.add(new fieldName(true, dfield.getLabel(), dfield.getName( ), String.valueOf(dfield.getType()),
                                            String.valueOf(dfield.getName( )).split('\\__', 2)[0].contains('__')));
                } else if( dfield.isCustom()) {
                    fields.add(new fieldName(false, dfield.getLabel(), dfield.getName( ), String.valueOf(dfield.getType()),
                                            String.valueOf(dfield.getName( )).split('\\__', 2)[0].contains('__')));
                }
            }

        } catch(Exception e) {
            system.debug('Exception found for objName : '+objName);
            //TODO: Use Exception handling object Here
        }
        
        if(fields.size() > 0){
            fields.sort();
        }
        return fields;
    }
}