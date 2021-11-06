({
    //get sObject list and Named Credentials
    doInit : function(component, event, helper) {
        helper.getsObjectListJS(component);
        helper.getNamedCredentials(component);
        helper.getConnectionTypeJS(component);
    },
    
    //show main screen on connection type selection
    onChangeConnectionType :function(component, event, helper) {
        if(component.get("v.filteredsObjectFields") != '' || component.get("v.sObjectAPI") != undefined || component.get("v.childSObjectAPI") != undefined
           || component.get("v.systemName") != undefined || component.get("v.systemName") != null) {
            component.set("v.showConnTypeModal", true);
        } else {
            component.set("v.showMainScreen", true);
            component.set("v.isInputDisabled", false);
            component.set("v.tempConnType", component.get("v.connType"));
        }
        
        console.log('====connType=====',component.get("v.connType"));
        if(!component.get("v.connType")) {
            component.set("v.showMainScreen", false);
        }
    },
    
    onchangeSystemName : function(component, event, helper) {
        component.set("v.isInputDisabled", false);

        if(component.get("v.filteredsObjectFields") != '' || component.get("v.sObjectAPI") != undefined || component.get("v.childSObjectAPI") != undefined){
            component.set("v.showSysNameModal", true);
        }
        else{
            if(component.get("v.connType") == "Existing") {
                var systemName = component.find("sysNameLst").get("v.value");
                component.set("v.systemName", systemName);   
            }
        }
    },
    
    //get all related sObject list 
    getRelatedsObjectList : function(component, event, helper) {
        var systemName = component.get("v.systemName");
        
        if(!systemName) {
            helper.showToast("ERROR!", "error", "Please enter the System Name to proceed");
            component.find("sObjectList").set("v.value", "");
        } else {
            if(component.get("v.filteredsObjectFields") != '') {
                component.set("v.showModal", true);
            }
            else {
                helper.getRelatedsObjectListJS(component);
            }
        }
    },
    
    //get all sObject fields
    getsObjectFieldList : function(component, event, helper) {
        if(component.get("v.filteredsObjectFields") != '') {
            component.set("v.showChildModal", true);
        }
        else {
            helper.getsObjectFieldListJS(component);
        }
    },
    
    //get existing metadata details on change of Named Credentials
    getExistingDetails : function(component, event, helper) {
        var namedCred = component.find("namedCred").get("v.value");
        if(namedCred) {
            helper.getExistingDetailsJS(component);    
        }
    },
    
    //filter field list 
    filterData : function(component, event, helper) {
        helper.filterDataJS(component);
    },
    
    //save metada details 
    saveMetaDataDetails : function(component, event, helper) {
        helper.saveMetaDataDetailsJS(component);
    },
    
    //sort the field list based on available mappings
    handleSorting : function(component, event, helper) {
        helper.handleSortingJS(component, event);
    },
    
    //refresh current view on cancel button
    refreshView :function(component, event, helper) {
        helper.refreshViewJS(component);
    },
    
    //handle confirmation modal button click 
    handleConfirmation : function(component, event, helper) {
        var buttonName = event.getSource().get("v.name");
        switch (buttonName) {
            case "CONNECTIONCHANGE": {
                component.set("v.showConnTypeModal", false);
                component.set("v.showMainScreen", true);
                component.set("v.isInputDisabled", false);
                component.set("v.systemName", "");
                component.set("v.isSaveDisabled", true);
                component.set("v.showParentNodeName", false);
                component.set("v.showChildNodeName", false);
                component.set("v.tempNameCredName", "");  
                component.set("v.tempConnType", component.get("v.connType"));
                component.find("sObjectList").set("v.value", "");
                component.set("v.sObjectAPI", "");
                component.set("v.childSObjectAPI", "");
                break;
            }
            case "CONNECTIONCLOSE": {
                component.set("v.showConnTypeModal", false);
                component.set("v.connType", component.get("v.tempConnType"));
                break;
            }
            case "PARENTCHANGE": {
                component.set("v.showModal", false);
                component.set("v.showParentNodeName",false);
                component.set("v.showChildNodeName",false);
                helper.getRelatedsObjectListJS(component);
                break;
            }
            case "PARENTCLOSE": {
                var sObjectAPI = component.get("v.sObjectAPI");
                var sObjectLabel = component.get("v.sObjectLabel");
                component.find("sObjectList").set("v.value", sObjectAPI +'#'+ sObjectLabel);
                component.set("v.showModal", false);
                break;
            }
            case "CHILDCHANGE": {
                component.set("v.showChildModal", false);
                helper.getsObjectFieldListJS(component);
                break;
            }
            case "CHILDCLOSE": {
                var sObjectAPI = component.get("v.sObjectAPI");
                var sObjectLabel = component.get("v.sObjectLabel");
                component.find("childsObjectList").set("v.value", sObjectAPI +'#'+ sObjectLabel);
                component.set("v.showChildModal", false);
                break;
            }
        }
    },
    
    //check the entered system name is exist or not, if exist then show an error
    checkExistingSystemName : function(component, event, helper) {
        var sysNameList = component.get("v.sysNameList");
        var systemName = component.get("v.systemName");

        if(sysNameList.findIndex(item => systemName.toLowerCase() === item.toLowerCase()) !== -1){ 
            helper.showToast("ERROR!", "error", 'This system name already exist in database, please provide unique name or check with existing connection type'); 
            component.set("v.isInputDisabled", true);
        }
        else{
            component.set("v.isInputDisabled", false);
        }
    }
})