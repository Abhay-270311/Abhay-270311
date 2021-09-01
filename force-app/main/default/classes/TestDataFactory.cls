@isTest
public class TestDataFactory {
    public static List<Account> getAccounts(Integer countOfAcc){
        List<Account> actLL = new List<Account>();
        for(Integer i = 1; i <= countOfAcc ; i++ ){
            actLL.add(new Account(Name='Test Acc ' + i));
        }
        
        return actLL;
    }
}