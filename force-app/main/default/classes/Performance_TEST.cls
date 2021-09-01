@isTest
public class Performance_TEST {
    @testSetup public static void setUpTEST(){
        List<Account> actLL = TestDataFactory.getAccounts(200);
        insert actLL;
        Integer cnt = 0;
        for(Account acL: [Select id, Name from Account LIMIT 149]){
            acL.AnnualRevenue = 100;
            //update acL;
        }
        system.debug('Cnt ' + cnt);
    }
    
    @isTest
    private static void firstTEST(){
        Integer countOfAcc = 200;
        system.debug('Before:: ' + Limits.getHeapSize());
        List<Account> actLL = new List<Account>();
        for(Integer i = 1; i <= countOfAcc ; i++ ){
            actLL.add(new Account(Name='Test Acc ' + i));
        }
        insert actLL;
        actLL.clear();
        system.debug('After:: ' + Limits.getHeapSize());
    }
}