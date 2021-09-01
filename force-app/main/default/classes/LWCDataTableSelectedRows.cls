public class LWCDataTableSelectedRows {
	@AuraEnabled(cacheable=true)
    public static List<Contact> getContactList() {
        return [SELECT Id, FirstName, LastName, Title, Phone, Email FROM Contact LIMIT 10];
    }
    
    @AuraEnabled(cacheable=true)
    public static void selectedContactList(List<Contact> selectedContacts) {
        system.debug('List ' + selectedContacts);
    }
}