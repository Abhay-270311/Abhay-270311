/******************************************************************************
@author      - TBD
@date        - 27/07/2021
@description - Trigger Handler Class for Opportunity
@version     - 1.0
*******************************************************************************/
public with sharing class OpportunityTriggerHandler1 extends TriggerHandler1{
    public static boolean isOppTriggerExecuted = FALSE ;
    private static final string OPP_API = 'Opportunity';
    /***************************************************
    *@description - constructor
    ***************************************************/
    public OpportunityTriggerHandler1() {
        super(OPP_API);
    }
    /***************************************************************************************
    @description : Return the name of the handler invoked
    @return - API name of Opportunity object
    ****************************************************************************************/
    public override String getName() {
        return OPP_API;
    }
    /**************************************************************************************
    @description : Trigger handlers for events
    @param newItems - List of new Opportunities
    ****************************************************************************************/
    public override  void beforeInsert(List<SObject> newItems){
        List<Opportunity> newOpps= new List<Opportunity>();
        newOpps = (List<Opportunity>) newItems;
        
    }
    /**************************************************************************************
    @description : Trigger handlers for events
    @param newItems - List of new Opportunities
    @param newItemsMap - Map of new Opportunities
    @param oldItemsMap - Map of old Opportunities
    ****************************************************************************************/
    public  override void beforeUpdate(List<SObject> newItems, Map<Id, SObject> newItemsMap, Map<Id, SObject> oldItemsMap){

    }
    /**************************************************************************************
    @description : Trigger handlers for events
    @param oldItemsMap - Map of old Opportunities
    ****************************************************************************************/
    public  override void beforeDelete(Map<Id, SObject> oldItemsMap){}
    /**************************************************************************************
    @description : Trigger handlers for events
    @param oldItemsMap - Map of old Opportunities
    ****************************************************************************************/
    public  override void afterDelete(Map<Id, SObject> oldItemsMap) {}
    /**************************************************************************************
    @description : Trigger handlers for events
    @param oldItemsMap - Map of old Opportunities
    ****************************************************************************************/
    public  override void afterUndelete(Map<Id, SObject> oldItemsMap) {}
    /**************************************************************************************
    @description : Trigger handlers for events
    @param newItems - List of new Opportunities
    @param newItemsMap - Map of new Opportunities
    @param oldItemsMap - Map of old Opportunities
    ****************************************************************************************/
    public  override void afterUpdate(List<SObject> newItems, Map<Id, SObject> newItemsMap, Map < Id, SObject > oldItemsMap) {
  
    }
    /**************************************************************************************
    @description : Trigger handlers for events
    @param newItems - List of new Opportunities
    @param newItemsMap - Map of new Opportunities
    ****************************************************************************************/
    public  override void afterInsert(List<Sobject> newItems, Map<Id, Sobject> newItemsMap) {
        
    }
}