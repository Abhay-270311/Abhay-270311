public class ExtendFirst extends ExtendCore {
    public void childMethod(){
        system.debug('childmethod');
    }
    
    public override String getname(){
        system.debug('Child Abhay');
        return 'Child Abhay';
    }
    /* 
        String jsonString = '[{"Name":"A1"},{"Name":"A2"}]';
        Type t = Type.forName('List<Account>');
        List<SObject> lo = (List<SObject>)JSON.deserialize(jsonString, t);
        for (SObject o : lo) {
            System.debug(o.getSObjectType().getDescribe().getName() + ', Name: ' + o.get('Name'));
        }
	*/
}