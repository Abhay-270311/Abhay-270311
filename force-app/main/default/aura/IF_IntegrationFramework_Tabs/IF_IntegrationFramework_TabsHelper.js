({
    selectedtab : function(component, event, selectedTabName) {
        var selected = event.getParam('name');
        component.set('v.currentContent', selectedTabName);
        var action = component.get("c.fetchHelpGuidelines");
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                component.set("v.inboundGuidelines",records[0].Inbound_Help_Guidelines__c);
                component.set("v.outboundGuidelines",records[0].Outbound_Help_Guidelines__c);
            }
        });
        $A.enqueueAction(action);
    },
  
    actionDownload : function(component, event, selectedTabName){
        var action = component.get("c.getSampleRequest");
         action.setParams({
           "guidelineName" : component.get('v.currentContent')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                component.set("v.baseURL",records);
            }
        });
        $A.enqueueAction(action);
    }
    
})