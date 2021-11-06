public class LWCGetAcctOpty {
    public class ActWrapper{
        @AuraEnabled public String actId;
        @AuraEnabled public String actName;
        @AuraEnabled public List<Opportunity> op_list;
        public ActWrapper(String acId,String acName, List<Opportunity> opL) {
            this.actId = acId;
            this.actName = acName;
            this.op_list = opL;
        }
    }
    public class OptWrapper{
        @AuraEnabled public Opportunity opt;
        public OptWrapper(Opportunity op){
            this.opt = op;
        }
    }
    
    @AuraEnabled(cacheable = false)
    public static List<ActWrapper> getAcOptyList(){
        List<ActWrapper> actList = new List<ActWrapper>();
        
        List<Account> accList = [SELECT Id, Name, (SELECT Id, Name,StageName, CloseDate from Opportunities) FROM Account LIMIT 20 ];
        for(Account acR: accList){
            actList.add(new ActWrapper(String.ValueOf(acR.Id), acR.Name, acR.Opportunities));
        }
        return actList;
    }
}