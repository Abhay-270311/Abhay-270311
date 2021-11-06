public with sharing class GetHierarchy {
    public static Root parent_member;
    public class Root{
    	@AuraEnabled public String name;
        @AuraEnabled public String label;
        @AuraEnabled public Integer expanded;
        @AuraEnabled public List<Root> items;
        public Root (String un, String upn, Integer l, List<Root> chl){
            this.name = un;
            this.label = upn;
            this.expanded = l;
            this.items = (chl == null) ? new List<Root>() : chl ;
        }
       /* public void addChild(Root child) {
        	if (!this.children.contains(child) && child != null)
            	this.children.add(child);
    	}
        public void addChildren(List<Root> child) {
        	//if (!this.children.contains(child) && child != null)
            	this.children = child;
    	}
        public List<Root> getChildren() {
        	return children;
    	}*/
    }
    @AuraEnabled(cacheable = true)
    public static List<Root> printHierarchy(String parentName){
        List<GetHierarchy__c> hierarchyRecords = [SELECT Id,Name, Opportunity_Parent__r.TrackingNumber__c, Opportunity_Parent__r.Name, Opportunity_Child__r.Name, Opportunity_Parent__c, Opportunity_Child__c From GetHierarchy__c ORDER BY Opportunity_Child__r.Name];
        String rootElement = '';
        for(GetHierarchy__c rec: hierarchyRecords){
            if(String.isEmpty(rec.Opportunity_Parent__c)){
                rootElement = rec.Opportunity_Child__r.Name;
            }
        }
        Integer levelCnt = 1;
        System.debug('Master --> ' + rootElement);
        
        parent_member = new Root(rootElement, '', 1, null); //parent
        
		List<Root> children = new List<Root>();
        if(String.isEmpty(parentName)){
            children = walkHierarchy(rootElement, hierarchyRecords);
        } else{
            children = walkHierarchy(parentName, hierarchyRecords);
        }
        Root parent1 = new Root(rootElement, 'Master', 1, children);
        system.debug(JSON.serialize(parent1));
        return new List<Root>{parent1};
    }
    
    public static List<Root> walkHierarchy(String parent, List<GetHierarchy__c> hierarchyRecords){
        
        Integer levelCnt = 0;                                 
        List<Root> obj = new List<Root>() ;
        for(GetHierarchy__c rec: hierarchyRecords){
            if(rec.Opportunity_Parent__r.Name != '' && rec.Opportunity_Parent__r.Name == parent){
                obj.add(new Root( rec.Opportunity_Child__r.Name,rec.Opportunity_Child__r.Name, levelCnt++,
                           walkHierarchy(rec.Opportunity_Child__r.Name, hierarchyRecords)
                ));
                
            }
        }
        return obj;
       
    } 
    
 	/* Java Script:
 	 var directories = [
  {name: 'users' , parent : null },
  {name: 'distalx' , parent : 'users' },
  {name: 'guest' , parent : 'users' },
  {name: 'shared' , parent : 'users' },
  {name: 'documents' , parent : 'distalx' },
  {name: 'music' , parent : 'distalx' },
  {name: 'desktop' , parent : 'distalx' },
  {name: 'javascript' , parent : 'documents' },
  {name: 'funjs' , parent : 'documents' },
  {name: 'functions' , parent : 'documents' }
]


var sortDirectories= function(directories, parent){
  let node = [];
  directories
  .filter(function(d){ return d.parent === parent})
  .forEach(function(d){
    var cd = d;
    cd.child = sortDirectories(directories, d.name);
    return node.push(cd);
  })
  return node;
}

var results = sortDirectories(directories, null);
console.log(JSON.stringify(results, null, ' ')); 

// Sample JSON:
items = [
        {
            "label": 'Master',
            "name": 'Master',
            "expanded": true,
            items:[{"name":"Parent2","label":"Parent2","items":[{"name":"P2 Child1","label":"P2 Child1","items":[{"name":"P2 GrandChild 1","label":"P2 GrandChild 1","items":[],"expanded":0},{"name":"P2 GrandChild 2","label":"P2 GrandChild 2","items":[],"expanded":1}],"expanded":0},{"name":"P2 Child2","label":"P2 Child2","items":[],"expanded":1},{"name":"P2 Child3","label":"P2 Child3","items":[],"expanded":2}],"expanded":0},{"name":"Parent 4","label":"Parent 4","items":[{"name":"Parent 4 Child1","label":"Parent 4 Child1","items":[{"name":"Parent 4 GrandChild1","label":"Parent 4 GrandChild1","items":[{"name":"Parent 4 Great GrandChild1","label":"Parent 4 Great GrandChild1","items":[],"expanded":0},{"name":"Parent 4 Great GrandChild2","label":"Parent 4 Great GrandChild2","items":[],"expanded":1}],"expanded":0}],"expanded":0},{"name":"Parent 4 Child2","label":"Parent 4 Child2","items":[],"expanded":1}],"expanded":1},{"name":"Parent 5","label":"Parent 5","items":[],"expanded":2},{"name":"Parent 8","label":"Parent 8","items":[],"expanded":3},{"name":"Parent 7","label":"Parent 7","items":[],"expanded":4},{"name":"Parent 6","label":"Parent 6","items":[],"expanded":5},{"name":"Parent3","label":"Parent3","items":[],"expanded":6},{"name":"Parent1","label":"Parent1","items":[{"name":"P1 Child1","label":"P1 Child1","items":[{"name":"P1 Grand Child1","label":"P1 Grand Child1","items":[],"expanded":0}],"expanded":0},{"name":"P1 Child2","label":"P1 Child2","items":[{"name":"P1 Grand Child2","label":"P1 Grand Child2","items":[],"expanded":0}],"expanded":1}],"expanded":7}]
    
},]};
*/
}