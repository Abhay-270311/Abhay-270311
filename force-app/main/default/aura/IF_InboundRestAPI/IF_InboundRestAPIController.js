({
    doInit : function(component, event, helper) {
        helper.getsObjectListJS(component, event, helper);
        helper.getConnectionTypeJS(component, event);
    },
    
    getRelatedsObjectList : function(component, event, helper) {
        if(component.get("v.filteredsObjectFields") != ''){
            component.set('v.showModal', true);
        }
        else{
            helper.getRelatedsObjectListJS(component);    
        }
    },
    
    getsObjectFieldList : function(component, event, helper) {
        if(component.get("v.filteredsObjectFields") != ''){
            component.set('v.showChildModal', true);    
        }
        else{
        	 helper.getsObjectFieldListJS(component);    
        }
    },
    
    saveMetaDataDetails :function(component, event, helper) {
       helper.saveMetaDataDetailsJS(component);
    },
    
    filterData : function(component, event, helper) {
        helper.filterDataJS(component);
    },
    
    handleSorting : function(component, event, helper) {
        helper.handleSortingJS(component, event);
    },
    
    cancelDetails :function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    }, 
    
    /*showSpinner: function(component, event, helper) {
        component.set("v.spinner", true); 
    },*/
    
    hideSpinner : function(component,event,helper){
        component.set("v.spinner", false);
    },
    
    closeModal : function(component, event, helper) {
        var initObjAPI = component.get('v.sObjectAPI');
        var initObjLabel = component.get('v.sObjectLabel');
        component.find("sObjectList").set("v.value", initObjAPI +'#'+ initObjLabel);
        component.set('v.showModal',false);
    },
    
    YesMethod :function(component, event, helper) {
        var hideModal = component.get('v.showModal');
        component.set('v.showModal', !hideModal);
        component.set("v.filteredsObjectFields",'');
        component.find("childsObjectList").set("v.value", null);
        component.set("v.showNodeNm",false);
        component.set("v.showSubNodeNm",false);
        helper.getRelatedsObjectListJS(component); 
    },
    
    closeChildModal : function(component, event, helper) {
        var initChildObjAPI = component.get('v.childSObjectAPI');
        var initChildObjLabel = component.get('v.childSObjectLabel');
        var relationshipName = component.get('v.relationshipName');
        if(relationshipName!=null){
         	 component.find("childsObjectList").set("v.value", initChildObjAPI + '#' + initChildObjLabel +'#' + relationshipName);   
        }else{
            component.find("childsObjectList").set("v.value", initChildObjAPI + '#' + initChildObjLabel);   
        }
        component.set('v.showChildModal',false);
    },
    
    YesChildMethod :function(component, event, helper) {
        var hideModal = component.get('v.showChildModal');
        component.set('v.showChildModal', !hideModal);
        component.set("v.filteredsObjectFields",'');
        helper.getsObjectFieldListJS(component); 
    },
    
    getConnectionType :function(component, event, helper) {
        if(component.get("v.filteredsObjectFields") != '' || component.get('v.sObjectAPI')!= undefined || component.get('v.childSObjectAPI')!= undefined
          || component.get('v.systemName')!=undefined || component.get('v.systemName') != null){
            component.set('v.showConnectionModal', true);
        }
        else{
           component.set("v.showMainScreen", true);
           component.set("v.connTypeName", component.find("connType").get("v.value"));
        }
    },
    
    onchangeSystemName : function(component, event, helper) {
        component.set("v.isDisableInputLst",false);
        console.log('******'+component.get('v.sObjectAPI'));
        if(component.get("v.filteredsObjectFields") != '' || component.get('v.sObjectAPI')!= undefined || component.get('v.childSObjectAPI')!= undefined){
            component.set('v.showSysNameModal', true);
        }
        else{
            if(component.get('v.connType') == 'Existing'){
                var systemName = component.find("sysNameLst").get("v.value");
                component.set('v.systemName',systemName.trim());   
        	}
        }
      console.log('systemName*******'+component.get('v.systemName'));
    },
    
    yesSysNameMethod : function(component, event, helper) {
        var hideModal = component.get('v.showSysNameModal');
        component.set('v.showSysNameModal', !hideModal);
        component.set("v.filteredsObjectFields",'');
        component.find("sObjectList").set("v.value", null);
        component.find("childsObjectList").set("v.value", null);
        component.set("v.showNodeNm",false);
        component.set("v.showSubNodeNm",false);
        component.set("v.sObjectFields", null);
        component.set('v.sObjectAPI',null);
        component.set('v.childSObjectAPI',null);
        var systemName = component.find("sysNameLst").get("v.value");
        component.set('v.systemName',systemName); 
        console.log('SystemName ********'+component.get('v.systemName'));
    },
    
    closeSysNameModal :function(component, event, helper) {
        component.find("sysNameLst").set("v.value", component.get('v.systemName'));
        console.log('******'+component.get('v.sObjectAPI'));
        console.log('******'+component.get('v.childSObjectAPI'));
        component.set('v.showSysNameModal',false);
    },
    
    checkExistingSystemName : function(component, event, helper) {
        var sysNameLst = component.get("v.sysNameLst");
        var sysName = component.get("v.systemName");
        if(sysNameLst.findIndex(item => sysName.toLowerCase() === item.toLowerCase())!== -1){ 
            helper.showToast("ERROR!", "error", 'This system name already exist in database, please provide unique name or check with existing connection type'); 
            component.set("v.isDisableInputLst",true);
		}
        else{
            component.set("v.isDisableInputLst",false);
        }
    },
    
    yesConnectionMethod :function(component, event, helper) {
        var hideModal = component.get('v.showConnectionModal');
        component.set('v.showConnectionModal', !hideModal);
        component.set("v.filteredsObjectFields",'');
        component.find("sObjectList").set("v.value", null);
        component.find("childsObjectList").set("v.value", null);
        component.set("v.showNodeNm",false);
        component.set("v.showSubNodeNm",false);
        component.set("v.sObjectFields", null);
        component.set('v.sObjectAPI',null);
        component.set('v.childSObjectAPI',null);
        component.set('v.systemName',null)
        var connType = component.find("connType").get("v.value");
        component.set('v.connType',connType); 
        component.set("v.connTypeName", component.find("connType").get("v.value"));
    },
    
    closeConnectionModal :function(component, event, helper) {
        console.log('connTypeName'+component.get("v.connTypeName"));
        component.find("connType").set("v.value", component.get("v.connTypeName"));
        if(component.get("v.connType") == 'Existing'){
        	 component.find("sysNameLst").set("v.value", component.get('v.systemName'));
        }
    	component.set('v.showConnectionModal',false);    
    }
})