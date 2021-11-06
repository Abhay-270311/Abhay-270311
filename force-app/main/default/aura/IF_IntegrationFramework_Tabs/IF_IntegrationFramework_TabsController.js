({
   tabSelected : function(component, event, helper) {
       if(component.get('v.selTabId') == 'three'){
           var selectedTabName = component.get('v.selectedItemOnHelpTab');
           helper.selectedtab(component, event, selectedTabName)
           helper.actionDownload(component, event, selectedTabName);
        }
    },
    
    handleSelect : function(component, event,helper) {
        helper.selectedtab(component, event, component.get('v.selectedItemOnHelpTab'))
        helper.actionDownload(component, event, component.get('v.selectedItemOnHelpTab'));
    },
})