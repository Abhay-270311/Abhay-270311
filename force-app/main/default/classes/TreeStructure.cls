public class TreeStructure{
    @AuraEnabled public String label;
    @AuraEnabled public String name;
    @AuraEnabled public Boolean expanded;
    @AuraEnabled public List<TreeStructure> items;
    public TreeStructure(String label, String name, Boolean expanded, List<TreeStructure> items){
        this.label = label;
        this.name = name;
        this.expanded = expanded;
        if(items != null && items.size() > 0){
            this.items = items;
        }else{
            this.items = new List<TreeStructure>();
        }
    }
}