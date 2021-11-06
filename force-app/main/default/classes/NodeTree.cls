public class NodeTree {

    public class Root{
        String u_name;
        String u_parent_name;
        Integer level;
        List<Root> children;
        public Root (String un, String upn, Integer l, List<Root> chl){
            this.u_name = un;
            this.u_parent_name = upn;
            this.level = l;
            this.children = (chl == null) ? new List<Root>() : chl ;
        }
        public void addChild(Root child) {
        	if (!this.children.contains(child) && child != null)
            	this.children.add(child);
    	}
         public void addChildren(List<Root> child) {
        	//if (!this.children.contains(child) && child != null)
            	this.children = child;
    	}
        public List<Root> getChildren() {
        	return children;
    	}
    }
    
    public class Member{
        String name;
        String parent;
        public Member(String nm, String pr){
            this.name = nm;
            this.parent =pr;
        }
    }
    
    public List<Member> getHierarchy(){
        List<Member> objList = new List<Member>();
        objList.add(new Member( 'Master',  ''));
        objList.add(new Member( 'P1',  'Master'));
        objList.add(new Member( 'C1',  'P1'));
        objList.add(new Member( 'C1GC1',  'C1'));
        objList.add(new Member( 'C1GC2',  'C1'));
        objList.add(new Member( 'P2',  'Master'));
        objList.add(new Member( 'C2',  'P2'));
        objList.add(new Member( 'C2GC1',  'C2'));
        objList.add(new Member( 'C2GC2',  'C2'));
        objList.add(new Member( 'P3',  'Master'));
        objList.add(new Member( 'C3',  'P3'));
        objList.add(new Member( 'C3GC1',  'C3'));
        objList.add(new Member( 'C3GGC1',  'C3GC1'));
        objList.add(new Member( 'C3GGC2',  'C3GC1'));
        return objList;
    }
    
    public List<Root> getDataMap(String pp, List<Member> mbList){
            /* NodeTree nd = new NodeTree();
    
    List<NodeTree.Root> ll = nd.getDataMap('Master', nd.getHierarchy());
    
    system.debug(JSON.serializePretty(ll));
	*/
        List<Root> obj = new List<Root>() ;
        for(Member mm: mbList){
            if(mm.parent != '' && mm.parent == pp){
                obj.add(new Root( mm.name,mm.parent, 0,
                           getDataMap(mm.name, mbList)
                ));
            }
        }
        return obj;
    }
}