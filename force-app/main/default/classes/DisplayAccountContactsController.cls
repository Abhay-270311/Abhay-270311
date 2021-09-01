public with sharing class DisplayAccountContactsController {
    Map<String, List<Contact>> maps;
    public String uName {get{return 'Abhay';} set;}
    public DisplayAccountContactsController(){
        maps = getMapData();
    }
    public Map<String, List<Contact>> getMaps(){
        return maps;
    }
    
    public void actionMethodOne(String param1){
        system.debug('param1' + param1);
    	//return 'String1';   
    }
    public DisplayAccountContactsController(ApexPages.StandardController controller){
        system.debug('1234');
    }

    // Wrapper for account and its contacts
    
    public class AccountWrapper{
        @AuraEnabled public String accId;
        @AuraEnabled public String accName;
        @AuraEnabled public List<ContactWrapper> contacts;
        
    }

    
    public class ContactWrapper{
        @AuraEnabled public String conId;
        @AuraEnabled public String firstName;
        @AuraEnabled public String lastName;
    }

    @AuraEnabled(cacheable=true)
    public static List<AccountWrapper> getMapWrapper(){
        Map<String, List<Contact>> accMap = getMapData();
        List<AccountWrapper> lAcc = new List<AccountWrapper>();
        ContactWrapper cw;
        for(String aKey: accMap.keySet()){
            AccountWrapper ac = new AccountWrapper();
            List<ContactWrapper> lw = new List<ContactWrapper>();
            
            for(Contact cnt: accMap.get(aKey)){
                cw = new ContactWrapper();
                cw.conId = cnt.Id;
                cw.firstName = cnt.FirstName;
                cw.lastName = cnt.LastName;
                lw.add(cw);
            }
            ac.accId = aKey;
            ac.accName = aKey;
            ac.contacts = lw;
            lAcc.add(ac);
        }
        return lAcc;
    }

    @auraEnabled
    public static list<account> getAllAccounts()
    {
       list<account> accs =[select id,name,phone,industry,(select lastName from contacts) from account limit 10];
      //  list<account> accs =[select id,name,phone,industry from account limit 10];
     //   return [select Id,Name from account limit 10];
     return accs;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, List<Contact>> getMapData(){
        Map<String, Map<String,Contact>> temp = new Map<String, Map<String,Contact>>();
        
        for(Contact cnt: [Select Id, FirstName, LastName, Account.Name From Contact LIMIT 20]){
            if(!temp.containsKey(cnt.Account.Name)){
                temp.put(cnt.Account.Name, new Map<String,Contact>());
            }
            temp.get(cnt.Account.Name).put(cnt.FirstName, cnt);
            system.debug('### ' + cnt.Account.Name);
        }
        
        List<String> cnNames = new List<String>();
        
        Map<String, List<Contact>> finalData = new Map<String, List<Contact>>();
        system.debug('KeySet' + temp.keySet());
        for(String m:temp.keySet()){
            List<Contact> cnList = getSortedContacts(temp.get(m));
            finalData.put( m, cnList);
        }
        return finalData;
    }
    
    public static  List<Contact> getSortedContacts( Map<String,Contact> cntToSort ){
        List<String> str = new List<String>(cntToSort.keySet());
        List<Contact> cntListSorted = new List<Contact>();
        str.sort();
        system.debug(str);
        for(String st: str){
            system.debug(str);
            //if(cntToSort.containsKey(st) && cntToSort.get(st) != null)
            	cntListSorted.add(cntToSort.get(st));
            //else
            //    system.debug('### Not Found - ' + st);
        }
        return cntListSorted;
    }

}