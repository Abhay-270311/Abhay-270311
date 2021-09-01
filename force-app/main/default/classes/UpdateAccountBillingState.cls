global class UpdateAccountBillingState implements Database.Batchable<UpdateAccountBillingState.WrapperObj>, Database.Stateful {
    global Iterable<UpdateAccountBillingState.WrapperObj> start(Database.BatchableContext bc) {
        List<UpdateAccountBillingState.WrapperObj> accs = new List<UpdateAccountBillingState.WrapperObj>();
	        for( Account accT: [SELECT ID,Name,BillingState,BillingCountry, (Select FirstName, email from Contacts) FROM Account]){
            accs.add(new UpdateAccountBillingState.WrapperObj(accT, accT.Contacts));
        }
        return accs;
        //List<Account> actList = [SELECT ID,Name,BillingState,BillingCountry, (Select FirstName, email from Contacts) FROM Account];
        //return actList;
        //return Database.getQueryLocator(
        //    'SELECT ID,Name,BillingState,BillingCountry FROM Account Where BillingCountry =\'USA\' AND BillingState =\'\''
        //);
    }
    global void execute(Database.BatchableContext bc, List<object> scope){
        // process each batch of record
        List<UpdateAccountBillingState.WrapperObj> lstAccount = (List<UpdateAccountBillingState.WrapperObj>)scope;
        for (UpdateAccountBillingState.WrapperObj acc : lstAccount) {
            
            if(acc.conList != null && acc.conList.size() > 0){
            	system.debug(acc.accRec.Name + ' ' + acc.conList[0]);
            }
        }
        
        //update lstAccount;
    }
    global void finish(Database.BatchableContext bc){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
 
      // Use the
      AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors,
      a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,
      a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
 
      // below code will send an email to User about the status
      String[] email = new String[]{'.com'};
      mail.setToAddresses(email);
      mail.setReplyTo('test@test.com'); // Add here your email address
      mail.setSenderDisplayName('Apex Batch Processing Module');
      mail.setSubject('Batch Processing '+a.Status);
      mail.setPlainTextBody('The Batch Apex job processed '+ a.TotalJobItems+'batches with '+a.NumberOfErrors+'failures '+'Job Itemprocessed are '+a.JobItemsProcessed);
     // Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
    } 
    
    global class WrapperObj{
        global Account accRec;
        global Contact[] conList;
        global WrapperObj(Account aC, Contact[] cL){
            accRec = aC;
            conList = cL;
        }
            
    }
 
}