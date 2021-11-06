({
    getsObjectListJS : function(component, event, helper) {
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
    
    getRelatedsObjectListJS : function(component) {
        var spinner = component.find("myspinner");
        $A.util.removeClass(spinner, "slds-hide");
        
        component.set("v.sObjectFields", null); 
        component.set("v.showNodeNm",false);
        component.set("v.showSubNodeNm",false);
        component.set("v.nodeName",null);
        component.set("v.subNodeName",null);
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
    
    getsObjectFieldListJS : function(component) {
        var spinner = component.find("myspinner");
        $A.util.removeClass(spinner, "slds-hide");
        
        component.set("v.showNodeNm",false);
        component.set("v.showSubNodeNm",false);
        component.set("v.nodeName",null);
        component.set("v.subNodeName",null);
        var sObjectAPI_Label = component.find("childsObjectList").get("v.value");
        var childSObjectAPI = sObjectAPI_Label.split("#")[0];
        var childSObjectLabel = sObjectAPI_Label.split("#")[1];
        if(sObjectAPI_Label.split("#")[2]!=undefined){
            component.set("v.relationshipName",  sObjectAPI_Label.split("#")[2]);    
        }
        else{
            component.set("v.relationshipName", null);    
        }
        component.set("v.childSObjectAPI", childSObjectAPI);    
        component.set("v.childSObjectLabel", childSObjectLabel);
        var nodeNm = component.get("v.sObjectAPI");
        var subNodeNm = component.get("v.childSObjectAPI");
        var relationshipName = component.get("v.relationshipName");
        console.log('nodeNm********'+nodeNm);
        console.log('subNodeNm********'+subNodeNm);
        if(nodeNm == subNodeNm && relationshipName == null){
            component.set("v.showNodeNm", true);
        }
        else if(nodeNm == subNodeNm && relationshipName != null){
            component.set("v.showNodeNm", true);
            component.set("v.showSubNodeNm", true);
        }
        else if(nodeNm != subNodeNm){
            component.set("v.showNodeNm", true);
            component.set("v.showSubNodeNm", true);
        }
        var action = component.get("c.getsObjectFields");
        action.setParams({
            "sObjectAPI" : childSObjectAPI,
            "parentMetaDataId" : 'Node_Name__mdt',
            "sysName" : component.get("v.systemName"),
            "connType" : component.get("v.connType")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('==state==',state,'==result==',result);
            if(state === "SUCCESS") {
                component.set("v.sObjectFields", result); 
                component.set("v.filteredsObjectFields", result);  
                component.set("v.isDisabled", false);   
            } else {
                this.showToast("ERROR!", "error", response.getError());
            }
            $A.util.addClass(spinner, "slds-hide");
        });
        this.getNodeAndSubnodeNameFmMtd(component);
        $A.enqueueAction(action); 
    },
    
    getNodeAndSubnodeNameFmMtd :function(component){
        if(component.get("v.connType") == 'New'){
            component.set("v.nodeName", null); 
            component.set("v.subNodeName", null); 
        }
        else if(component.get("v.connType") == 'Existing'){
        	var action = component.get("c.getNodenSubNodeNmFromMtd");
            action.setParams({
                "sObjectAPI" : component.get("v.sObjectAPI"),
                "childSObjectAPI" : component.get("v.childSObjectAPI"),
                "sysName" : component.get("v.systemName"),
                "relationshipName" : component.get("v.relationshipName")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var result = response.getReturnValue();
                console.log('==state==',state,'==result==',result);
                if(state === "SUCCESS") {
                    if(result[0]!= 'NA'){
                        component.set("v.nodeName", result[0]);     
                    }
                    if(result[1]!= 'NA'){
                        component.set("v.subNodeName", result[1]); 
                    }
                }else {
                    this.showToast("ERROR!", "error", response.getError());
                }
            });
            $A.enqueueAction(action);     
        }    	
    },
    
    saveMetaDataDetailsJS : function(component) {
        var spinner = component.find("myspinner");
        $A.util.removeClass(spinner, "slds-hide");
        
        var nodeNm = component.get("v.sObjectAPI");
        var subNodeNm = component.get("v.childSObjectAPI");
        console.log('nodeNm********'+nodeNm);
        console.log('subNodeNm********'+subNodeNm);
        var sysNameLst = component.get("v.sysNameLst");
        var sysName = component.get("v.systemName");
        if(component.get("v.connType") == 'New' && (component.get("v.systemName") == null || component.get("v.systemName") == undefined || component.get("v.systemName") == '')){
        	this.showToast("ERROR!", "error", $A.get("$Label.c.IF_SysName_validation_error"));     
        }
        else if(component.get("v.connType") == 'New' && (sysNameLst.findIndex(item => sysName.toLowerCase() === item.toLowerCase())!== -1)){
            this.showToast("ERROR!", "error", $A.get("$Label.c.IF_DuplicateName_validation_error")); 
		}
        else if(component.get("v.connType") == 'Existing' && (component.get("v.systemName") == null || component.get("v.systemName") == undefined)){
        	this.showToast("ERROR!", "error",  $A.get("$Label.c.IF_SysName_Validation_Error_existingSys"));     
        }
        else if(nodeNm == subNodeNm && (component.get("v.nodeName") == null || component.get("v.nodeName") == undefined || component.get("v.nodeName") == '')){
            this.showToast("ERROR!", "error", $A.get("$Label.c.IF_Parent_Node_Name_Validation_Error"));    
        }
        else if(nodeNm == subNodeNm && component.get("v.relationshipName")!=null && (component.get("v.subNodeName") == null || component.get("v.subNodeName") == undefined || component.get("v.subNodeName") == '')){
            this.showToast("ERROR!", "error", $A.get("$Label.c.IF_Child_Node_Name_Validation_Error"));    
        }
        else if(nodeNm != subNodeNm && (component.get("v.nodeName") == null || component.get("v.nodeName") == undefined || component.get("v.nodeName") == '')){
        	this.showToast("ERROR!", "error", $A.get("$Label.c.IF_Parent_Node_Name_Validation_Error"));     
        }
        else if(nodeNm != subNodeNm && (component.get("v.subNodeName") == null || component.get("v.subNodeName") == undefined || component.get("v.subNodeName") == '')){
        	this.showToast("ERROR!", "error", $A.get("$Label.c.IF_Child_Node_Name_Validation_Error"));     
        }
        else if(subNodeNm !=null  && component.get("v.nodeName") == component.get("v.subNodeName")){
            this.showToast("ERROR!", "error", $A.get("$Label.c.IF_Same_NodeName_Error"));  
		}
        else{
             var action = component.get("c.saveMetaDataMappingsInfo");
             //console.log('component.get("v.sObjectAPI")---'+component.get("v.sObjectAPI"));
             //console.log('component.get("v.sObjectLabel")---'+component.get("v.sObjectLabel"));
             //console.log('component.get("v.childSObjectAPI")---'+component.get("v.childSObjectAPI"));
             //console.log('component.get("v.childSObjectLabel")---'+component.get("v.childSObjectLabel"));
             //console.log('component.get("v.relationshipName")---'+component.get("v.relationshipName"));
             //console.log('component.get("v.sObjectFields")---'+JSON.stringify(component.get("v.sObjectFields")));
             //console.log('component.get("v.nodeName")---'+component.get("v.nodeName"));
             //console.log('component.get("v.subNodeName")---'+component.get("v.subNodeName"));
            action.setParams({
                "sObjectAPI" : component.get("v.sObjectAPI"),
                "sObjectLabel" : component.get("v.sObjectLabel"),
                "childSObjectAPI" :component.get("v.childSObjectAPI"),
                "childSObjectLabel" :component.get("v.childSObjectLabel"),
                "relationshipName":component.get("v.relationshipName"),
                "lstFieldWrapper" : component.get("v.sObjectFields"),
                "nodeNm" : component.get("v.nodeName"),
                "subNodeNm" : component.get("v.subNodeName"),
                "sysName" : component.get("v.systemName")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var result = response.getReturnValue();
                console.log('==state==',state,'==result==',result);
                if(state === "SUCCESS") {
                    if(result.includes("SUCCESS")) {
                        this.showToast("SUCCESS!", "success", $A.get("$Label.c.IF_Success_Message"));
                        $A.get('e.force:refreshView').fire();
                    } else {
                       this.showToast("ERROR!", "error", result);
                    }
                } else {
                   this.showToast("ERROR!", "error", response.getError());
                }
                $A.util.addClass(spinner, "slds-hide");
            });
        }
        $A.enqueueAction(action); 
    },
    
    filterDataJS : function(component) {
		var searchText = component.get("v.searchText").toLowerCase() || '';
        var lstFieldWrapper = component.get("v.sObjectFields");        
        console.log('==searchText',searchText);
        var filteredsObjectFields = lstFieldWrapper.filter(row => row.fieldAPI.toLowerCase().indexOf(searchText) !== -1);
        console.log('==lstFieldWrapper==',filteredsObjectFields.length);
		component.set("v.filteredsObjectFields", filteredsObjectFields);   
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
    
    getConnectionTypeJS: function(component, event) {
        var action = component.get("c.getSystemNameLst");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('==state==',state,'==result==',result);
            if(state === "SUCCESS") {
                component.set("v.sysNameLst", result); 
            } else {
                this.showToast("ERROR!", "error", response.getError());
            }
        });
        $A.enqueueAction(action); 	
    },
    
    showToast : function(title, toastType, message, duration){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "type":toastType,
            "message": message,
            "duration" : (duration) ? duration : 5000
        });
        toastEvent.fire(); 
    }
})