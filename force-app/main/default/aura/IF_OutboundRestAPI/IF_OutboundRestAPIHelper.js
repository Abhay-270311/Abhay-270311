({
    //refresh view 
    refreshViewJS : function(component) {
        component.set("v.showMainScreen", false);
        component.set("v.isSaveDisabled", true);
        component.set("v.connType", '--None--');
        component.set("v.systemName", '');
        if(component.get("v.tempNameCredName") != null && component.get("v.tempNameCredName") != 'undefined'){
            component.set("v.tempNameCredName", '');
        }
        component.set("v.showParentNodeName", false);
        component.set("v.showChildNodeName", false);
        component.set("v.tempNameCredName", '');  
    },
    
    //to get the existing system names if connType is Existing
    getConnectionTypeJS: function(component) {
        var action = component.get("c.getSystemNameList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('==state==',state,'==result==',result);
            if(state === "SUCCESS") {
                component.set("v.sysNameList", result);    
            } else {
                this.showToast("ERROR!", "error", response.getError());
            }
        });
        $A.enqueueAction(action); 	    
    },
    
    //get all available sobject list
    getsObjectListJS : function(component) {
        //show loading symbol
        var spinner;
        window.setTimeout(
            $A.getCallback(function() {
                spinner = component.find("myspinner");
                $A.util.removeClass(spinner, "slds-hide");
            }), 500
        );
        
        var action = component.get("c.getsObjects");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('==state==',state,'==result==',result);
            
            if(state === "SUCCESS") {
                component.set("v.sObjects", result);    
            } else {
                this.showToast("ERROR!", "error", response.getError());
            }
            $A.util.addClass(spinner, "slds-hide");
        });
        $A.enqueueAction(action); 
    },
    
    //get all sObject list related to parent sObject
    getRelatedsObjectListJS : function(component) {
        var spinner = component.find("myspinner");
        $A.util.removeClass(spinner, "slds-hide");
        
        component.set("v.parentNodeName", null);
        component.set("v.childNodeName", null);
        component.set("v.parentMetaDataName", null);
        component.set("v.sObjectFields", null); 
        component.set("v.showParentNodeName", false);
        component.set("v.showChildNodeName", false);
        
        var sObjectAPI_Label = component.find("sObjectList").get("v.value");
        var sObjectAPI = sObjectAPI_Label.split("#")[0];
        var sObjectLabel = sObjectAPI_Label.split("#")[1];
        
        component.set("v.sObjectAPI", sObjectAPI);    
        component.set("v.sObjectLabel", sObjectLabel); 
        
        console.log('==sObjectAPI==',sObjectAPI,'==sObjectLabel==',sObjectLabel);
        
        var action = component.get("c.getRelatedsObjects");
        action.setParams({
            "sObjectAPI" : sObjectAPI
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('==state==',state,'==result==',result);
            
            if(state === "SUCCESS") {
                component.set("v.relatedsObjects", result);   
            }
            else {
                this.showToast("ERROR!", "error", response.getError());
            }
            $A.util.addClass(spinner, "slds-hide");
        });
        $A.enqueueAction(action); 
    },
    
    //get all fields for the selected sObjects
    getsObjectFieldListJS : function(component) {
        //show loading symbol
        var spinner = component.find("myspinner");
        $A.util.removeClass(spinner, "slds-hide");
        
        component.set("v.parentNodeName", null);
        component.set("v.childNodeName", null);
        component.set("v.showParentNodeName", false);
        component.set("v.showChildNodeName", false);
        
        var sObjectAPI_Label = component.find("childsObjectList").get("v.value");
        var sObjectAPI = sObjectAPI_Label.split("#")[0];
        var externalNodeNameMap = component.get("v.externalNodeNameMap");
        console.log('==parentMetaDataName==',component.get("v.parentMetaDataName"));
        
        var sObjectAPIParent_Label = component.find("sObjectList").get("v.value");
        var sObjectParentAPI = sObjectAPIParent_Label.split("#")[0];
        
        console.log('==sObjectAPI==',sObjectAPI, '==sObjectParentAPI==', sObjectParentAPI);
        
        if(sObjectParentAPI == sObjectAPI){
            component.set("v.showParentNodeName", true);
        }
        if(sObjectParentAPI != sObjectAPI){
            component.set("v.showParentNodeName", true);
            component.set("v.showChildNodeName", true);
        }
        
        var action = component.get("c.getsObjectFields");
        action.setParams({
            "sObjectAPI" : sObjectAPI,
            "parentMetaDataName" : component.get("v.parentMetaDataName")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('==state==',state,'==result==',result);
            
            if(state === "SUCCESS") {
                component.set("v.sObjectFields", result);
                component.set("v.filteredsObjectFields", result);
                component.set("v.isSaveDisabled", false);
                
                console.log('==externalNodeNameMap==',JSON.stringify(externalNodeNameMap),'==sObjectAPI==',sObjectAPI,'==sObjectParentAPI==',sObjectParentAPI);
                if(externalNodeNameMap && externalNodeNameMap[sObjectAPI]) {
                    component.set("v.childNodeName", externalNodeNameMap[sObjectAPI]);
                }
                if(externalNodeNameMap && externalNodeNameMap[sObjectParentAPI]) {
                    component.set("v.parentNodeName", externalNodeNameMap[sObjectParentAPI]);
                }
            } else {
                this.showToast("ERROR!", "error", response.getError());
            }
            $A.util.addClass(spinner, "slds-hide");
        });
        $A.enqueueAction(action); 
    },
    
    //get existing metada details if any exist with combination of object name and named creds name
    getExistingDetailsJS : function(component) {
        //show loading symbol
        var spinner = component.find("myspinner");
        $A.util.removeClass(spinner, "slds-hide");
        
        component.set("v.parentNodeName", null);
        component.set("v.childNodeName", null);
        component.set("v.parentMetaDataName", null);
        component.set("v.sObjectFields", null); 
        
        var action = component.get("c.getExistingMetaData");
        action.setParams({
            "sObjectAPI" : component.get("v.sObjectAPI"),
            "namedCredName" : component.find("namedCred").get("v.value"),
            "systemName" : component.get("v.systemName")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('==state==',state,'==result==',result);
            
            if(state === "SUCCESS") {
                if(result) {
                    component.set("v.parentMetaDataName", result.parentMetaDataName);
                    component.set("v.externalNodeNameMap", result.externalNodeNameMap);
                    
                    window.setTimeout(
                        $A.getCallback(function() {
                            var childsObjectList = component.find("childsObjectList");
                            childsObjectList.set("v.value", "");
                            component.set("v.sObjectFields", []);
                        }), 100
                    );
                }
            } else {
                this.showToast("ERROR!", "error", response.getError());
            }
            $A.util.addClass(spinner, "slds-hide");
        });
        $A.enqueueAction(action); 
    },
    
    //filter field table based on field name
    filterDataJS : function(component) {
        var searchText = component.get("v.searchText").toLowerCase() || '';
        var lstFieldWrapper = component.get("v.sObjectFields")        
        console.log('==searchText',searchText);
        var filteredsObjectFields = lstFieldWrapper.filter(row => row.fieldAPI.toLowerCase().indexOf(searchText) !== -1);
        console.log('==lstFieldWrapper==',filteredsObjectFields.length);
        component.set("v.filteredsObjectFields", filteredsObjectFields);   
    },
    
    //save parent metadata record to salesforce
    saveMetaDataDetailsJS : function(component) {
        //show loading symbol
        var spinner = component.find("myspinner");
        $A.util.removeClass(spinner, "slds-hide");
        
        var action = component.get("c.saveMetaDataInfo");
        action.setParams({
            "sObjectAPI" : component.get("v.sObjectAPI"),
            "sObjectLabel" : component.get("v.sObjectLabel"),
            "namedCredName" : component.find("namedCred").get("v.value"),
            "systemName" : component.get("v.systemName")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('==state==',state,'==result==',result);
            
            if(state === "SUCCESS") {
                if(result.includes("SUCCESS#")) {
                    this.saveMetaDataMappingsJS(component, result.split("#")[1]);
                } else {
                    this.showToast("ERROR!", "error", result);
                }
            } else {
                this.showToast("ERROR!", "error", response.getError());
            }
            $A.util.addClass(spinner, "slds-hide");
        });
        $A.enqueueAction(action); 
    },
    
    //save mapping metadata record to salesforce
    saveMetaDataMappingsJS : function(component, metaDataName) {
        console.log('==saveMetaDataMappingsJS==',metaDataName);
        //show loading symbol
        var spinner = component.find("myspinner");
        $A.util.removeClass(spinner, "slds-hide");
        
        var sObjectAPI_Label = component.find("childsObjectList").get("v.value");
        var sObjectAPI = sObjectAPI_Label.split("#")[0] || '';
        var sObjectLabel = sObjectAPI_Label.split("#")[1] || '';
        var lstFieldWrapper = component.get("v.filteredsObjectFields") || [];
        
        var sObjectParentAPI_Label = component.find("sObjectList").get("v.value");
        var sObjectParentAPI = sObjectParentAPI_Label.split("#")[0];
        var externalNodeNameMap = component.get("v.externalNodeNameMap");
        
        console.log('==sObjectAPI==',sObjectAPI);
        console.log('==sObjectLabel==',sObjectLabel);
        console.log('==metaDataName==',metaDataName);
        console.log('==lstFieldWrapper==',lstFieldWrapper);
        console.log('==parentNodeName==',component.get("v.parentNodeName"));
        console.log('==childNodeName==',component.get("v.childNodeName"));
        if(!externalNodeNameMap) {
            externalNodeNameMap = {};
        }
        externalNodeNameMap[sObjectAPI] = component.get("v.childNodeName");
        externalNodeNameMap[sObjectParentAPI] = component.get("v.parentNodeName");
        component.set("v.externalNodeNameMap", externalNodeNameMap);
        console.log('==externalNodeNameMap==',JSON.stringify(component.get("v.externalNodeNameMap")));
        
        var action = component.get("c.saveMetaDataMappingsInfo");
        action.setParams({
            //"sObjectParentAPI" : sObjectParentAPI,
            "sObjectAPI" : sObjectAPI,
            "sObjectLabel" : sObjectLabel,
            "metaDataName" : metaDataName,
            "parentNodeName" : component.get("v.parentNodeName"),
            "childNodeName" : component.get("v.childNodeName"),
            "lstFieldWrapper" : lstFieldWrapper
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('==state==',state,'==result==',result);
            
            if(state === "SUCCESS") {
                if(result.includes("SUCCESS")) {
                    this.showToast("SUCCESS!", "success", "Mapping record creation process is queued");
                } else {
                    this.showToast("ERROR!", "error", result);
                }
            } else {
                this.showToast("ERROR!", "error", response.getError());
            }
            $A.util.addClass(spinner, "slds-hide");
        });
        $A.enqueueAction(action); 
    },
    
    //sort data list
    handleSortingJS : function(component, event) {
        var sortBy = event.currentTarget.dataset.columnName;
        var sortDirection = component.get("v.sortDirection");
        if(sortBy === component.get("v.sortBy")) {
            sortDirection = (sortDirection !== "asc") ? "asc" : "desc";    
        }
        else {
            sortDirection = "asc";
        }
        component.set("v.sortBy", sortBy);
        component.set("v.sortDirection", sortDirection);
        this.sortTableData(component, sortBy, sortDirection);
    },
    
    //sort data list
    sortTableData : function(component, fieldName, sortDirection){
        console.log('==fieldName==',fieldName,'==sortDirection==',sortDirection);
        var sObjectFields = component.get("v.filteredsObjectFields");
        //function to return the value stored in the field
        var key = function(row) {return row[fieldName];}
        var reverse = sortDirection == 'asc' ? 1: -1;
        
        sObjectFields.sort(function(a,b) {
            var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
            var b = key(b) ? key(b).toLowerCase() : '';
            return reverse * ((a>b) - (b>a));
        });    
        
        //set sorted data to sObjectFields list
        component.set("v.filteredsObjectFields", sObjectFields);
    },
    
    //show toast message
    showToast : function(title, toastType, message, duration){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "type":toastType,
            "message": message,
            "duration" : (duration) ? duration : 5000
        });
        toastEvent.fire(); 
    },
    
    //get all available named credentials records
    getNamedCredentials :  function(component) {
        var action = component.get("c.getAllNamedCredentialURLs");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('==state==',state,'==result==',result);
            
            if(state === "SUCCESS") {
                component.set("v.namedCreds", result);
            } else {
                this.showToast("ERROR!", "error", response.getError());
            }
        });
        $A.enqueueAction(action); 
    }
})